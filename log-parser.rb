#!/usr/bin/env ruby
# Author - Montrey Whittaker
# Analyze logs to identify slow servers

require 'date'
require 'zlib'
require 'pp'

file     = 'logsample.txt.gz'  # File of logs to parse
timings  = Hash.new                 # Store timestamps by guid
servers  = Hash.new                 # Store servers by guid
totals   = Hash.new                 # Store all requests by server
averages = Hash.new                 # Store average execution times for each server

Zlib::GzipReader.open(file) {|gz|
  gz.each_line {|line|
    # Extract key components of log
    cols   = line.split(' ')
    time   = cols[0]
    guid   = cols[1]
    server = cols[7]
    
    # Add the timestamp for the guid
    timings[guid] = [] unless timings.has_key?(guid)
    timings[guid] << DateTime.parse(time).strftime('%Q').to_i

    # Add the server for the guid
    servers[guid] = [] unless servers.has_key?(guid)
    servers[guid] << server

    # Calculate the execution time if we have enough data to do so
    diff = -1
    if timings[guid].size == 2 # Calculate frontend time
      diff = timings[guid][1] - timings[guid][0]
      serv = servers[guid][1]
    elsif timings[guid].size == 3 # Calculate backend time
      diff = timings[guid][2] - timings[guid][1]
      serv = servers[guid][0]
    end
    if diff >= 0
      totals[serv] = [] unless totals.has_key?(serv)
      totals[serv] << diff
    end
  }
}

# Calculate average response time per server
totals.each {|server,reqs|
  sum = 0
  reqs.each {|r| sum += r }
  averages[server] = sum / reqs.size
}

# Print results sorted from slowest to fastest
pp averages.sort_by(&:last).reverse.to_h
