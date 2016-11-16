class HomeController < ApplicationController

  def index

    @sites = Site.by_enabled.key(true)
    @alerts = Site.alerts

  end

  def map_main

    @sites = []
    (Site.by_enabled.key(true)).each do |source|
      site = {
          'region' => source["region"],
          'x' => source["x"].to_f,
          'y' =>source["y"].to_f,
          'sitecode' => source["code"],
          'name' => source["name"]
      }

      @sites << site
    end
    @sites_errors = Observation.sorted_sites_failures
    @alerts = Site.alerts
    render :layout => false
  end

end
