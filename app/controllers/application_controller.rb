class ApplicationController < ActionController::Base
    include SessionsHelper
    # ヘルパーモジュールにSessionsHelperがモジュールかされてるから、
    # それをコントローラーの親クラス（ここ）で書くことで全コントローラーで書ける
    
end
