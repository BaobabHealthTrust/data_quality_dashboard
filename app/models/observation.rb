class Observation < ActiveRecord::Base
  set_primary_key :observation_id
  belongs_to :site, :foreign_key => :site_id
  belongs_to :definition, :foreign_key => :definition_id
  validates_presence_of :site_id
  validates_presence_of :definition_id

  def self.distinct_issues
    defns = Definition.where(:name => "Data quality rule violation").first.id

    issue_list = Observation.find_by_sql("SELECT DISTINCT value_text FROM observations "+
                                            " WHERE definition_id = #{defns}").collect{|x| x.value_text}

    return issue_list
  end
end
