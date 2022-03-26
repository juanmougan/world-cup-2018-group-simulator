require "kemal"
require "./simulator"

bind = "0.0.0.0"
Kemal.config.port = ENV["PORT"]?.try(&.to_i) || 3000

get "/groups" do |env|
  puts "GET on /groups"
  env.response.content_type = "application/json"
  simulator = GroupsSimulator.new
  simulator.create_groups.to_json
end

Kemal.run
