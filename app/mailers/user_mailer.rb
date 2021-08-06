# いつものコントローラに値するところ。変数とか、メソッド、ルーティングアクションをかける。

class UserMailer < ApplicationMailer
  def account_activation(user)
    @user= user
    mail to: user.email, subject: "Account activation"
  end
  # account_activationが呼ばれるとメイラーが指定のタイミングで送信されるようになる。ページが描写されるわけではない。メールが送られるのである。

  # def password_reset
  #   @greeting = "Hi"
  #   # インスタンス変数が定義されてるように、普通のビューみたいにコントローラのインスタンスを使える。

  #   mail to: "to@example.org"
  # end
end
