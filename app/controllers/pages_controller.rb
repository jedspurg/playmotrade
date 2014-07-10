class PagesController < ApplicationController
  before_filter :setup_categories, :only => [:new, :edit]
  before_filter :find_store_by_name_or_id

  def index
    if params[:category_id].present?
      @pages = Page.where(category_id: params[:category_id].to_i)
    else
      @pages = current_user.admin? ? Page.site_pages.grouped_by_category : current_user.pages
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def show
    @page = Page.active.find_by(id: params[:id]) || Page.active.find_by(slug: params[:id])
  end

  def create
    @page = Page.new(page_params.merge(user: current_user))
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
    @available_categories = []

    if current_user.admin?
      @available_categories = PageCategory.where(name: ['general', 'documentation', 'terms and service', 'blog'])
    elsif current_user.store.present?
      @available_categories = PageCategory.find_or_create_by(name: "store_#{current_user.store.id}")
    end
  end

  def page_params
    params.require(:page).permit(:title, :slug, :body, :page_category_id, :active, :position, :file)
  end

  def find_store_by_name_or_id
    if request.subdomain.present?
      if request.subdomain == 'www'
        redirect_to root_url(:subdomain => nil)
        return
      else
        @store = Store.find_by(:alias => request.subdomain)
      end
    end
  end
end
