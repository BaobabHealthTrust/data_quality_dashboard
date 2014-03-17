
require 'rest-client'

$rule_id = Definition.where(:name => "Data quality rule violation").first.id

 
def start

  sites = YAML.load_file("#{Rails.root.to_s}/config/sites.yml")
  (sites || []).each do |key, value|
    puts "Getting Data For Site #{key}"
    unless value.blank?
      start_date = (50.days.ago).to_date
      end_date = Date.today
      url = "http://#{value}/validation_result/list"
      data = JSON.parse(RestClient.post(url, {:start_date => start_date, :end_date => end_date})) rescue (
        puts "**** Error when pulling data from site #{key}"
       next
      )
      site = Site.where(:name => key).first_or_create
      record(site,data)
    end
  end

end

def record(site,data)

  (data || []).each do |result|
    Observation.create({:site_id => site.id,
        :definition_id => $rule_id,
        :value_numeric => result['failures'],
        :value_text => result['rule_desc'],
        :value_date => result['date_checked']
      })
  end
end

start
