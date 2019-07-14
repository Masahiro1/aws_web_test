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

  def stocker
    function = params[:function]
    name     = params[:name]
    amount   = params[:amount]
    price    = params[:price]


    # 引数のチェック -------------------------------------------------

    # 必須項目があるか
    if function == nil
      error = true
    elsif ["addstock", "sell"].include?(function) && name.blank?
      error = true
    end

    # amount, priceがinteger型で正か
    [amount, price].each do |v|
      if v.present?
        unless /\A[0-9]+\z/ === v && v.to_i > 0
          error = true
        end
      end
    end

    # errorがあれば抜ける
    if error
      @output = "ERROR"
      return
    end

    # ------------------------------------------------------------


    # amount省略時は1に
    if ["addstock", "sell"].include?(function)
      amount ||= 1
    end

    # sellでpriceがnilなら0に（こうすると加算が0になる）
    if function == "sell"
      price ||= 0
    end

    # amount, priceをintegerに変換
    amount = amount.to_i
    price  = price.to_i


    # 各種function処理
    case function

    when "addstock"
      item = Item.find_by("name = binary ?", name) # binary は大文字・小文字を区別するため

      if item.present?
        item.increment(:amount, amount)
      else
        item = Item.new(name: name, amount: amount)
      end

      unless item.save
        @output = "ERROR"
      end

    when "checkstock"
      if name.present?
        item = Item.find_by(name: name)

        if item.present?
          @output = "#{name}: #{item.amount}"
        else
          @output = "#{name}: 0"
        end
      else
        items = Item.where("amount > 0").order(name: :asc)
        @output = items.map {|i| "#{i.name}: #{i.amount}"}.join("\n")
      end

    when "sell"
      success = false

      item = Item.find_by(name: name)
      if item.present?
        if item.amount >= amount
          item.increment(:sale, price * amount)
          item.decrement(:amount, amount)

          if item.save
            success = true
          end
        end
      end

      unless success
        @output = "ERROR"
      end

    when "checksales"
      sales = Item.sum(:sale)
      @output = "sales: #{sales}"

    when "deleteall"
      Item.destroy_all

    end

    unless @output.present?
      render body: nil
    end
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == 'amazon' && password == 'candidate'
    end
  end
end
