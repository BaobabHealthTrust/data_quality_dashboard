class HomeController < ApplicationController

  def index

    @sites = Site.all
    @alerts = Site.alerts
  end

  def map_main

    @sites = []
    (Site.all).each do |source|
      site = {
          'region' => source["region"],
          'x' => source["x"],
          'y' =>source["y"],
          'sitecode' => source["code"],
          'name' => source["name"]
      }

      @sites << site
    end
    render :layout => false
  end

end
