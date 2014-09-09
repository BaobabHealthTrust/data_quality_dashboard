class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations, :primary_key => :observation_id do |t|
      t.integer :site_id
      t.integer :definition_id
      t.integer :value_numeric
      t.date :value_date
      t.date :obs_datetime
      t.string  :value_text
      t.integer :creator
      t.timestamps
    end
  end
end
