require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # 各テストが走る直前に実行されるメソッド。今回で言うと@userを定義してくれてる
    @user = User.new(name: "Example User", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar")
    
  end
  
  test "should be vaild" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name=" "
    assert_not @user.valid?
    # 空欄を作った。まだvalidateは設定されてないから、trueでパスするけど
    # assert_notでfalseを期待してるから、テストでエラーが出る
    # validatesのpresenceが作られたら、assert_not falseになる。
    # assert_notはfalseを期待してるから、それ通りに進んで、テストをパスする。
  end
  
  test "email should be present" do
    @user.email="   "
    assert_not @user.valid?
    # これもnameのpresence同様でvalidatesの返り値がtrueかfalseか
    # assert_notでそれが何を返してきてるかでテストをパスできるか判断してる。
  end
  
  test "name should not be too long" do
    @user.name="a"*51
    # このaはなんでもいい、笑
    assert_not @user.valid?
    # これは、さっきのpresenceと同じ状態
  end
  
  test "email should not be too long" do
    @user.email= "a"*244+ "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses= %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email =valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
   
  test "email addresses should be unique" do
    duplicate_user= @user.dup
    # ユーザーのコピーを作ったものを、格納してる。
    @user.save
    # すでに元データの方は保存してしまう。次でコピーしたものの有効性を測る。
    assert_not duplicate_user.valid?
  end
   
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
    
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    # ６つの空文字をconfirmationに代入。そこからpasswordに代入
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    # 5つの文字をconfirmationに代入。そこからpasswordに代入
    assert_not @user.valid?
  end
  
  test "authenticate? should return false for a user with nil digest" do
    assert_not @user.authenticate?(:remember, '')
  end
  
    test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      # do以下のことをすることで、第一引数の値が第二引数になるかどうか。
      # 今回でいうと@user.destroyすることでMicropost.countが-1するかどうか。
      # 第二引数の変化があればテストを通過できる。
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    # archerがfollowingの中に入っているかどうか。　false待ち
    michael.follow(archer)
    assert michael.following?(archer)
    # archerがfollowingの中に入っているかどうか。　true待ち
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    # archerがfollowingの中に入っているかどうか。　false待ち
  end
  
   test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    # michaelはlanaをフォローしてる。（relationship.yml参照）
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    # michaelはarcherをフォローしてない。（relationship.yml参照）
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
  
end
