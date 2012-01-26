class CreateSoa < ActiveRecord::Migration
  def change
    create_table :soa, :id => false do |t|
      t.string :next_token

      t.timestamps
    end
  end
end
