class Observation < ActiveRecord::Base
  set_primary_key :observation_id
  belongs_to :site, :foreign_key => :site_id
  belongs_to :definition, :foreign_key => :definition_id
  validates_presence_of :site_id
  validates_presence_of :definition_id

  def self.sorted_site_failures(site_id)

    self.find_by_sql(["SELECT ob.value_numeric, def.short_name FROM observations ob

                                            INNER JOIN definitions def
                                              ON ob.definition_id = def.definition_id AND
                                                  def.definition_type = (SELECT definition_type_id
                                                        FROM definition_types WHERE name = 'Validation rule')

                                            WHERE ob.obs_datetime = (
                                                    SELECT max(obs_datetime) FROM observations JOIN definitions
                                                    ON definitions.definition_type = (SELECT definition_type_id
                                                        FROM definition_types WHERE name = 'Validation rule')
                                                    WHERE site_id = ? LIMIT 1
                                              ) AND ob.site_id = ?", site_id, site_id]
    ).inject({}){|result, obj| result[obj.short_name] = obj.value_numeric; result}.sort_by {|k, v| v}.reverse
  end

  def self.sorted_sites_failures

    self.find_by_sql("SELECT SUM(ob.value_numeric) sum, ob.site_id site_id FROM observations ob

                                              INNER JOIN definitions def
                                              ON ob.definition_id = def.definition_id AND
                                                  def.definition_type = (SELECT definition_type_id
                                                        FROM definition_types WHERE name = 'Validation rule')

                                                  AND ob.obs_datetime = (
                                                    SELECT max(obs_datetime) FROM observations JOIN definitions
                                                    ON definitions.definition_type = (SELECT definition_type_id
                                                        FROM definition_types WHERE name = 'Validation rule')
                                                    WHERE site_id = ob.site_id LIMIT 1
                                              )
                                              GROUP BY ob.site_id").inject({}){|r, data| r[Site.find(data.site_id).name] = data.sum.to_i; r}
  end

  def self.rule_violation_trend(site_id, definition_id, start_date, end_date)
    data_hash = {}
    data = self.find_by_sql("SELECT value_numeric, obs_datetime FROM observations 
      WHERE definition_id=#{definition_id} AND DATE(obs_datetime) >= '#{start_date}'
      AND DATE(obs_datetime) <= '#{end_date}' AND site_id = #{site_id}")
    
    data.each do |e|
      obs_date = e.obs_datetime.to_date.strftime("%d-%b-%Y")
      data_hash[obs_date] = e.value_numeric
    end
    
    return data_hash.sort_by{|k, v|k.to_date}
  end

end
