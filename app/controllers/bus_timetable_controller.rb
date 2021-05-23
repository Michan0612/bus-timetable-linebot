class BusTimetableController < ApplicationController
  protect_from_forgery except: [:callback]

  require 'google_drive'



  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless client.validate_signature(body, signature)
      return head :bad_request
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          case event.type
            # ユーザーからテキスト形式のメッセージが送られて来た場合
          when Line::Bot::Event::MessageType::Text
            # event.message['text']：ユーザーから送られたメッセージ
            time_now = set_time 
            input = event.message['text']
            # 当日朝のメッセージの送信の下限値は20％としているが、明日・明後日雨が降るかどうかの下限値は30％としている
            min_per = 30
            case input
              # 「中央病院」というワードが含まれる場合
            when /.*(中央病院).*/
              push = "#{time_now}"
            end
          end
          message = {
            type: 'text',
            text: push
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def set_time
    session = GoogleDrive::Session.from_config('config.json')
    sheets = session.spreadsheet_by_key("1BklO8x1UMdaeNsNU6IO2nO_Yxw58HsRDbD6oHafY9e4").worksheet_by_title("バス時刻表")

    array = []
    t = []
    
    now = Time.now()
    
    now_w = Time.now().wday
    
    now_time = now.strftime('%H:%M').delete(":").to_i
    
    if (now_w == 0 or 6)
      #差分を取得
      (10..13).each do |row|
        t << sheets[row, 2]
    
        x = sheets[row, 2].delete(":").to_i
        num = x - now_time
    
        array << num
      end
    else
      (2..7).each do |row|
        t << sheets[row, 2]
    
        x = sheets[row, 2].delete(":").to_i
        num = x - now_time
    
        array << num
      end
    end
    
    #Hashに変換して、正の値のみ取得
    if array == nil 
      p "本日のバスはもうありません。次のバスは翌日になります。平日の場合は8:02、休日の場合は9:20分になります。"
    else 
      ary = [array,t].transpose
      x = Hash[*ary.flatten]
    end
    
    c = []
    x.each do |a, b|
      if(a > 0)
        c << [a, b]
      end
    end
    
    if (Hash[*c.flatten].values.size == nil)
      p "本日のバスはもうありません。次のバスは翌日になります。平日の場合は8:02、休日の場合は9:20分になります。"
    elsif (Hash[*c.flatten].values.size == 1)
      d = Hash[*c.flatten].values[0]
    else
      d = Hash[*c.flatten].values[0]
      e = Hash[*c.flatten].values[1]
    end
  end
end
