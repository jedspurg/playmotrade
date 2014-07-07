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
      "client_secret" => Rails.configuration.stripe[:secret_key],
      "code"          => params[:code],
      "grant_type"    => "authorization_code"
    })

    parsed_response = JSON.parse(@response.body).symbolize_keys!

    if parsed_response.fetch(:error_description, nil).present?
      flash[:error] = parsed_response[:error_description]
    else
      store_attrs = {
        stripe_refresh_token:   parsed_response[:refresh_token],
        stripe_user_id:         parsed_response[:stripe_user_id],
        stripe_publishable_key: parsed_response[:stripe_publishable_key],
        stripe_access_token:    Base64.encode64(parsed_response[:access_token])
      }
      if @store.update_attributes(store_attrs)
        flash[:notice] = "Stripe connection complete!"
      else
        flash[:error] = @store.errors.full_messages.to_sentence
      end
    end
  end

end
