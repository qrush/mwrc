#!/usr/bin/env ruby

require 'redis'


stat  = File.stat("normal.txt")
p sprintf("%b", stat.mode).scan(/\d/)


