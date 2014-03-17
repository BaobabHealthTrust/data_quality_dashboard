class HomeController < ApplicationController
  def index
    @lastdate = Observation.find_by_sql("SELECT site_id, max(value_date) as max_date FROM observations
                                        group by site_id order by max_date asc ;").first.max_date rescue nil
    rule_id = Definition.where(:name => "Data quality rule violation").first.id

    @notices = Observation.find(:all,
                                :conditions => ["definition_id = ? AND value_date >= ?",rule_id, (7.days.ago).to_date],
                                :order => "value_date DESC", :limit => 20)

    @rankings = Observation.find_by_sql("SELECT value_text, SUM(value_numeric) as amount FROM observations
                                        WHERE definition_id = 12 AND value_date >= '2014-01-01' GROUP BY value_text
                                        ORDER BY amount DESC LIMIT 15")



  end


end


