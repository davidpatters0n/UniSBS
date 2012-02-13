
require 'rbconfig'

daemon_command = File.dirname(__FILE__) + "/../../script/housekeeper_daemon"

daemon_start_time = Time.now.to_s
File.open(daemon_command+".lock", 'w') {|f| f.write(daemon_start_time) }
at_exit do
  daemon_lockfilename = "script/housekeeper_daemon.lock" 
  begin
    File.delete(daemon_lockfilename) if File.exists?(daemon_lockfilename)
  rescue => e
    p e.message
  end
end

puts "At #{daemon_start_time} (host_os='#{Config::CONFIG['host_os']}')"

if ['mingw32'].include? Config::CONFIG['host_os']
  puts "Starting housekeeper Windows-style..."
  daemon_command = "start ruby #{daemon_command} '#{daemon_start_time}'"
else
  puts "Starting housekeeper Unix-style..."
  daemon_command << "#{daemon_start_time} &"
end

puts daemon_command
if system(daemon_command)
  puts "Housekeeper running"
else
  raise "Failed to run up Housekeeper"
end

