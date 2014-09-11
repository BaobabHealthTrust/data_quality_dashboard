class Site < ActiveRecord::Base
  set_primary_key :site_id

  def self.alerts
    alerts = {"urgent" => [],
              "average" => [],
              "normal" => []
    }
    Observation.sorted_sites_failures.each do |site, errors|


       if errors > 100
         alerts["urgent"] << site
       elsif errors > 0
          alerts["average"] << site
       else
         alerts["normal"] << site
       end
    end

    return alerts
  end
end
