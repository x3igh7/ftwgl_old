require 'single_sign_on'

class DiscourseSsoController < ApplicationController
  before_filter :authenticate_user! # ensures user must login

  def sso
    sso = SingleSignOn.parse(request.query_string, ENV["SSO_SECRET"])
    sso.email = current_user.email # from devise
    sso.username = current_user.username # from devise
    sso.external_id = current_user.id # from devise
    sso.sso_secret = ENV["SSO_SECRET"]

    redirect_to sso.to_url("http://forums.ftwgl.com/session/sso_login")
  end
end
