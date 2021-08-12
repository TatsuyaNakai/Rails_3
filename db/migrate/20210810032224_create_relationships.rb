class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique:true
  # あるユーザーが同じ特定のユーザーを２回以上フォローするのを防ぐ役割がある。
  end
    # add_indexはデータの読み込み速度を改善するもので、特定のカラムのデータを複製して、検索が行いやすいようにしたもの。
    # これがないと検索をかけた時に普通に上から順にみて検索していく形になる。＝＞これが遅い。
    # 頻繁に検索する場合やと、indexをつけた方がいい。
end
