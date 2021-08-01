module SessionsHelper
    
    def log_in(user)
        session[:user_id]= user.id
    # 保持された状態になる！！がsessionの効果！=>ステートフルになる。
    end
    
    def remember(user)
        user.remember
        # カラムのremember_digestにはランダムで２２文字入れたものをハッシュ化したものが上書きされてる。
        cookies.permanent.signed[:user_id]=user.id
        # ログイン時のそのuser_idを暗号化したものを20年の制約をつけてuser_idとしてcookiesに保存した。
        cookies.permanent[:remember_token]= user.remember_token
        # ログイン時のそのremember_tokenを22文字の乱数を20年の制約をつけてremember_tokenとしてcookiesに保存した。
    end
    
    def current_user
        if(user_id = session[:user_id])
            # user_idにsessionのuser_idを代入した場合。
            # もしsession[:user_id]がなければ、そもそも代入ができない。nil=>falseでif内に入れない。
            @current_user ||= User.find_by(id:user_id)
            # session[:use_id]が決まってるのであれば、それをcurrent_userにする処理 
        elsif (user_id = cookies.signed[:user_id])
            # もし、cookiesの中に入ってる復号化したuser_idを代入することができれば
            # cookieになければ代入できない。nil=>falseで下の分岐に入れない。
            user=User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                # cookies[:remember_token]は13行目で定義してるuser.remember_tokenにあたる。
                # それは、9行目で定義してるmodel/user.rbのrememberメソッドにあたる。
                # このままじゃハッシュ化されてないから値が揃わない。はず
                log_in user
                @current_user= user
            end
        end
    end
    
    def log_out
        session.delete(:user_id)
    # sessionからuser_idを削除する。継続していたのをなくす処理。
        @current_user=nil
    end
    
    def logged_in?
        !current_user.nil?
    # current_userが空白なら、true...やけど、！なので、falseを渡す！
    end
end
