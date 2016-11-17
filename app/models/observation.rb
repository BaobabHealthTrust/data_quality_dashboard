class Observation < CouchRest::Model::Base

  property :site_code, String
  property :site_name, String
  property :date_checked, Date
  property :failures, String
  property :rule, String

  design do
    view :by_site_name,
         :map => "function(doc) {
                  if (doc['site_name'] != '') {
                    emit([doc['site_name']], 1);
                  }
                }"
    view :by_date_checked,
         :map => "function(doc) {
                  if (doc['date_checked'] != '' && doc['date_checked'] != null) {
                    emit([doc['date_checked']], 1);
                  }
                }"
    view :by_rule,
         :map => "function(doc) {
                  if (doc['rule'] != '' && doc['rule'] != null) {
                    emit([doc['rule']], 1);
                  }
                }"
     view :by_site_name_and_date_checked,
          :map => "function(doc) {
              if (doc['site_name'] != '' && doc['date_checked'] != '') {
                emit(doc['site_name'].split(' ').join('_') + '_' + doc['date_checked'].substr(0, 8));
              }
            }"
     view :by_site_name_and_rule_and_date_checked,
         :map => "function(doc) {
              if (doc['site_name'] != '' && doc['rule'] != '' && doc['date_checked'] != '') {
                emit(doc['site_name'].split(' ').join('_') + '_' + doc['rule'].split(' ').join('_') + '_' + doc['date_checked'].substr(0, 8));
              }
            }"
  end

  def self.sorted_site_failures(site_name)

    latest_date = Observation.by_site_name.key([site_name]).last.date_checked.to_date.strftime("%Y%m%d") rescue nil
    return {} if latest_date.blank? || site_name.blank?

    key = site_name.gsub(/\s+/, "_") + "_" + latest_date
    data = Observation.by_site_name_and_date_checked.key(key)

    result =  {}
    data.each do |d|
      result[d['rule']] = d['failures']
    end

    result
  end

  def self.sorted_sites_failures

    result = {}
    Site.by_enabled.key(true).each do |site|
      result[site.name] = self.sorted_site_failures(site.name).values.collect{|v| v.to_i}.sum
    end
    result
  end

  def self.rule_violation_trend(site_name, rule, start_date, end_date)

    startkey = site_name.gsub(/\s+/, "_") + "_" + rule.gsub(/\s+/, "_") + start_date.to_date.strftime("%Y%m%d")
    endkey = site_name.gsub(/\s+/, "_") + "_" + rule.gsub(/\s+/, "_") + end_date.to_date.strftime("%Y%m%d")

    data = Observation.by_site_name_and_rule_and_date_checked.startkey(startkey).endkey(endkey)

    result = {}
    data.each do |e|
      obs_date = e.date_checked.to_date.strftime("%d-%b-%Y")
      result[obs_date] = e.failures
    end

    result = result.sort_by{|k, v|k.to_date}
    result
  end

  def self.aggregate_rule_violation_trend(site_name, start_date, end_date)
    return {}

    startkey = site_name.gsub(/\s+/, "_") + start_date.strftime("%Y%m%d")
    endkey = site_name.gsub(/\s+/, "_") + end_date.strftime("%Y%m%d")

    data = Observation.by_site_name_and_date_checked.startkey(startkey).endkey(endkey)

    result = {}
    data.each do |e|
      obs_date = e.date_checked.to_date.strftime("%d-%b-%Y")
      result[obs_date] = 0 if result[obs_date].blank?
      result[obs_date] = result[obs_date] + e.failures
    end

    result.sort_by{|k, v|k.to_date}
    result
  end

  def self.latest_site_obs_date(site_id)
    return {}
    latest_date = self.find_by_sql("SELECT max(obs_datetime) as latest_date FROM observations JOIN definitions
      ON definitions.definition_type = (SELECT definition_type_id FROM definition_types
      WHERE name = 'Validation rule') WHERE site_id =#{site_id} LIMIT 1").last.latest_date
    return latest_date
  end
  
end
