class MainController < ApplicationController
  before_action :basic_auth, only: [:secret]

  def home; end

  def secret; end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == 'amazon' && password == 'candidate'
    end
  end
end
