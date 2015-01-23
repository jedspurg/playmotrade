class MessageMailer < ApplicationMailer
  def private_message(message)
    @user    = message.recipient
    @from    = message.user
    @message = message
    @url     = messages_url(message, domain: nil)

    mail(to: @user.email, subject: "New Playmotrade Private Message from #{@user.name}")
  end
end
