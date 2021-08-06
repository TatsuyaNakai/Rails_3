# application controllerみたいなもん。メイラーを合わせたものと考えてもらっていい、？

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  # どこから送られてくるか。の設定
  layout 'mailer'
  # 生成されるHTMLメイラーのレイアウトやテキストのレイアウトを確認できるよ。と
end
