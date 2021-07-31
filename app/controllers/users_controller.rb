class UsersController < ApplicationController

  def show
    @user=User.find(params[:id])

  end
    
  def new
    @user=User.new
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      log_in @user
      # log_inは、session[:user_id]に引数に与えたもの（@user）を追加すること。sessionのコントローラーで定義してる。
      
      flash[:success]="Welcome to the sample App!"
      # bootstrapは、success, info, warning, dangerの４つの種類でcssを持ってる。から、successにしてる。
      redirect_to user_url(@user)
    else
      render "new"
    end
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
  
  
end
