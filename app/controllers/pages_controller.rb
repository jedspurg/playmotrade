class PagesController < ApplicationController
  def index
    if params[:category_id].present?
      @pages = Page.where(category_id: params[:category_id].to_i)
    else
      @pages = Page.all
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def show
    @page = Page.find_by(id: params[:id]) || Page.find_by(slug: params[:id])
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = "Page Created"
      redirect_to pages_path
    else
      render :action => :new
    end
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = "Page Updated"
      redirect_to pages_path
    else
      render :action => :edit
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Page Deleted"
    redirect_to pages_path
  end
end
