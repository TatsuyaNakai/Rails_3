ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  include ApplicationHelper
  fixtures :all
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  
  def is_logged_in?
    !session[:user_id].nil?
    # sessionのuser_idが空欄(ログインしてない状態)やと、falseを返すようになってる。
  end
  
  def log_in_as(user)
    session[:user_id] = user.id
    # 引数に指定したuserのidをログイン状態にあるuserのidにする。
  end
 
end

# クラスが変わるから注意

class ActionDispatch::IntegrationTest
  # 本来モジュールは違うところになるけど、メソッド名が同じやから、わかりやすいし一緒の場所に置いとこう！的な考え。
  # 単体テストでも、統合テストでもlog_in_asを使えばユーザーがログインしてることになる。
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email:       user.email,
                                          password:     password,
                                          remember_me:  remember_me } }
  # 設定されてるuserでログインできてる状態を作るメソッド
  # わかりやすいようにキーワード引数を取ってる。（初期値を設定してる。）
  end
end
