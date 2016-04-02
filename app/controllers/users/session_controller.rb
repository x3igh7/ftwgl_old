class Users::SessionsController < Devise::SessionsController
	include UrlHelper
	require 'openssl'
	require 'base64'

	def sso
	  # authenticate
	  self.resource = warden.authenticate(auth_options)
	  resource_name = self.resource_name
	  sign_in(resource_name, resource)
	  if user_signed_in?
	    # redirect to forum
	    sig = params[:sig]
	    sso = params[:sso]
	    if OpenSSL::HMAC.hexdigest('sha256', ENV["SSO_SECRET"], sso) == sig
	    	nonce = Base64.decode64(sso)
	    	sso = Base64.encode64(nonce + '&username=' + resource.username + '&email=' + resource.email + '&external_id=' + resource.id.to_s)
	    	sig = OpenSSL::HMAC.hexdigest('sha256', ENV["SSO_SECRET"], sso)
	    	return_params = { sso: sso, sig: sig }
	    	redirect_to generate_url( ENV["FORUM_URL"]+"/session/sso_login", return_params )
	    end
	  else
	  	redirect_to new_user_registration, alert: t('.sign_in')
	  end
	end

end
