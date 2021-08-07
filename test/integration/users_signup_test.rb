require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    # deliberiesは変数。これを初期化してる。
    
  end
  
  test "invalid signup infomation" do
    get signup_path
    # まずは、サインアップのページに移る。
    assert_no_difference 'User.count' do
  # 引数にとったものが、ブロックを実行する前と後で変化がないかを見る。
  # 今回においては、UserCountが変わらなければテストをパスすることができる。
      post users_path, params: {user:{ name: "",
                                      email: "user@invalid",
                                      password: "foo",
                                      password_confirmation:"bar"} }
# 新規ユーザを作成するアクションでパラメータは以下にする。
# 名前は空欄で、パスワードは文字足らず、confirmeとは文字が違う、いわゆるエラーが出る状態
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    # assert_selectは以降に書くものが、そのHTMLに存在するかどうかを検証する。
    # もしあれば、パスできる。
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account actiovation" do
    get signup_path
    assert_difference 'User.count', 1 do
    # 実行前と後で引数の値に変化が起こったらテストをパスすることができる。
      post users_path, params:{user:{name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"} }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 配信されたメッセージが1つかどうかを確認してる。
    
    user = assigns(:user)
    # 対応するアクションからuserインスタンスにアクセスできるようにしてる。
    assert_not user.activated?
    # 新規登録した瞬間はactivatedは一律でfalseで設定してる。
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    # reloadはデータベースの情報を再取得するメソッド読み込んだら、activatedはどうなってますか。=>true待ち
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
end
