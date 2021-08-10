class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  # active storage APIのメソッドの一つ imageを関連づけてる。
  # ↑の場合は、投稿が一つに対して、画像が1点にする設計
  
  default_scope-> {order(created_at: :desc) }
# default_scopeは特定の順序に並び替えるもの
# orderの引数にはどうゆう条件で並び替えるかがはいる。
# ->はラムダ式って言われてる、{}のブロックを引数にとって、Procオブジェクトを返す
# callメソッドがよばれた時にブロック内の処理を評価する。
  validates :user_id, presence: true
  validates :content, presence: true, length:{maximum: 140}
  validates :image, content_type:{in:%w[image/jpeg image/git image/png],
                                  message: "must be a valid image format" },
                    size:        {less_than: 5.megabytes,
                                  message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
    # variantは引数値に変換するって意味を持ってて、resize_to_limitはそれ以上を超えないようにするオプションのこと
  end
end
