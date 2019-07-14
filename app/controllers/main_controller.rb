class MainController < ApplicationController
  before_action :basic_auth, only: [:secret]

  def home; end

  def secret; end

  def calc
    str = params.keys[0].dup()
    str.gsub!(" ", "+")
    if /\A[\+\-\*\/()0-9]+\z/ === str
      @output = eval(str)
    else
      @output = "ERROR"
    end
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == 'amazon' && password == 'candidate'
    end
  end
end
