require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user= users(:michael)
    @other_user= users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redilect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  # これはログインをしてない状態でログインしてる必要があるページに入ろうとしてるので弾かれる過程を表してる。
  # もし、before_actionが提示されてないと、そのまま通るから、エラーが起きる。

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # ページ描画のgetだけじゃなくて、patchで送信したあともgetのページにうつれるから、それも検証する必要がある。
    # 基本的に、アクションごとにテストは検証していく必要がある。
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  # これはログインをしてない状態でログインしてる必要があるページに入ろうとしてるので弾かれる過程を表してる。
  # もし、before_actionが提示されてないと、そのまま通るから、エラーが起きる。
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    # 普通にログイン（管理者ではない。 admin:false）
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    # patchで変更してみる！permitで許可されてないけどどうなるか。
    assert_not @other_user.reload.admin?
    # 今のadminの状態がどうなってるか、変更が許可されてないのが証明できればテストがパスできる。
  end
  
  test "should redilect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  # ログインしてるユーザーが違うユーザの編集画面に行こうとするとフラッシュが表示されて、ホームに戻される。
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  # ログインしてるユーザーと違うユーザーが情報を送信したURIに行こうとするとホームに戻されるかどうかのテスト

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
      # do以下のことを実行して、User.countに変化がなければテストを通過する。
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    # これは管理者ではない人
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

  
end

