Recaptcha.configure do |config|
  config.public_key  = ENV["FTW_RECAPTCHA_PUBLIC"]
  config.private_key = ENV["FTW_RECAPTCHA_PRIVATE"]
end
