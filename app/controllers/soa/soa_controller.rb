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

  def restrict_soa_token

    # Until we see differently...
    token_ok = true

    # Next, find the expected security token
    @soa = Soa.find(:first)
    unless @soa.nil?
      exp_token = Digest::MD5.hexdigest( "#{@soa.next_token} Clyde_01" )
      logger.debug "Next Token is #{@soa.next_token}"
    else
      exp_token = nil
      logger.debug "Next Token is <blank>"
    end

    # Generate new security token for next request
    next_token = rand(2**128)
    @soa = Soa.new if @soa.nil?
    @soa.next_token = next_token
    @soa.save!

    # Check whether the found token matches
    if exp_token.nil? || exp_token != cookies[ :soa_token ]
      token_ok = false
    end

    # Set the token for the next request
    logger.debug "Expect  cookie #{exp_token}"
    logger.debug "Current cookie #{cookies[ :soa_token ]}"
    cookies[ :soa_token ] = { :value => next_token }
    logger.debug "Setting cookie #{cookies[ :soa_token ]}"
    
    unless token_ok
      respond_to do |format|
        format.html { render :text => 'Wrong token', :status => 403 }
      end
    end
  end

end
