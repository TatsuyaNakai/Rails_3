class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user=User.find_by(email: params[:session][:email].downcase)
    # 入力されたemailをすべて小文字にしたものがemailに適合するUserを格納する。
    # newのform_withのところでscopeを:sessionにしたから、取り出す時はこうしないといけないだけ！
    if user && user.authenticate(params[:session][:password])
    # 後半が面白い。パスワード欄に入力されたものをハッシュ化して、userのpassword_digestと等価かどうかを確認する。
    # =>もし等価なら、このメソッドは元のオブジェクトを返すから、true && trueで trueになる。
      if user.activated?
        log_in user
        # 7行目のuserを指してる。これは、ヘルパーに定義してるメソッドで、以下になってる。
        #    def log_in(user)
        #     session[:user_id]= user.id
        #    end
        params[:session][:remember_me]== '1'? remember(user): forget(user)
        # カラムのremember_digestにはランダムで２２文字入れたものをハッシュ化したものがvalidetesに触れずに上書きされてる。
        redirect_back_or(user)
        # storeからきてるなら、forward_urlは入ってるから、そのページに遷移する。
        # そうでないのであれば、user(鬼の短縮系になってるやつ、〇〇_urlが削られ、引数の（）がなくなった版：下の行参考に。)
        
        # redirect_to user
        # これも鬼の短縮形のやつ、この文字に対応する〇〇_urlが削られてて、引数の（）がなくなってるって考えれば難しくない。
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        # messageの変数に足してるだけ(笑)
        flash[:warning] = message
        redirect_to root_url
      end
      
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
