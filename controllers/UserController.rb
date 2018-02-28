class UserController < ApplicationController

	get	'/' do
		@users = User.all

		resp = {
			status: 200,
			message: "Here are all of the users in the db",
			number_of_users: @users.length,
			users: @users
		}
		resp.to_json
	end

	post '/' do
		@user = User.new
		@user.name = params[:name]
		@user.save

		resp = {
			status: 200,
			message: "Created user #{@user.name}",
			user: @user
		}
		resp.to_json
	end

	get	'/invites' do
		@invites = User.find(1).invites

		resp = {
			status: 200,
			invites: @invites
		}
		resp.to_json
	end

	get	'/bids' do
		@bids = User.find(1).bids

		resp ={
			status: 200,
			number_of_bids: @bids.length,
			bids: @bids
		}
		resp.to_json
	end




end