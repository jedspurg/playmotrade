class StoreSearchController < ApplicationController

  def index
    @inventory_items = []
    # case params[:type]
    # when "set"
    #   @inventory_items = CatalogSet.search do
    #     fulltext "#{params[:q]}*" do
    #       boost_fields :name => 2.0
    #     end
    #     paginate :page => params[:page], :per_page => 24
    #   end.results
    # when "part"
    #   @inventory_items = CatalogPart.search do
    #     fulltext "#{params[:q]}*" do
    #       boost_fields :name => 2.0
    #     end
    #     paginate :page => params[:page], :per_page => 24
    #   end.results
    # else
    #   @inventory_items = CatalogItem.search do
    #     fulltext "#{params[:q]}*" do
    #       boost_fields :name => 2.0
    #     end
    #     paginate :page => params[:page], :per_page => 24
    #   end.results
    # end
  end

end
