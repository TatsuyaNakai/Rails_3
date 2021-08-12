require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  test "create should require logged-in user" do
    # ログインした動きがない状態。
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    # これもログインしてない状態
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
      # oneのidを：id にいれてrelationshipを削除しようとする。
      # ログインしてないから、ログイン画面に飛ばされる。
    end
    assert_redirected_to login_url
  end
  
end
