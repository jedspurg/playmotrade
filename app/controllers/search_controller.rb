class SearchController < ApplicationController

  def index
    case params[:type]
    when "set"
      @catalog_items = CatalogSet.search do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        paginate :page => params[:page], :per_page => 24
      end.results
    when "part"
      @catalog_items = CatalogPart.search do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        paginate :page => params[:page], :per_page => 24
      end.results
    else
      @catalog_items = CatalogItem.search do
        fulltext "#{params[:q]}*" do
          boost_fields :name => 2.0
        end
        paginate :page => params[:page], :per_page => 24
      end.results
    end
  end

end
