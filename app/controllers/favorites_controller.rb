class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    @favorite = @user.build_favorite(favorite_params)
    @favorite.registered_price = fetch_current_price(@favorite.symbol)

    if @favorite.save
      redirect_to user_path(@user), notice: 'Favorite was successfully created.'
    else
      @opinions = @user.opinions
      render 'users/show'
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:symbol).merge(user_id: current_user.id)
  end

  def fetch_current_price(symbol)
    api_key = ENV["ALPHA_VANTAGE_API_KEY"]
    url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{symbol}&apikey=#{api_key}"

    response = HTTParty.get(url)
    data = JSON.parse(response.body)
    
    data["Global Quote"]["05. price"].to_f
  rescue StandardError => e
    Rails.logger.error("Error fetching data for symbol #{symbol}: #{e.message}")
    nil
  end
end
