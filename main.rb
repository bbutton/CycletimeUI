require_relative './lib/vcap_services_parser.rb'
require_relative 'lib/cycletime_repository.rb'
require_relative 'lib/board_repository.rb'
require 'sinatra/base'

class CycleTimeUi < Sinatra::Base
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'centurylink' and password == 'CloudCity2015!'
  end

  configure do
    orchestrate_api_key = ENV["ORCHESTRATE_API_KEY"]
    orchestrate_collection = ENV["ORCHESTRATE_COLLECTION"]
    orchestrate_endpoint = ENV["ORCHESTRATE_ENDPOINT"]

    db_host = ENV["DB_HOST"]
    db_port = ENV["DB_PORT"]
    db_user = ENV["DB_USER"]
    db_password = ENV["DB_PASSWORD"]
    db_name = ENV["DB_NAME"]

    if(ENV["VCAP_SERVICES"] != nil)
      parser = VcapServicesParser.new
      services = parser.parse(ENV["VCAP_SERVICES"])

      orchestrate_api_key = services["ORCHESTRATE_API_KEY"]
      orchestrate_collection = services["ORCHESTRATE_COLLECTION"]
      orchestrate_endpoint = services["ORCHESTRATE_ENDPOINT"]

      db_host = services["DB_HOST"]
      db_port = services["DB_PORT"]
      db_user = services["DB_USER"]
      db_password = services["DB_PASSWORD"]
      db_name = services["DB_NAME"]
    end

    set :orchestrate_api_key, orchestrate_api_key
    set :orchestrate_collection, orchestrate_collection
    set :orchestrate_endpoint, orchestrate_endpoint

    set :db_host, db_host
    set :db_port, db_port
    set :db_user, db_user
    set :db_password, db_password
    set :db_name, db_name
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
    board_repository = BoardRepository.new(settings.db_host, settings.db_port, settings.db_user, settings.db_password, settings.db_name)
    @update_status = board_repository.get_board_status(id)
    status 200
    erb :index
  end

  post '/update/:board_id' do |id|
    board_repository = BoardRepository.new(settings.db_host, settings.db_port, settings.db_user, settings.db_password, settings.db_name)
    board_repository.start_update_for_board(id)

    redirect('/cycletimes/' + id)
  end
end


