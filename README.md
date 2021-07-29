
## ヘルパーメソッドの使い方について
Rails の公式チュートリアルを進めていく中で疑問がありましたので、質問させていただきました。

> デフォルトでは、ヘルパーファイルで定義されているメソッドは自動的にすべてのビューで利用できます。
ここでは、利便性を考えてgravatar_forをUsersコントローラに関連付けられているヘルパーファイルに置くことにしましょう。
Gravatarのホームページにも書かれているように、GravatarのURLはユーザーのメールアドレスをMD5という仕組みでハッシュ化しています。
Rubyでは、Digestライブラリのhexdigestメソッドを使うと、MD5のハッシュ化が実現できます。

[Rails公式チュートリアル](https://railstutorial.jp/chapters/sign_up?version=6.0#fig-byebug)

と公式には記載があり、
本来の使用用途としては、
app/views/users/show.html.erbにおける　app/views/users/:id  などの個別のURLに対して画像を載せるためのものでしたが、
app/views/users/show.html.erb   にある`<%= gravatar_for @user %>`を
app/views/users/new.html.erb    また
app/views/static_pages/home.html.erb
にもコントローラに変数を作り`<%= gravatar_for @user %>`の表示を確認しました。

まさに公式チュートリアルの通りなのですが、そうすると
app/helpers　ディレクトリ内に作られているそれぞれのコントローラに対応するヘルパーの存在がわかりませんでした。
少し前のレクチャーで
app/helpers/application_helper.rbには違うヘルパーメソッドも記述しているのですが、どのビューからも利用できることが判明したので、
ヘルパーファイルを１つに統合しても問題はないのではないかと思ってしまいます。

## ヘルパーメソッドについて調べたこと
- もともとヘルパーメソッド（link_to, image_tag, label_for...etc）がありコードを効率よく書けるように用意されたもの
- 独自にヘルパーメソッドを作ることができる（今回がこれに当たると思います。）

ヘルパーメソッドについては記事がよくあり、使い方に関しては不明点はないのですが、コントローラーごとに分割して管理している意味がわかりませんでした。
仮どこでも使えるのであれば、'application_helper'にまとめて記載してしまった方がいいのでは。と思いました。
もしそうやって決まっているルールでなく、何かしら理由があるのであれば教えていただきたいです！