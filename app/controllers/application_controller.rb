class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected ###################################################################

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :avatar,
    	                                                      :password, :password_confirmation,
                                                            :agrees_to_tos, :first_name,
                                                            :last_name, :telephone,
                                                            :address1, :address2, :about,
                                                            :country_id, :state, :city, :zip
                                                            )}
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :avatar, :password,
                                                            :password_confirmation, :current_password,
                                                            :first_name, :last_name, :telephone,
                                                            :address1, :address2, :about,
                                                            :country_id, :state, :city, :zip
                                                            )}
  end

end
