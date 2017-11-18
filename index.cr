require "kemal"
require "./simulator"

get "/groups" do |env|
  env.response.content_type = "application/json"
  simulator = GroupsSimulator.new
  simulator.create_groups.to_json
end

Kemal.run
