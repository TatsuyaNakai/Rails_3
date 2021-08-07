class PasswordResetsController < ApplicationController
  before_action :get_user,          only: [:edit, :update]
  before_action :valid_user,        only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]
  
  
  # edit, updateの処理を実行する前にget_user, valid_userを実行する。
  
  def new
  end
  
  def create
    @user=User.find_by(email: params[:password_reset][:email].downcase)
    # フォームタグに記入されたemail_fieldの内容を参照してそのアドレスをもつユーザーを@userにしてる
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info]="Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger]="Email address not found"
      render 'new'
      # これはアクション名を表してる。user::newでもいいし。:newでもページは遷移される。
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      # 新しいパスワードが空文字だった場合の処理
      @user.errors.add(:password, :blank)
      # パスワードのカラムが空白になってますよ！のデフォルトのエラーメッセージが送信される。
      # addの第一引数はカラムを選択することができて、第二引数はメッセージ内容（今回は:blankやから、デフォルトになってる）を追加できる。
      # errorsは、Errorクラスのインスタンスを1つ返す。
      render 'edit'
    elsif @user.update(user_params)
      # user_paramsメソッドを使って不要な更新は避けるフィルターをかけるためにプライベートメソッドに移動
      # きっちり条件を満たして通った場合
      log_in @user
      flash[:success]="Password has been reset."
      redirect_to @user
    else
      render 'edit'
      # コントローラー名を軸に持って、'edit'のアクションを探す。
    end
  end
  
  
  
  # ---------------------------------------------------------
  private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
    # 不正されないようにuserテーブルのpassword, password_confirmationだけを更新できるようにフィルターをかけてる。
  end
  
  def get_user
    @user= User.find_by(email: params[:email])
    # クエリパラメーター化したemailを取得できる。
    # （editは、開いてるページのURLから。updateはhidden_fiels_tagから取得する。）
  end
  
  def valid_user
    unless (
      @user && @user.activated? && @user.authenticate?(:reset, params[:id])
      # get_userで定義された@userがこっちにも適応してる。before_actionが影響してる。
      # 初めの有効化は終わらせてるから、true, 次はcreateアクションでカラムにダイジェスト
      # が格納されてるから、Password.newでハッシュ化を除けばtrueなので、true判定
      )
      redirect_to root_url
    end
  end
  
  def check_expiration
    if @user.password_reset_expired?
      # トークンが有効期限切れかどうかを判断する。　User.rbで定義してる。
      flash[:danger]= "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end
  
end
