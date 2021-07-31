module SessionsHelper
    
    def log_in(user)
        session[:user_id]= user.id
    # 保持された状態になる！！がsessionの効果！=>ステートフルになる。
    end
    
    def log_out
        session.delete(:user_id)
    # sessionからuser_idを削除する。継続していたのをなくす処理。
        @current_user=nil
    end
    
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        # session[:use_id]が決まってるのであれば、それをcurrent_userにする処理 
        end
    end
    
    def logged_in?
        !current_user.nil?
    # current_userが空白なら、true...やけど、！なので、falseを渡す！
    end
end
