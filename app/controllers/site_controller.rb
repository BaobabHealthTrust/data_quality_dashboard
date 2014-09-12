class SiteController < ApplicationController

  def update_current_site

    Site.current = Site.find_by_name(params[:site])
    render :layout => false
  end
end
