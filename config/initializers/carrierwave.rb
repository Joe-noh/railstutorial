CarrierWave.configure do |config|
  config.asset_host = "https://#{ENV['HOST_NAME']}"
end
