class CreateGranularities < ActiveRecord::Migration
  def change
    create_table :granularities do |t|
      t.integer :minutes

      t.timestamps
    end
  end
end
