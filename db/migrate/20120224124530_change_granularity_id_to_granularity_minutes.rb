class ChangeGranularityIdToGranularityMinutes < ActiveRecord::Migration
  def up
    rename_column(:site_logentries, :granularity_minutes, :granularity)
  end

  def down
  end
end
