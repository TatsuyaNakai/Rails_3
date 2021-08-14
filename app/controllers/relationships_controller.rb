class RelationshipsController < ApplicationController
  before_action :logged_in_user
  # アクション全てにかける場合はonlyは必要ない。それだけ書いてしまう。
  
  def create
    @user=User.find(params[:followed_id])
    # hidden_fieldから渡ってきたfollowed_idをキーにしてuserを探す。
    current_user.follow(@user)
    # followingの配列のなかにuserを追加する。
    # current_userのidがfollower_idになったfollowed_idのリストの中にはいる。
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
    # 上記のどちらかの処理を行う役割がある。
  end
  
  def destroy
    @user=Relationship.find(params[:id]).followed
    # URLの:id に当たる番号をRelationshipのid番号で検索する。
    #  そのfollowed(followed_id)の番号をuserのidで探して該当するユーザーを格納する。
    current_user.unfollow(@user)
    # active_relationshipsテーブルのfollower_idはcurrent_userのidで、
    # followed_idはuserのidになっているものを削除する。
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
  
end
