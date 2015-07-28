CarrierWave.configure do |config|
  config.storage = :riak
  config.riak_host = 'ryoshin-storage'
  config.riak_port = 8098
end
