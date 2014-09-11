class ReportController < ApplicationController

  def dynamic_view

   site = Site.find_by_name(params[:site])
   @site_name = site.name
   @site_errors = Observation.sorted_site_failures(site.id)

    render :layout => false
  end

  def static_view

    @priority_sites = Observation.sorted_sites_failures
    render :layout => false
  end
end
