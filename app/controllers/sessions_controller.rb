class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user=User.find_by(email: params[:session][:email].downcase)
    # 入力されたemailをすべて小文字にしたものがemailに適合するUserを格納する。
    # newのform_withのところでscopeを:sessionにしたから、取り出す時はこうしないといけないだけ！
    if user && user.authenticate(params[:session][:password])
      # if user && user.authenticate(params[:session][:password]) と同じ意味になる。同じ変数名の場合は省略することができる。
    # 後半が面白い。パスワード欄に入力されたものをハッシュ化して、userのpassword_digestと等価かどうかを確認する。
    # =>もし等価なら、このメソッドは元のオブジェクトを返すから、true && trueで trueになる。
      log_in user
      # 7行目のuserを指してる。これは、ヘルパーに定義してるメソッドで、以下になってる。
      #    def log_in(user)
      #     session[:user_id]= user.id
      #    end
      remember user
      # カラムのremember_digestにはランダムで２２文字入れたものをハッシュ化したものがvalidetesに触れずに上書きされてる。
      redirect_to user
      # これも鬼の短縮形のやつ、この文字に対応する〇〇_urlが削られてて、引数の（）がなくなってるって考えれば難しくない。
    else
      flash.now[:danger]="**Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end
