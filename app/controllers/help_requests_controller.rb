class HelpRequestsController < ApplicationController

  def create
    @help_request = HelpRequest.new(help_request_params.merge(user: current_user))
    if verify_recaptcha(:model => @help_request, :message => "Captcha code was incorrect!") && @help_request.save
      flash[:notice] = "Thank you for your submission"
    else
      flash[:error] = @help_request.errors.full_messages.to_sentence
      resend_params = help_request_params
    end

    redirect_to page_path('help', help_request: resend_params)
  end

  private #####################################################################

  def help_request_params
    params.require(:help_request).permit(:name, :email, :comment)
  end

end
