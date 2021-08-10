class ApplicationController < ActionController::Base
    include SessionsHelper
    # ヘルパーモジュールにSessionsHelperがモジュールかされてるから、
    # それをコントローラーの親クラス（ここ）で書くことで全コントローラーで書ける
    
    # -------------------------------------------------
    private
    
    def logged_in_user
        unless logged_in?
            store_location
            # 本来行きたかったであろうURIをsession[:forwarding_url]に格納しておく。
            flash[:danger]= "Please log in."
            redirect_to login_url
        end
    end
    
end
