class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  # apprication.contorollerにlogged_in_userを格納したから、どこでも使えるようになってる。
  # 理由は、MicropostContorollerはApplicationContorollerを継承してるため。
  before_action :correct_user, only: [:destroy]
  
  def create
    @micropost= current_user.microposts.build(micropost_params)
    # いまログインしてるuserのmicropostをmicropost_paramsの情報を使って作成したものをmicropostに格納する。
    # current_userはsession.helperで定義されてるから、どこでも使える。
    @micropost.image.attach(params[:micropost][:image])
    # micropostモデルにhas_one_attachedをしたから、image属性が追加されてる。
    # そこに対して、ビューでおいたfifle_fieldのファイルを受け取ってもらいたいから、パラメーターを記入してる。
    
    if @micropost.save
      flash[:success]="Micropost created!!"
      redirect_to root_url
    else
      @feed_items= current_user.feed.paginate(page: params[:page])
      # 投稿が失敗したときにすぐにページを遷移してしまうから、そのビュー用に変数をさきに宣言しておく必要がある。
      render 'static_pages/home'
      # rails routesで確認できる。
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success]= "Micropost deleted"
    redirect_to request.referrer || root_url
    # request.referrerは一つ前のURLを指す。Homeからでも、Profileページからでも投稿をどこから消されても前のページがあれば戻ることができる。
    # URLが見つからなかった場合は、root_urlに戻れるようなデフォルトをとってる。
  end
  
  # -------------------------------------------------
  private
  
  def micropost_params
    params.require(:micropost).permit(:content, :image)
    # 送られてきたパラメーターのmicropostの全てを取得するけど、許可するのはcontentだけ。
  end
  
  def correct_user
    @micropost= current_user.microposts.find_by(id:params[:id])
    # ログインしてるユーザーのURLに表示された:idからmicropostを探して、micropostに格納する。
    redirect_to root_url if @micropost.nil?
    # もし、micropostがなかったら、（既に消されてる場合）root_urlに戻る。
  end
  
end
