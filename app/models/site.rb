class Site < ActiveRecord::Base
  set_primary_key :site_id
  validates_presence_of :code, :name
  validates_uniqueness_of :name, :code
  before_save :add_creator

  cattr_accessor :current

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

  def self.add_site(name,code, host, port, region, x, y)
    if Site.create({:name => name, :code => code, :host => host,:port =>port, :region => region,:x =>  x, :y => y})
      return ["Site successfully saved", true]
    else
      return ["Site could not be added", nil]
    end
  end

  def add_creator
    self.creator = User.current.id
  end
end
