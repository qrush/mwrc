require 'rubygems'
require 'tweetstream'
require 'redis'

redis    = Redis.new
user_ids = File.readlines("user_ids.txt").map(&:to_i)

TweetStream::Daemon.new(ENV['USER'],ENV['PASSWORD']).follow(*user_ids) do |status|
  handle = status.user.screen_name

  puts "[#{handle}] #{status.text}"

  redis.zincrby "tweets:count", 1, handle
  status.text.split.each do |word|
    redis.sadd "tweets:words:#{handle}", word
    redis.zincrby "tweets:frequency:#{handle}", 1, word
  end
end
