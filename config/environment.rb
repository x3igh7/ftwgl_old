# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ftwgl::Application.initialize!

# config for SendGrid
ActionMailer::Base.smtp_settings = {
  :user_name => 'x8igh7',
  :password => 'Sm.08430',
  :domain => 'ftwgl.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
