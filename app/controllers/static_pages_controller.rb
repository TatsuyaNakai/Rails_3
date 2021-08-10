class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost= current_user.microposts.build
      @feed_items= current_user.feed.paginate(page: params[:page])
      # ログインしてるUserの投稿してるmicropostsをページネーションで配置する。
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end

end
