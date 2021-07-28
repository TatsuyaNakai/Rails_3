class User < ApplicationRecord
  before_save {self.email= email.downcase}
  # 書き換えようと思ったら↓も可能。破壊的メソッドにしないと元データを変えれないので注意する。
  # before_save {email.downcase!}
  # データベースに保存される直前に全ての文字を小文字に変える処理を書く。
  # before_saveが保存されう直前を表してる。
  
  validates :name, presence: true, length:{maximum:50}
  # validatesはメソッドで短縮しない書き方やと以下で書ける。
  # validates(:name, presence: true)
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # 正規表現で表した形＝＞これはいつもよく見る形のアドレスの型
  validates :email, presence: true, length:{maximum:255}, 
        format:{ with: VALID_EMAIL_REGEX }, uniqueness:true
          
  has_secure_password
  # これで、ハッシュ化したセキュアなパスワードが完成する。
  validates :password, presence:true, length: {minimum: 6}
  
end