class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  # なんらかの処理(action)が実行される前(before)に処理(method)を特定の(only)アクションでかける。
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: [:destroy]
  # destroynに移るときにadmin_userを実行する。
  
  def index
    @users=User.where(activated:true).paginate(page: params[:page])
  end

  def show
    @user=User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end
    
  def new
    @user=User.new
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info]="Please check your email to activate your account!"
      # bootstrapは、success, info, warning, dangerの４つの種類でcssを持ってる。
      redirect_to root_url
    else
      render "new"
      # これはアクション名を書いてる。（routesの一番右側に書いてる。）
      # action::newでもいいし、短縮で:new でいい。シンボルじゃなくて、クォーテーションが今回の場合なだけ。
    end
  end
  
  def edit
    @user= User.find(params[:id])
  end
  
  def update
    @user= User.find(params[:id])
    if @user.update(user_params)
      # ここでも悪用されたら困るから、プライベートメソッドで許可されたものだけを更新する。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
      # アクション名を書いてる。
      # createアクションの時はクォーテーションやったから、今回はシンボルで書いた。
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success]= "User deleted"
    redirect_to users_url
  end
  
  private
  # 外部からは触ることができないようにプライベートメソッドとして使用
  # 安全性を高めるために必要。今はこれを打たないとエラーが出る
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  # paramsは、formタグで送られてきたもの全ての情報を取得している。 
  # requireはモデルの指定をする、許可するカラムはpermit以降のみそれ以外は許可しない。
    end
    
    def logged_in_user
      unless logged_in?
        # ifの逆のことfalseの時に分岐の中に入れる。
        store_location
        # 本来行きたかったであろうURIをsession[:forwarding_url]に格納しておく。
        flash[:danger]="Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user= User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
      # ここのcurrent_userはsession_helperで定義してる。ヘルパーはどこで読み込ませてもどこからでも参照できる。
      # 分割した方が見やすくなるため。これはケンタさんに確認済み
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
      # adminがfalseなら、root_url(ホーム)に戻るようなシステムになってる。
    end
  
  
end
