require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis/analytics_v3'
require 'google_drive'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

token_store_file = 'credentials.yaml'
scope = Google::Apis::AnalyticsV3::AUTH_ANALYTICS # == "https://www.googleapis.com/auth/analytics"
client_id = Google::Auth::ClientId.from_file('client_secret_637937849971-aikjhgpslt6iqmjpueo5it5ar8v4d4ri.apps.googleusercontent.com') # ダウンロードしたファイル


token_store = Google::Auth::Stores::FileTokenStore.new(file: token_store_file)
authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

credentials = authorizer.get_credentials('default')
if credentials.nil?
  # 初回のみ必要な処理。ブラウザでURLを開き承認すると、credentials.yamlが作成される。
  # 次回以降はこのymlファイルを使って自動で認証が進む
  url = authorizer.get_authorization_url(base_url: OOB_URI)
  puts "Open #{url} in your browser and enter the resulting code:"
  code = gets
  credentials = authorizer.get_and_store_credentials_from_code(user_id: 'default', code: code, base_url: OOB_URI)
end

analytics = Google::Apis::AnalyticsV3::AnalyticsService.new
analytics.authorization = credentials



session = GoogleDrive::Session.from_config('config.json')

spreadsheet = session.spreadsheet_by_key("1BklO8x1UMdaeNsNU6IO2nO_Yxw58HsRDbD6oHafY9e4")
puts spreadsheet.inspect

worksheets = spreadsheet.worksheets
puts worksheets.inspect

worksheet = spreadsheet.worksheet_by_title('バス時刻表')
puts worksheet.inspect

rows = worksheet.rows
puts rows.inspect

cel = rows[0][0]
puts cel

cel = worksheet[1,1]
puts cel
