
namespace :soa do
  namespace :token do
    desc 'Manage SOA token'
    task :generate do
      puts 'Creating new token!'
      puts 'Make sure you also transfer to the SOA...'
      newtoken = SecureRandom.base64(96).delete "=/+"
      File.open(Soa::SoaController.token_filename , 'w') {|f| f.write(newtoken) }
      puts 'Done'
    end
  end
end

