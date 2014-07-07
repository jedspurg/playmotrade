class PaymentProcessorController < ApplicationController

  def index
    if current_user.store.blank?
      flash[:error] = "You must first create a store to setup payment processing."
      redirect_to new_store_path
    end
    @store = current_user.store
  end

  def new
    @store = Store.find_by(id: params[:state])
    uri = URI.parse("https://connect.stripe.com/oauth/token")
    @response = Net::HTTP.post_form(uri, {
      "client_secret" => Stripe.api_key,
      "code"          => params[:code],
      "grant_type"    => "authorization_code"
    })

    parsed_response = JSON.parse(@response.body).symbolize_keys!
    if parsed_response.fetch(:error_description, nil).present?
      flash[:error] = parsed_response[:error_description]
    end

  end
end
