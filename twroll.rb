require 'rubygems'
require 'redis'
require 'pp'

USERS = %w[
  zedshaw
  dojo4
  bobbywilson0
  wayneeseguin
  jtimberman
  geemus
  qrush
  cwyckoff
  brynary
  jimweirich
  mattyoho
  prestonism
  igrigorik
  mjijackson
  emullet
  objo
  elight
  AndyMaleh
  devlindaley
  wycats
]
# unique words
puts "unique words"
redis = Redis.new
words = USERS.map { |name| "tweets:words:#{name}" }
redis.sunionstore("allwords", *words)
p redis.scard("allwords")
puts

puts "top 3 twitters"
top = redis.zrevrange "tweets:count", 0, 2, :with_scores => true
p Hash[*top]
puts

puts "top words"
freqs = USERS.map { |name| "tweets:frequency:#{name}" }
redis.zunionstore("allfreqs", freqs)
top = redis.zrevrange "allfreqs", 0, 9, :with_scores => true
pp top
puts

puts "dirty words"

redis.del "dirty"
words = %w[
shit
piss
fuck
cunt
cocksucker
motherfucker
tits
Shit
Piss
Fuck
Cunt
Cocksucker
Motherfucker
Tits
ass
Ass]
words.each do |word|
  redis.zadd "dirty", 1, word
end
freqs.each do |freq|
  p freq
  redis.zinterstore "dirty:#{freq}", ["dirty", freq]
  top = redis.zrevrange "dirty:#{freq}", 0, -1, :with_scores => true
  p Hash[*top]

end



# create the suits
redis.lpush "suits", "Hearts"
redis.lpush "suits", "Spades"
redis.lpush "suits", "Clubs"
redis.lpush "suits", "Diamons"

# a user picks a suit
redis.lrange "suits", 0, -1
redis.lrem "suits", "Clubs"


