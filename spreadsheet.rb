require 'google_drive'

session = GoogleDrive::Session.from_config('config.json')

sheets = session.spreadsheet_by_key("1BklO8x1UMdaeNsNU6IO2nO_Yxw58HsRDbD6oHafY9e4").worksheet_by_title("バス時刻表")
# スプレッドシートへの書き込み
sheets[1, 1] = "Hello World"
# シートの保存
sheets.save
