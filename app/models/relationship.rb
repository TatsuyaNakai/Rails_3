class Relationship < ApplicationRecord
  # 関連名が同じだとエラーが起こるから、モデルにはこれで送ってます！を明示するためにclass_nameで書く。
  # belongs_toはシンボルで書く時に_idを省略する。
  # Userには、follower_id, followed_idを外部キーとして関連づけてる。]
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # Relationshipクラス自身がどのクラスを参照しにいくか。を示してる。
  # active_relationshipの場合は、followed_idを外部キーにしてUserのidを探しにいく。
  # activeの場合で１人ユーザーを決めてから埋めていく考えなら、どっちに対応してるかわかる。

  
  validates :followed_id, presence: true
  validates :follower_id, presence: true
  
end
