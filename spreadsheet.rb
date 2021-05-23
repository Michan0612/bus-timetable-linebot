require 'google_drive'

session = GoogleDrive::Session.from_config('config.json')

sheets = session.spreadsheet_by_key("1BklO8x1UMdaeNsNU6IO2nO_Yxw58HsRDbD6oHafY9e4").worksheet_by_title("バス時刻表")
# スプレッドシートへの書き込み
# p sheets.rows(3)[1..2]
# p sheets.cols

# p sheets.num_rows
# p sheets.num_cols

# (1..sheets.num_rows).each do |row|
#   (1..sheets.num_cols).each do |col|
#     p sheets[row, col]
#   end
# end

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



#差分の中で一番小さい値
# p array.min

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

p d, e

#Hashを並び替える

# h = { 30 => "9:10", 20 => "10:15", 40 => "11:45", 50 => "14:50", -10 => "8:40"}
# array_re = []
# h.each do |key, val|
#   if (key > 0)
#     array_re << [key, val]
#   end
# end

# p array_re.class
# p array_re.sort.to_h
# p array_re.sort.first(2).to_h.values
# p array_re.sort.first(2).to_h.values[0]

# p h.sort.to_h


