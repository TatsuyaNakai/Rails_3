## Cookieについて理解できない箇所がありました。
### 場所と理解できなかった内容は以下になります。
場所：`Rails_3/app/helpers/sessions_helper.rb`における`current_user`の27行目
内容：`user.authenticated?(cookies[:remember_token])`がなぜ`true`を返すのかがわかりませんでした。

#### `authenticate?`メソッドの動きとしては以下で認識しています。
- 引数に渡された値が`remember_digest`の値と正しいかどうか。


コントローラの動きとしては
`Rails_3/app/controllers/sessions_controller.rb`における`create`アクションの動きから始まります。
- `form_with`から`user`変数を作成。
- その`user`を使用して`Rails_3/app/helpers/sessions_helper.rb`における `log-in`メソッドを実行（`session`を現在の`user_id`にします。）
- その`user`を使用して`Rails_3/app/helpers/sessions_helper.rb`における`remember`メソッドを実行（長くなるので下に書きます。）
  - `/Rails_3/app/model/user.rb`の`remember`を実行
    - 22文字の乱数を出力し、それを`remember_token`に上書き（同ファイルの2行目に`attr_accessor`を記述したので、カラムに追加していなくてもデータの取得、変更が可能）
    - その22文字の乱数を同ファイル24行目で定義しているdigestメソッド（引数に渡された文字列をBlowfish暗号を基盤としてハッシュ化する関数です。）で処理
      そのハッシュ化した値をカラムに定義している`remember_digest`に更新しています。（`update_attribute`はvalidatesをスルーします。）
  `user.remember`の処理が終わったので、`Rails_3/app/helpers/sessions_helper.rb`の`remember`に戻ります。
  - ログイン時の`user_id`を暗号化したものを20年の制約をつけて`cookies`に保存
  - ログイン時の`remember_token`を20年の制約をつけて`cookies`に保存

 ### これで`remember_token`が`cookies`に保存されているはずです。
 
 そこから冒頭に戻りますが、`Rails_3/app/helpers/sessions_helper.rb`における`current_user`を実行した時に27行目が理解できませんでした。
 
僕の言い分としては、`remember_token`はハッシュ化された値ではないので合致することはないはずです。
ですが、結果としてはこれでチュートリアル通りに進んでいます。
僕としては、ハッシュ化された値であれば`true`なのに不思議です。
気になった点としては以下になります。
- `is_password?`メソッドがネットで調べても出てこず、理解できませんでした。

これが回答と直接結びつくかわからないのですが、`is_password`の意味も教えてもらいたいです。

参考にしたページは以下です。
[Ruby on Rails チュートリアル 第9章 永続的セッション(cookies remember me 記憶トークン ハッシュ)を解説](https://qiita.com/bitcoinjpnnet/items/639cbace7cb806379452#912-ログイン状態の保持)
[Railsチュートリアル第９章まとめ](https://qiita.com/s_rkamot/items/bd06027945473e33de30)
[セッションとかクッキーとかよくわからないのでRailsチュートリアルでWebアプリケーション作りながら勉強してみた](https://qiita.com/hot_study_man/items/147f8b767b4135fe6fe4)
[ActiveRecord の attribute 更新方法まとめ](https://qiita.com/tyamagu2/items/8abd93bb7ab0424cf084)
[パスワード】bcryptとは](https://medium-company.com/bcrypt/)
 