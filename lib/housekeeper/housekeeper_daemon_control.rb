class HousekeeperDaemonControl

  def self.start
    daemon_start_time = take_lock()
    daemon_command = base_daemon_command()
    if ['mingw32'].include? Config::CONFIG['host_os']
      daemon_command = "start ruby #{daemon_command} '#{daemon_start_time}'"
    else
      daemon_command << " '#{daemon_start_time}' &"
    end

    system(daemon_command)
  end

  def self.restart
    start
  end
  
  def self.stop
    File.delete(daemon_lockfile) if File.exists?(daemon_lockfile)
  end

  private

  def self.base_daemon_command
    "#{Rails.root}/script/housekeeper_daemon"
  end

  def self.daemon_lockfile
    base_daemon_command + '.lock'
  end

  def self.take_lock
    daemon_start_time = Time.now.to_s
    File.open(daemon_lockfile, 'w') {|f| f.write(daemon_start_time) }
    return daemon_start_time
  end

end
