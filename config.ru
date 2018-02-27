require 'sinatra/base'
require 'sinatra/activerecord'


# Controllers
require './controllers/ApplicationController'
require './controllers/BidController'
require './controllers/InviteController'
require "./controllers/PoolController"
require './controllers/TeamController'
require './controllers/UserController'



# Models
require './models/BidModel'
require './models/InviteModel'
require './models/PoolModel'
require './models/TeamModel'
require './models/UserModel'


# Mapping
map ('/') {
	run ApplicationController
}
# map ('/bids') {
# 	run BidController
# }
# map ('/invites') {
# 	run InviteController
# }
# map ('/pools') {
# 	run PoolController
# }
# map ('/teams') {
# 	run TeamController
# }
map ('/user') {
	run UserController
}
