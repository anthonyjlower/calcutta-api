class ApplicationController < Sinatra::Base

	require "bundler"
	Bundler.require();

	register Sinatra::CrossOrigin

	ActiveRecord::Base.establish_connection(
 		:adapter => 'postgresql', 
 		:database => 'calcutta'
	)

	configure do
		enable :cross_origin
	end

	set :allow_origin, :any
	set :allow_methods, [:get, :post, :options, :put, :delete]
	set :allow_credentials, true




	get "/" do
		"Sinatra server is running"
	end

	get '/test' do
		binding.pry
	end



	options "*" do
		response.headers["Allow"] = "HEAD, GET, PUT, POST, DELETE, OPTIONS"
		response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
	end

end