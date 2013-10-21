require "redis"

redis_conf = File.read(Rails.root.join("config/redis", "#{Rails.env}.conf"))

port = /port.(\d+)/.match(redis_conf)[1]
`redis-server #{redis_conf}`
res = `ps aux | grep redis-server`

unless res.include?("redis-server") && res.include?(redis_conf)
  raise "Couldn't start redis"
end

REDIS = Redis.new(:port => port)
