CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['FTW_S3_KEY'],
    aws_secret_access_key: ENV['FTW_S3_SECRET_KEY'],
    region:                'us-east-1'
  }
  config.fog_directory = ENV['FTW_S3_BUCKET']                          # required
end
