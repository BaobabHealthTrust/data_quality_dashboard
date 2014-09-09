class CreateDefinitionTypes < ActiveRecord::Migration
  def change
    create_table :definition_types, :primary_key => :definition_type_id do |t|
      t.string  :name
      t.integer :creator
      t.timestamps
    end
  end
end
