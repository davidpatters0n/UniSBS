class Soa::SoaController < ApplicationController
  
  # The SoaController is responsible for web service response to the
  # Matflo SOA system.
  # The SoaController is in contrast to the PortalController, which
  # is for user access.

  before_filter :restrict_soa_ip
  before_filter :restrict_soa_token

  # Restrict access to the IP for the SOA system only.
  # This controller isn't available to general web users
  def restrict_soa_ip
    unless Rails.application.config.soa_whitelist.include?(request.remote_ip)
      logger.debug "Attempt to access SOA from IP address not on " +
                   "the whitelist: #{request.remote_ip}"

      # access_denied goes to standard screen, used also for incorrect
      # routes:
      access_denied
    end
  end

  def encrypt_token(token)
    #Digest::MD5.hexdigest(token)
    Digest::SHA2.hexdigest(token)
  end

    def self.token_filename
    "#{Rails.root}/config/tokens/endpoint_me.token"
  end

  def get_portal_token
    File.read(Soa::SoaController.token_filename).rstrip
  end

 end

  def restrict_soa_token

    # Get the expected random security token
    @soa = Soa.find(:first)
    
    if @soa.nil?
      logger.debug "Next Token is <blank>"
      expected_token = nil
    else
      logger.debug "Next Token is '#{@soa.next_token} [password]'"
      portal_token = get_portal_token()
      expected_token = encrypt_token("#{@soa.next_token}#{portal_token}")
    end
    
    # Check whether the cookie token matches the expected token
    logger.debug "Expected cookie #{expected_token}"
    logger.debug "Received cookie #{cookies[:soa_token]}"
    if expected_token.nil? or expected_token != cookies[:soa_token]
      token_ok = false
    else
      token_ok = true
    end

    # Generate new security token for next request
    @soa = Soa.new if @soa.nil?
    @soa.next_token = SecureRandom.base64(96).gsub(/\+/, '_').gsub(/\//, '-').delete("=")
    @soa.save!
    cookies[:soa_token] = { :value => @soa.next_token }
    
    unless token_ok
      respond_to do |format|
        format.html { render :text => 'Wrong token', :status => 403 }
      end
    end
  end

