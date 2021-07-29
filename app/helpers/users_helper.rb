module UsersHelper
    # 引数に対応するユーザーのGravatar画像を返す。
    def gravatar_for(user)
        gravatar_id= Digest::MD5::hexdigest(user.email.downcase)
        # MD5っていう仕組みでhexdigestの引数である値をハッシュ化してる。
        gravatar_url= "https://secure.gravatar.com/avatar/#{gravatar_id}"
        # ハッシュ化した値をURLの末尾につけてる。
        image_tag(gravatar_url, alt:user.name, class:"gravatar")
    end
end
