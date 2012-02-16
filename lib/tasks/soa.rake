
namespace :soa do
  desc 'Tasks for Matflo SOA'
  namespace :token do
    desc 'Manage SOA authentication'
    task :generate do
      desc 'Randomly generated secure token for SOA'
      puts 'Creating new token...'
      newtoken = SecureRandom.base64(96) #.delete "=/+"
      filename = "#{Rails.root}/config/tokens/endpoint_me.token"
      puts "Writing to #{filename}..."
      File.open(filename , 'w') {|f| f.write(newtoken) }
      puts 'Done'
      puts 'Make sure you also transfer to the SOA!'
    end
  end
end

