class SiteController < ApplicationController

  def update_current_site

    Site.current = Site.find_by_name(params[:site])
    render :layout => false
  end

  def get_current_site

    site_name = Site.current
    render :text => (Site.current.name rescue "").to_json
  end
end
