require "kemal"
require "./simulator"

bind = "0.0.0.0"
Kemal.config.port = ENV["PORT"]?.try(&.to_i) || 3000
Kemal.config.port = 3000

before_get "/groups" do |env|
  env.response.content_type = "application/json"
end

get "/groups" do |env|
  puts "GET on /groups"
  simulator = GroupsSimulator.new
  begin
    simulator.create_groups.to_json
  rescue exception
    {"message": "Hubo un error, por favor refrescar la página"}
  end
end

Kemal.run
