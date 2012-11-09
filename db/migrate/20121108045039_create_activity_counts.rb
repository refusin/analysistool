class CreateActivityCounts < ActiveRecord::Migration
  def change
    create_table :activity_counts do |t|
      t.integer :time
      t.integer :count
      t.integer :userID

      t.timestamps
    end
  end
end
