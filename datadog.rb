require 'dogapi'
require 'json'
require 'colorize'

# Check env vars

['DATADOG_API_KEY', 'DATADOG_APP_KEY', 'DATADOG_MONITORS_IDS', 'CANARY_CHECK_RULE'].each { |e| ENV["#{e}"] || raise("no #{e} provided") }

unless ENV['CANARY_CHECK_RULE'].casecmp?("and") || ENV['CANARY_CHECK_RULE'].casecmp?("or")
  raise("The env var CANARY_CHECK_RULE should be \"AND\" or \"OR\"")
end

api_key = ENV['DATADOG_API_KEY']
app_key = ENV['DATADOG_APP_KEY']
mon_ids = ENV['DATADOG_MONITORS_IDS']
rule = ENV['CANARY_CHECK_RULE']

dog = Dogapi::Client.new(api_key, app_key)

# String to array

if mon_ids.include? "," 
  mon_ids = mon_ids.split(',')
else
  mon_ids = Array(mon_ids)
end 

# Results counter

r = 0

# Checking the state of each monitor
mon_ids.each do |m|
  monitor = dog.get_monitor(m, group_states: 'all')[1].to_json
  output = JSON.parse(monitor)
  result = output["overall_state"]
  if result == "OK"
    puts "#{"[OK]".green} - #{m} => #{output["name"]}"
    r += 1
  else
    puts "#{"[ERR]".red} - #{m} => #{output["name"]}"
    break if rule.casecmp?("and")
  end
end

puts "------"

if rule.casecmp?("and")
  if r == mon_ids.count()
    puts "OK".green
    exit(true)
  else
    puts "ERR".red
    exit(false)
  end
else
  if r > 0
    puts "OK".green
    exit(true)
  else
    puts "ERR".red
    exit(false)
  end
end
