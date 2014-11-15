#!/usr/bin/env ruby

file = File.read('style.css')

File.write('style.min.css', file.gsub("\n", "").gsub("\t", "").gsub(" ", ""))
