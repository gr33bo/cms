require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'
require 'jdbc/postgres'
require 'sequel'
require 'logger'
require 'json'
require 'yaml'
#require 'fileutils'



config_file = File.open("./config/torquebox.yml")
config = YAML.load(config_file.read)

#puts config

#puts "=====#{ENV['RACK_ENV']}============="

ENV["data_source"] = config["environment"]["#{ENV['RACK_ENV']}"]['data_source']
#ENV["es_server"] = config["environment"]['es_server']

Dir.glob('lib/*.rb').each { | file | require file }

DB ||= Sequel.connect(ENV['data_source'])
#ES ||= Elasticsearch::Client.new hosts: [ENV['es_server']]

class App < Sinatra::Base
  
#  use TorqueBox::Session::ServletStore
 
  set :show_exceptions, true
#  set :public_folder, File.join(File.dirname(__FILE__), 'public/app')
  #set :root, File.dirname(__FILE__)


#  THUMB_DIMENSIONS = [200, 200]
  
  configure :development do
    $logger = Logger.new(STDOUT)
    $logger.level = ::Logger.const_get('DEBUG')
    $logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    DB.loggers << $logger
#    DB.log_warn_duration = 0.0001 #0.2
    #DB ||= Sequel.connect('jdbc:postgresql://elvin/svr?user=meta')
    register Sinatra::Reloader
    also_reload 'lib/*'
    also_reload 'models/*'
    #DB.log_warn_duration = 0.2
    DB.log_warn_duration = 2
  end
  
  
  get "/" do
    "Hello world!"
  end
  
#  puts "================"
#  puts App.server.inspect
#  puts App.server.methods.sort.inspect
end


Dir.glob('models/*.rb').each { | file | require file }
Dir.glob('{controllers}/*.rb').each { | file | require file }
#