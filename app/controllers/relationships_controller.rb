class RelationshipsController < ApplicationController
  before_action :logged_in_user
  # アクション全てにかける場合はonlyは必要ない。それだけ書いてしまう。
  
  def create
    user=User.find(params[:followed_id])
    # hidden_fieldから渡ってきたfollowed_idをキーにしてuserを探す。
    current_user.follow(user)
    # followingの配列のなかにuserを追加する。
    # current_userのidがfollower_idになったfollowed_idのリストの中にはいる。
    redirect_to user
    # 短縮系のやつ、user_url(user)にリダイレクトする。
  end
  
  def destroy
    user=Relationship.find(params[:id]).followed
    # Relationshipテーブルの中から、URLの:id に当たるfollowed?カラムを探す。
    # followed_idはエラーになった。どこの何かがわからない。
    byebug
    # ページに表示されてるユーザーがuserに入る。
    current_user.unfollow(user)
    # active_relationshipsテーブルのfollower_idはcurrent_userのidで、
    # followed_idはuserのidになっているものを削除する。
    redirect_to user
  end
  
end
