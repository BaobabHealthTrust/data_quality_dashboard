class Definition < ActiveRecord::Base
  set_primary_key :definition_id
  validates_uniqueness_of :full_name
  validates_uniqueness_of :short_name

  def self.check (description, type)
    definition = Definition.where("short_name = ? OR full_name = ?", description,description )

    if definition.blank?
      user = User.first.id
      type = DefinitionType.where(:name => type).first.id

      return Definition.create({:definition_type => type,
                                :short_name => description,
                                :full_name => description,
                                :creator => user
                               }).id
    else
      return definition.first.id
    end
  end
end
