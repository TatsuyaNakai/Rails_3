require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    

    assert_select "ul"
    assert_select "div#error_explanation"
    # assert_selectは以降に書くものが、そのHTMLに存在するかどうかを検証する。
    # もしあれば、パスできる。
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
  # 実行前と後で引数の値に変化が起こったらテストをパスすることができる。 
      post users_path, params: {user:{name: "Example User",
                                    email: "user@example.com",
                                    password: "password",
                                    password_confirmation: "password"} }
    end
    follow_redirect!
    # コントローラのページ遷移に従う。今回で言うとredirect_toに従う。
    assert_template 'users/show'
    assert_not flash.empty?
  end
  
end
