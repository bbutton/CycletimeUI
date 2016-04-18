require_relative '../lib/cycletime_repository.rb'

get '/' do
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

