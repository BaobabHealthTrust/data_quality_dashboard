=begin
  Written by : Timothy Mtonga
  Written on : 10th September 2014
  Purpose : Pull recent data from BART about validation rules that were violated

=end
require 'rest-client'
# global variable that will be used when creating new observations
$user_id = User.first.id

#execution starts here
def start

  #Get all sitess to get data from
  sites = Site.all

  (sites || []).each do |site|

    #In this loop data from the sites is pulled
    puts "Getting Data For Site: #{site.name}"

    #Gets last day on which the application pulled records for the site
    start_date = last_update(site)
    end_date = Date.today.to_date

    url = "http://#{site.ip_address}:#{site.port}/validation_result/list"
    data = JSON.parse(RestClient.post(url, {:start_date => start_date, :end_date => end_date})) rescue (
    puts "**** Error when pulling data from site #{key}"
    next
    )

    #saves the results
    record(site,data)

    #records the day as the last day on which data was pulled
    record_pulled_datetime(site,start_date,end_date)
  end

end

def last_update(site)
  #This method returns the last day the application got results
  return if site.blank?

  return PullTracker.where(:site_id => site.id).first.pulled_datetime.to_date rescue (Date.today - 120.days).to_date

end


def record(site,data)
  # This methods records the results received from BART

  (data || []).each do |result|

    defn = Definition.where(:name => result[:rule_desc]).first.id

    #Check if record for same day already exists
    past_result = Observation.where(:site_id =>  site.id,
                               :definition_id => defn,
                               :obs_datetime => result[:date_checked]).first

    #If is doesn't exist create new record otherwise update existing record
    if past_result.blank?
        past_result = Observation.new({:site_id =>  site.id,
                                       :definition_id => defn,
                                       :obs_datetime => result[:date_checked],
                                       :value_numeric => result[:failures],
                                       :creator => $user_id
                                      })
    else
      past_result.value_numeric = result[:failures]
    end
    past_result.save
  end
end

def record_pulled_datetime(site, start_date, end_date)

  # this method records the time that the application successfully pulled data from BART

  pulled_time = PullTracker.where(:'site_id' => site.id).first

  if pulled_time.blank?
    pulled_time = PullTracker.new()
    pulled_time.site_id = site.id
  end
  pulled_time.pulled_datetime = ("#{end_date.to_date} #{Time.now().strftime('%H:%M:%S')}")
  pulled_time.save
  puts "Recorded for :#{site.name}, From #{start_date.to_date.strftime("%d %B %Y")}
          to #{end_date.to_date.strftime("%d %B %Y")}"
end

start
