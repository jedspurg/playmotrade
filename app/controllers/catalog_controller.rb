class CatalogController < ApplicationController

  def index
    @recent_catalog_parts = CatalogItem.where(:catalogable_type => 'CatalogPart').order("created_at DESC").take(6)
    @recent_catalog_sets = CatalogItem.where(:catalogable_type => 'CatalogSet').order("created_at DESC").take(6)
  end

end
