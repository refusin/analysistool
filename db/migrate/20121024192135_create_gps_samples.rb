class CreateGpsSamples < ActiveRecord::Migration
  def change
    create_table :gps_samples do |t|
      t.string :user_id
      t.float :longitude
      t.float :latitude
      t.integer :time

      t.timestamps
    end
  end
end
