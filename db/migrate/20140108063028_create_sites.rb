class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites, :primary_key => :site_id do |t|
      t.string :name
      t.string :host
      t.integer :port
      t.string :code
      t.integer :x
      t.integer :y
      t.string :region
      t.integer :creator
      t.timestamps
    end
  end
end
