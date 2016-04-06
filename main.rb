require_relative './lib/vcap_services_parser.rb'

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

  #config_file = YAML.load_file './config.yml'
  #api_key = ENV['WUFOO_API_KEY']

  #wufoo_api = WuParty.new(config_file['config_data'][0]['wufoo_account_id'], api_key)
  #set :wufoo_api, wufoo_api

  #set :results_dir, config_file['config_data'][0]['results_dir']
  #set :scoring_files, config_file['config_data'][0]['scoring_files']
end

require_relative './routes/init.rb'
require_relative './helpers/init.rb'
