class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites, :primary_key => :site_id do |t|
      t.string :name
      t.string :description
      t.string :host
      t.integer :port
      t.string :code
      t.string :x
      t.string :y
      t.string :region
      t.boolean :enabled, :default => false
      t.integer :creator
      t.timestamps
    end
  end
end
