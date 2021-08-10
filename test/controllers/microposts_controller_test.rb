require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost= microposts(:orange)
  end
  
  # ログインしてない時createの挙動を表してる。
  test "should redirect create when not looged in" do
    assert_no_difference 'Micropost.count' do
      # 変化がなければテストを通過することができる。
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  # ログインしてない時のdestroyの挙動を表してる。
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
      # 変化がなければテストを通過することができる。
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost= microposts(:ants)
    # userはarcherになってる。
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
      # before_actionで投稿したユーザーでないとdeleteメソッドに飛べないようになってる。
      # 結果としてcountが変わらない。テストは通過できる。
    end
    assert_redirected_to root_url
  end
  
end
