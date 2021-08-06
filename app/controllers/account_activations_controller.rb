class AccountActivationsController < ApplicationController
  def edit
    user=User.find_by(email:params[:email])
    # URLのクエリパラメーターから、emailの情報を拾ってくる。それに合致したUserをuserに格納する。
    if user && !user.activated? && user.authenticate?(:activation, params[:id])
    # 初めだとactivateはfalseなので、通る。authenticated?はhelperのuser.rbで確認できる。
      user.activate
      log_in user
      flash[:success]="Account activated!"
      redirect_to user
    else
      flash[:danger]= "Invalid activation link"
      redirect_to root_url
    end
  end
end
