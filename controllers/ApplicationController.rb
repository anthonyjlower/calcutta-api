class ApplicationController < Sinatra::Base

	require 'bundler'
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


	get	'/' do
		'Sinatra Server is running'
	end


end