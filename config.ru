require 'sinatra/base'
require 'sinatra/activerecord'


# Controllers
require './controllers/ApplicationController'


# Models



# Mapping
map('/'){run ApplicationController}