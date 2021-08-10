require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user= users(:michael)
  end
  
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    # h1タグにimg.gravatarがあるかどうかを検証する。あればテストをパスする。
    assert_match @user.microposts.count.to_s, response.body
    # response.bodyはこのページのHTML全体を対象のこと。
    # 今回の場合でいうと、全体にmicroposts.countの数字があればパスできる。
    assert_select 'div.pagination'
    # HTMLに変換したときにpaginationというクラスがあるかどうか。
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
      # HTML全体にmicroposts.contentがあればテストをパスすることができる。
    end
  end
  
end
