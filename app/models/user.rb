class User < ApplicationRecord
  attr_accessor :remember_token
  # migrationを設定しなくても、remember_tokenを編集、更新できるようにするため
  
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
  validates :password, presence:true, length: {minimum: 6}, allow_nil: true
  # allow_nilでも、has_secure_passwordの方が優先度が高いから、新規登録の時には文字がないと有効にならないようになってる。
  
  def User.digest(string)
    # これもクラスメソッドを使ってる。
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    # min_cost?はRailsのソースコードで記載されてるメソッド。テスト環境ならtrueを返す。
    # BCrypt /パスワードをハッシュ化するアルゴリズムのこと
    # BCrypt::Engine::MIN_COST / 最小コスト（コストをかければパスワードの推測が難しくなる）で返す。
    # BCrypt::Engine.cost / 基本のコストで返す。
    BCrypt::Password.create(string, cost: cost)
    # 上で定義したコストをかけてstringをハッシュする。
  end 
  # 渡された値をとにかくハッシュ化する関数。（環境によってコストの掛け方変えるよ）
  
  def User.new_token
    SecureRandom.urlsafe_base64
    # クラスメソッドで呼び出してる。SecureRandomはもとからRubyに備わってるライブラリ
    # SecureRandom /安全に乱数を出力するためのモジュール
    # urlsafe_base64 /64文字の中から、ランダムに22文字が使用されて文字列を作る。
  end
  
  def remember
    self.remember_token= User.new_token
    # カラムに定義してないremember_tokenに22文字の乱数を代入
    # remember_tokenはmigrateしてないから、保存はできるけど、取得も更新もできない。
    # だからattr_accessorを作った。そこに代入するためにselfをつけてる。
    update_attribute(:remember_digest, User.digest(remember_token))
    # 第一引数を第二引数の値に更新する。update_attributeはvalidatesを完全にスルーできる。
    # カラムに設定したremember_digestを変更した。
    # ちなみに、update_attriburesはvalidatesの制約を受ける。
  end
  # カラムのremember_digestにはランダムで２２文字入れたものをハッシュ化したものが上書きされてる。
  
  def authenticate?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # 引数に渡された値が、remember_digestの値と等しいかどうかを真偽値で返すメソッドを作った。
    # ちなみに、ここのremember_tokenはattr_accessorのremember_tokenとは全く関係ない。ただの引数として考える。
  end
  
  def forget
    update_attribute(:remember_digest, nil)
    # validatesなしでremember_digestを全くないものにさせる。
  end
  
end