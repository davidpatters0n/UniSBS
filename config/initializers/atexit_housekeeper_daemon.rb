
at_exit do
  lockfilename = File.expand_path("../../../script/housekeeper_daemon.lock", __FILE__)
  begin
    File.delete(lockfilename) if File.exists?(lockfilename)
  rescue => e
    p e.message
  end
end

