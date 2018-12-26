class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #在控制器中引入Sessions控制器的帮助方法模块
  include SessionsHelper
end
