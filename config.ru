require 'sinatra/base'
require 'sinatra/activerecord'


# Controllers
require './controllers/ApplicationController'
require './controllers/TeamController'


# Models
require './models/TeamModel'


# Mapping
map('/'){run ApplicationController}
map('/teams'){run TeamController}