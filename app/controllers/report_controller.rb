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

  def patients_without_start_reasons_graph
    render :layout => false
  end

  def rule_violations_summary
     site_name = (params[:site_name] || 'MPC')
     site = Site.find_by_name(site_name)
     @site_name = site.name
     @site_errors = Observation.sorted_site_failures(site.id)
    render :layout => false
  end

  def rule_violations_trend_graph
    render :layout => false
  end

  def rule_violations_graph
    site_name = (params[:site_name] || 'MPC')
    site_id = Site.find_by_name(site_name).id
    start_date = Date.today - 3.months
    end_date = Date.today
    short_name = params[:short_name]
    definition_id = Definition.find_by_short_name(short_name).id rescue 1
    @data = {}
    violation_trends = Observation.rule_violation_trend(site_id, definition_id, start_date, end_date)
    @data["x"] = violation_trends.collect{|k, v|k.to_date.strftime("%d-%b")}
    @data["y"] = violation_trends.collect{|k, v|v}
    render :layout => false
  end
  
  def site_summary
    site_name = (params[:site_name] || 'MPC')
    site = Site.find_by_name(site_name)
    @site_name = site.name rescue nil
    render :layout => "application"
  end
  
end
