class ReportController < ApplicationController

  def index
    @lastdate = Observation.find_by_sql("SELECT site_id, max(value_date) as max_date FROM drug_mgmt.observations
                                        group by site_id order by max_date asc ;").first.max_date rescue nil
  end

  def site_list
    @sites = Site.all
  end

  def report_menu
    @sites = Site.all_sites
    @issues = Observation.distinct_issues
  end

  def process_report

    start_date = params[:start_date].to_date.strftime("%Y-%m-%d")
    end_date = params[:end_date].to_date.strftime("%Y-%m-%d")

    case params[:report_type]
    when "aggregate report"
      redirect_to :action => 'aggregate_report', :start_date => start_date, :end_date => end_date
    when "site report"
      site = params[:site_name]
      redirect_to :action => 'site_report', :site => site, :start_date => start_date, :end_date => end_date
    when "ranking report"
      redirect_to :action => 'ranking', :start_date => start_date, :end_date => end_date
    end
  end

  def site_report
    @title = "Site Report For #{params[:site]}  From #{params[:start_date].to_date.strftime("%d %B %Y")} To #{params[:end_date].to_date.strftime("%d %B %Y")}"
    @results = {}
    rule_id = Definition.where(:name => "Data quality rule violation").first.id
    site_id = Site.find_by_name(params[:site])
    observations = Observation.find(:all,:conditions => ["site_id = ? AND value_date >= ? AND value_date <= ? AND definition_id = ?",
                                    site_id, params[:start_date], params[:end_date], rule_id])

    (observations || []).each do |observation|
      @results[observation.value_date] = {} if @results[observation.value_date].blank?
      @results[observation.value_date][observation.value_text] = observation.value_numeric.to_i
    end

    (@results.keys || []).each do |date|
      @results[date] = @results[date].sort_by {|rule, amount| amount }.reverse
    end

    render :layout => 'report_layout'
  end

  def aggregate_report
    @title = "Aggregate Report From #{params[:start_date].to_date.strftime("%d %B %Y")} To #{params[:end_date].to_date.strftime("%d %B %Y")}"
    @results = {}
    rule_id = Definition.where(:name => "Data quality rule violation").first.id
    observations = Observation.find_by_sql("SELECT value_date, value_text, SUM(value_numeric) as amount FROM observations
                                        WHERE definition_id = #{rule_id} AND value_date >= '#{params[:start_date]}' AND
                                        value_date <= '#{params[:end_date]}' GROUP BY value_date, value_text ORDER BY value_date DESC")

    (observations || []).each do |observation|
      @results[observation.value_date] = {} if @results[observation.value_date].blank?
      @results[observation.value_date][observation.value_text] = observation.amount.to_i
    end

    (@results.keys || []).each do |date|
      @results[date] = @results[date].sort_by {|rule, amount| amount }.reverse
    end

    render :layout => 'report_layout'
  end

  def ranking
    @ranking = {}
    @ranking["All"] = {}
    rule_id = Definition.where(:name => "Data quality rule violation").first.id
    rankings = Observation.find_by_sql("SELECT site_id, value_text, SUM(value_numeric) as amount FROM observations
                                        WHERE definition_id = #{rule_id} AND value_date >= '#{params[:start_date]}' AND
                                        value_date <= '#{params[:end_date]}' GROUP BY site_id, value_text ORDER BY amount DESC")
    (rankings || []).each do |rank|

      @ranking[rank.site.name] = {} if @ranking[rank.site.name].blank?
      @ranking[rank.site.name][rank.value_text] = rank.amount.to_i
      @ranking["All"][rank.value_text] = (@ranking["All"][rank.value_text].blank? ? @ranking[rank.site.name][rank.value_text] : (@ranking[rank.site.name][rank.value_text] +@ranking["All"][rank.value_text]))
    end

      (@ranking.keys || []).each do |site|
        @ranking[site] = @ranking[site].sort_by {|rule, amount| amount }.reverse
      end
     @title = "Ranking Between #{params[:start_date].to_date.strftime("%d %B %Y")} And #{params[:end_date].to_date.strftime("%d %B %Y")}"
    render :layout => 'report_layout'
  end

end
