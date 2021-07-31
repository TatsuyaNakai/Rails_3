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
    # sessionのuser_idが空欄やと、falseを返すようになってる。
  end
 
  # Add more helper methods to be used by all tests here...
end
