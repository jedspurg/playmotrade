class MessagesController < ApplicationController

  def index
    case params[:type]
    when  'sent'
      @messages = current_user.messages.paginate(:page => params[:page], :per_page => 30)
    when 'archived'
      @messages = current_user.messages.archived.paginate(:page => params[:page], :per_page => 30)
    else
      @messages = current_user.received_messages.paginate(:page => params[:page], :per_page => 30)
    end
  end

  def new
    @message = current_user.messages.new(disposition: params[:disposition], recipient_id: params[:recipient_id], subject: params[:subject])
  end

  def show
    @message = Message.find(params[:id])
    @sent = (@message.user == current_user)
    update_opened
  end

  def create
    @message = current_user.messages.new(message_params.merge(user: current_user))
    if @message.save
      MessageMailer.send("#{@message.disposition.underscore}_message".to_sym, @message).deliver
      flash[:notice] = "Message Sent"
      redirect_to messages_path
    else
      flash[:error] = @message.errors.full_messages.to_sentence
      render :action => :new
    end
  end

  def update
    @message = current_user.messages.find(params[:id])
    archive = (params[:archive] == 'true')
    if @message.update_attributes(archive: archive)
      flash[:notice] = "Message Updated"
      redirect_to messages_path
    else
      flash[:error] = @message.errors.full_messages.to_sentence
      render :action => :show
    end
  end


  private #####################################################################

  def message_params
    params.require(:message).permit(:subject, :body, :order_id, :read, :read_at, :archive, :recipient_id, :parent_message_id, :disposition, :user_id)
  end

  def update_opened
    if @message.recipient == current_user
      @message.update_attributes!(read: true, read_at: Time.now)
    end
  end

end
