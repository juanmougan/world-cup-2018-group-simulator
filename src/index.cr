require "kemal"
require "./simulator"
require "option_parser"

bind = "0.0.0.0"
port = 8080

get "/groups" do |env|
  puts "GET on /groups"
  env.response.content_type = "application/json"
  simulator = GroupsSimulator.new
  simulator.create_groups.to_json
end

Kemal.run
