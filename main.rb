require_relative './lib/vcap_services_parser.rb'

# configure do
#   orchestrate_api_key = ENV["ORCHESTRATE_API_KEY"]
#   orchestrate_collection = ENV["ORCHESTRATE_COLLECTION"]
#   orchestrate_endpoint = ENV["ORCHESTRATE_ENDPOINT"]
#
#   if(ENV["VCAP_SERVICES"] != nil)
#     parser = VcapServicesParser.new
#     services = parser.parse(ENV["VCAP_SERVICES"])
#
#     orchestrate_api_key = services["ORCHESTRATE_API_KEY"]
#     orchestrate_collection = services["ORCHESTRATE_COLLECTION"]
#     orchestrate_endpoint = services["ORCHESTRATE_ENDPOINT"]
#   end
#
#   set :orchestrate_api_key, orchestrate_api_key
#   set :orchestrate_collection, orchestrate_collection
#   set :orchestrate_endpoint, orchestrate_endpoint
# end

#require_relative './routes/init.rb'
#require_relative './helpers/init.rb'

require_relative 'lib/cycletime_repository.rb'
require 'sinatra/base'

class CycleTimeUi < Sinatra::Base
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'centurylink' and password == 'CloudCity2015!'
  end

  configure do
    orchestrate_api_key = ENV["ORCHESTRATE_API_KEY"]
    orchestrate_collection = ENV["ORCHESTRATE_COLLECTION"]
    orchestrate_endpoint = ENV["ORCHESTRATE_ENDPOINT"]

    if(ENV["VCAP_SERVICES"] != nil)
      parser = VcapServicesParser.new
      services = parser.parse(ENV["VCAP_SERVICES"])

      orchestrate_api_key = services["ORCHESTRATE_API_KEY"]
      orchestrate_collection = services["ORCHESTRATE_COLLECTION"]
      orchestrate_endpoint = services["ORCHESTRATE_ENDPOINT"]
    end

    set :orchestrate_api_key, orchestrate_api_key
    set :orchestrate_collection, orchestrate_collection
    set :orchestrate_endpoint, orchestrate_endpoint
  end

  get '/' do
    status 200
  end

  get '/favicon.ico' do
    status 404
  end

  get '/cycletimes/:board_id' do |id|
    cycletimes = CycletimeRepository.new settings.orchestrate_api_key, settings.orchestrate_collection, settings.orchestrate_endpoint

    d = cycletimes.fetch(id)
    @board_name = d[:board_name]
    @data = d[:cycle_times]
    @board_id = id
    @instance_number = ENV["CF_INSTANCE_INDEX"] || -1

    status 200
    erb :index
  end
end


