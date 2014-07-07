class HomeController < ApplicationController

  def index
    @subdomain = request.subdomains.first
  end

end
