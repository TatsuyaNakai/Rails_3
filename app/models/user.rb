class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  # migrationを設定しなくても、remember_tokenを編集、更新できるようにするため
  
  # before_save {self.email= email.downcase}
  # 書き換えようと思ったら↓も可能。破壊的メソッドにしないと元データを変えれないので注意する。
  # before_save {email.downcase!}
  # データベースに保存される直前に全ての文字を小文字に変える処理を書く。
  # before_saveが保存されう直前を表してる。
  #  これをオブジェクトで作らずに、メソッドで参照させた形が以下になる。（こっちが推奨の書き方）
  before_save :downcase_email
  # downcase_emailには、「self.email= email.dowcase」が格納されてる。
  # 使い方としては、参照をプライベート関数内に置いただけ。それが保存、更新される前に呼び出される。直感的で見やすい。（before_actionみたいな）
  before_create :create_activation_digest
  # 新規作成する前に、これを実行する。
  
  
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
  
  def authenticate?(attribute, token)
    digest= self.send("#{attribute}_digest")
    # 第一引数に渡されたもの次第でattributeが変わる(sendの引数には、シンボル、文字列で入れるとメソッドが入るようになってる。)から、それによってdigestも変化する。
    # このdigestは文字列として入るんじゃなくて、しっかり参照を持ったものとして入る。
    # ちなみにselfが省略できるから、以下の形でも書くことができる。
    # digest= send("#{attribute}_digest")
    return false if digest.nil?
    # このダイジェストはそもそも存在してる？
    BCrypt::Password.new(digest).is_password?(token)
    # 〇〇_digestとtokenを比較する。
    # Password.newはハッシュ化してて比較できないところを比較できる形に変換してくれる。ハッシュを超えてくる
  end
  
  def forget
    update_attribute(:remember_digest, nil)
    # validatesなしでremember_digestを全くないものにさせる。
  end
  
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    # validatesをスルーさせたいから、わざわざ2行にしてupdate_attributeにしてる。 
    update_columns(activated:true, activated_at:Time.zone.now)
    # validatesをスルーさせて複数のカラムを更新する時は、updates_columnsが便利
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
    # UserMailerはaccount_activationのメソッドがどこにあるかを明示。
    # account_activationはアクション名、引数に@userをもってすぐに送信する。
    # 今すぐメールを送信するから、deliver_now, 非同期通信で行う場合は、deliver_laterと書く
  end
  
  def create_reset_digest
    self.reset_token= User.new_token
    # ２２文字のランダムな文字を格納
    # update_attribute(:reset_digest, User.digest(reset_token))
    # ハッシュ化したものをバリデーションを通さずに保存
    # update_attribute(:reset_sent_at, Time.zone.now)
    # Time.zoneを更新する。
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
    # UserMailernのクラスメソッドを(user)で実行してる。
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
    # 2時間以内、2時間より早い時間
    # create_reset_digestメソッドがよばれた時点でreset_sent_atが更新されてる。
    # create_reset_digestがよばれるのは、new_password_resetsのsubmitが押されたタイミング（createアクションが発火する。）
    # 2時間以内であればtrueを返す。
  end
  
  
  
  
  # ---------------------------------------------------------------
  private
    def downcase_email
      self.email.downcase!
    end
    
    def create_activation_digest
      self.activation_token= User.new_token
      # dbには保存してないから、attr_accessorで作成してる。
      self.activation_digest= User.digest(activation_token)
      # dbに保存してる。activation_token をハッシュ化したもの。
    end
  
end