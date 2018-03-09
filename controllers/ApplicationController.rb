class ApplicationController < Sinatra::Base

	require "bundler"
	Bundler.require();

	enable :sessions

	register Sinatra::CrossOrigin

	ActiveRecord::Base.establish_connection(
 		:adapter => 'postgresql', 
 		:database => 'calcutta'
	)

	set :views, File.expand_path("../../views", __FILE__)
	set :public_dir, File.expand_path("../../public", __FILE__)


	configure do
		enable :cross_origin
	end

	set :allow_origin, :any
	set :allow_methods, [:get, :post, :options, :put, :delete]
	set :allow_credentials, true




	get "/" do
		erb :splash
	end



	options "*" do
		response.headers["Allow"] = "HEAD, GET, PUT, POST, DELETE, OPTIONS"
		response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
	end

end