class ReportController < ApplicationController

  def dynamic_view

   site = Site.by_name.key(params[:site]).last
   @site_name = site.name rescue nil
   @site_errors = Observation.sorted_site_failures(site.name) rescue {}

    render :layout => false
  end

  def static_view

    @priority_sites = Observation.sorted_sites_failures
    @sites = Observation.sorted_sites_failures
    @alerts = Site.alerts
    render :layout => false
  end

  def patients_without_start_reasons_graph
    render :layout => false
  end

  def rule_violations_summary
     site_name = (params[:site_name] || 'MPC')
     @site_name = site_name
     @site_errors = Observation.sorted_site_failures(site_name)
    render :layout => false
  end

  def rule_violations_trend_graph
    site_name = (params[:site_name] || 'MPC')
    start_date = Date.today - 3.months
    end_date = Date.today

    @data = {}
    @violation_trends = Observation.aggregate_rule_violation_trend(site_name, start_date, end_date)
    
    render :layout => false
  end

  def rule_violations_graph
    site_name = (params[:site_name] || 'MPC')
    start_date = Date.today - 3.months
    end_date = Date.today
    rule = params[:short_name]
    @data = {}
    violation_trends = Observation.rule_violation_trend(site_name, rule, start_date, end_date)
    @data["x"] = violation_trends.collect{|k, v|k.to_date.strftime("%d-%b")}
    @data["y"] = violation_trends.collect{|k, v|v}
    render :layout => false
  end
  
  def site_summary
    site_name = (params[:site_name] || 'MPC')
    @site_name = site_name
    @site_errors = Observation.sorted_site_failures(site_name)
    @latest_date = Observation.latest_site_obs_date(site_name)
    render :layout => "application"
  end

  def plot_rule_violations_graph
    site_name = (params[:site_name])
    start_date = Date.today - 3.months
    end_date = Date.today
    rule = params[:short_name]
    data = {}
    violation_trends = Observation.rule_violation_trend(site_name, rule, start_date, end_date)
    data["x"] = violation_trends.collect{|k, v|k.to_date}
    data["y"] = violation_trends.collect{|k, v|v}
    render :json => data and return
  end

  def sites_summary_graph


    render :layout => false
  end

end
