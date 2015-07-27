CarrierWave.configure do |config|
  config.storage = :riak
  config.riak_host = '192.168.33.12'
  config.riak_port = 8098
end
