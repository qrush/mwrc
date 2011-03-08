#!/usr/bin/env ruby

require 'redis'

class Permify
  def self.redis
    @redis ||= Redis.new
  end

  def self.load
    Dir["*"].each do |file|
      perm = Permify.new(file)

      perm.mode.to_s.scan(/\d/).reverse.each_with_index do |bit, index|
        redis.setbit("perms:#{file}", index, bit)
      end
    end
  end

  def initialize(path)
    @path = path
  end

  def mode
    stat = File.stat(@path)
    sprintf("%b", stat.mode)
  end

  def get(offset)
    self.class.redis.getbit(key, offset)
  end

  def key
    "perms:#{@path}"
  end

  {owner_readable?:   8,
   owner_writeable?:  7,
   owner_executable?: 6,
   group_readable?:   5,
   group_writeable?:  4,
   group_executable?: 3,
   other_readable?:   2,
   other_writeable?:  1,
   other_executable?: 0}.each do |name, offset|
    define_method name do
      get offset
    end
  end

  def redis_mode
    sprintf("%b", self.class.redis.get(key).unpack("S")[0])
  end
end
