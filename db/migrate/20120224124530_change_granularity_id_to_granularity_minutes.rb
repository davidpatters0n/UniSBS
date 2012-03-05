class ChangeGranularityIdToGranularityMinutes < ActiveRecord::Migration
  def up
    rename_column(:site_logentries, :granularity_id, :granularity_minutes)
  end

  def down
  end
end
