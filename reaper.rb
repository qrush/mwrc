require 'rubygems'
require 'open-uri'
require 'json'
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

USERS.each do |user|
  data = open("http://api.twitter.com/1/users/show.json?screen_name=#{user}")
  json = JSON.parse(data.read)
  puts json["id"]
end
