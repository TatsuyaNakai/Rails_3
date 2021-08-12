# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
# !があると、ユーザーが無効な時は、例外を発生させる。
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:         true,
             activated:     true,
             activated_at:  Time.zone.now )

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated:             true,
               activated_at:          Time.zone.now )
end

users = User.order(:created_at).take(6)
# create_at順（デフォルトは昇順やから、作られたのが早い順）でユーザーを６人抜き出す。
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  # FakerモジュールのLoremメソッドを呼んでる。
  users.each { |user| user.microposts.create!(content: content) }
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
# 3から51までの配列を選択
followers = users[3..40]
# 4から41までの配列を選択する。
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }