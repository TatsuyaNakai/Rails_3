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
        # これはカラムに登録してるわけじゃない。attr_accessorで編集、取得ができるようになってるもの
    end
    
    def current_user
        if(user_id = session[:user_id])
            # user_idにsessionのuser_idを代入した場合。
            # もしsession[:user_id]がなければ、そもそも代入ができない。nil=>falseでif内に入れない。
            @current_user ||= User.find_by(id:user_id)
            # session[:use_id]が決まってるのであれば、それをcurrent_userにする処理 
        elsif (user_id = cookies.signed[:user_id])
            # cookiesの中に入ってる復号化したuser_idを代入することができるかどうかの条件分岐
            # cookieになければ代入できない。nil=>falseで下の分岐に入れない。
            user=User.find_by(id: user_id)
            if user && user.authenticate?(:remember, cookies[:remember_token])
                # cookies[:remember_token]は13行目で定義してるuser.remember_tokenにあたる。
                # それは、9行目で定義してるmodel/user.rbのrememberメソッドにあたる。
                # このままじゃハッシュ化されてないから値が揃わない。はず
                log_in user
                @current_user= user
            end
        end
    end
    
    def current_user?(user)
        user && user == current_user
        # 前方は必ずtrue, 後方がいまログインしてるユーザーと引数が一致するかどうか。一致すればtrueを返す。
    end
    
    def forget(user)
        user.forget
        # remember_digestをnilにしてる。
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
        # それぞれのcookiesを削除する。２０年間継続しないようにしてもらう。
    end
    
    def log_out
        forget(current_user)
        session.delete(:user_id)
        # sessionからuser_idを削除する。継続していたのをなくす処理。
        @current_user= nil
    end
    # 長期保存しない処理（forgetメソッド）と今現在のログインしてるsessionもぬけてしまう処理を書いてる。
    
    def logged_in?
        !current_user.nil?
    # current_userが空白なら、true...やけど、！なので、ログインしていなかったらfalseを渡す！
    end
    
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url]|| default)
        # もしsession[:forwarding_url]が格納されてなければnil=>falsyな値　やから、引数のデフォルトにリダイレクトする。
        # もしsessionがあればsessionのページ(request.original_urln)にリダイレクトする。
        session.delete(:forwarding_url)
        # session[:forwarding_url]を削除する。
    end
    
    def store_location
        session[:forwarding_url]= request.original_url if request.get?
        # session変数を使用して、URLを記憶させてる。
        #  if request.get?　URLはGETアクションか。それなら条件分岐に入る。
        # request.original_urlはリクエスト先が取得できる。（公式チュートリアルがいってる。）
    end
    
end
