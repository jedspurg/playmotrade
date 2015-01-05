class PagesController < ApplicationController

  before_filter :find_store
  before_filter :setup_categories, :only => [:new, :edit]

  def index
    if params[:category_id].present?
      @pages = Page.where(category_id: params[:category_id].to_i)
    else
      @pages = (current_user.admin? && @store.blank?) ? Page.site_pages.grouped_by_category : @store.pages
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def show
    @page = Page.active.find_by(id: params[:id], store_id: @store.try(:id)) || Page.active.find_by(slug: params[:id], store_id: @store.try(:id))
    if @page.slug == 'help' && @page.site_page?
      @help_request = HelpRequest.new(help_request_params)
    end
  end

  def create
    @page = Page.new(page_params.merge(store: @store))
    if @page.save
      flash[:notice] = "Page Created"
      redirect_to pages_path
    else
      setup_categories
      flash[:error] = @page.errors.full_messages.to_sentence
      render :action => :new
    end
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      flash[:notice] = "Page Updated"
      redirect_to pages_path
    else
      setup_categories
      flash[:error] = @page.errors.full_messages.to_sentence
      render :action => :edit
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Page Deleted"
    redirect_to pages_path
  end

  def uploads
    upload       = PageUpload.new
    upload.image = params[:file]
    upload.save

    render json: {
      image: {
        url: view_context.image_url(upload.image)
      }
    }, content_type: "text/html"
  end

  private #####################################################################

  def setup_categories
    @available_categories = PageCategory.all
  end

  def page_params
    params.require(:page).permit(:title, :slug, :body, :page_category_id, :active, :position, :file)
  end

  def help_request_params
    params.require(:help_request).permit(:name, :email, :comment) if params[:help_request].present?
  end

  def find_store
    @store = Store.find_by(:alias => request.subdomain)
  end
end
