class HousekeeperDaemonControl

  def self.start

    if Rails.application.config.housekeeper_deamon_options
      options = Rails.application.config.housekeeper_deamon_options
    else
      options = ""
    end

    if ['mingw32'].include? Config::CONFIG['host_os']
      cmd = "start ruby #{daemon_script} #{options}"
    else
      cmd << "nohup ruby #{daemon_script} #{options} 2>&1 &"
    end

    system(cmd)
  end

  def self.restart
    start
  end
  
  def self.stop
    File.delete(daemon_lockfile) if File.exists?(daemon_lockfile)
  end

  private

  def self.daemon_script
    "#{Rails.root}/script/housekeeper_daemon"
  end

  def self.daemon_lockfile
    daemon_script + '.lock'
  end

end
