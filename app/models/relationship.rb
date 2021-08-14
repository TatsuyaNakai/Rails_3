class Relationship < ApplicationRecord
  # 関連名が同じだとエラーが起こるから、モデルにはこれで送ってます！を明示するためにclass_nameで書く。
  # belongs_toの関連の語尾に_idをつけると外部キーとして認証される。
  belongs_to :follower, class_name: "User"
  # passive_relationshipの時に使用する。埋まってない方を考えると見える。
  belongs_to :followed, class_name: "User"
  # active_relationshipの時に使用する方。どっちが埋まってないのかを確認して紐づきを決める。
  
  validates :followed_id, presence: true
  validates :follower_id, presence: true
  
end
