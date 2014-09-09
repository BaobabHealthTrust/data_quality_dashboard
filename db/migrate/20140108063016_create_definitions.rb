class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions, :primary_key => :definition_id do |t|
      t.integer :definition_type
      t.string :short_name
      t.string :full_name
      t.string :description
      t.integer :creator
      t.timestamps
    end
  end
end
