require "kemal"
require "./simulator"
require "option_parser"

bind = "0.0.0.0"
port = 8080

OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end

get "/groups" do |env|
  env.response.content_type = "application/json"
  simulator = GroupsSimulator.new
  simulator.create_groups.to_json
end

Kemal.run
