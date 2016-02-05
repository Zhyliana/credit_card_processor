class ApplicationController < ActionController::Base
  protect_from_forgery
  def home
    render 'layouts/application'
  end
end