require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }
    # password_resetコントローラーのcreateアクション参照
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # メールアドレスが有効
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    # dbに保存されてるmichaelのアドレスを送信する。
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # わからん。同じやと思う、
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    # メール送りました。のflashが表示されてるはず。
    assert_redirected_to root_url
    
    # パスワード再設定フォームのテスト
    user = assigns(:user)
    # 対応するアクションに定義したインスタンス変数にテスト環境からアクセスできるようにしてる。
    
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")
    # userhはURLに書いてるemailのクエリから探すんやけど、それが空欄=>発見できない。
    # valid_userで弾かれる。
    assert_redirected_to root_url
    # 無効なユーザー
    user.toggle!(:activated)
    # userのactivateを反転させる。登録できた時点でtrueになってるから、falseに切り替えてる。
    get edit_password_reset_path(user.reset_token, email: user.email)
    # メールは正常通りに売ってるけど、activatedはfalse
    assert_redirected_to root_url
    user.toggle!(:activated)
    # activatedを元に戻す。
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    # :idの部分を変にさせてdigestと合致させなくしてる。
    assert_redirected_to root_url
    
    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
  
end