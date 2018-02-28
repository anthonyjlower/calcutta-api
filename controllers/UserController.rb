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

	get	'/:id/invites' do
		@user = User.find(params[:id])
		@invites = @user.invites

		resp = {
			status: 200,
			invites: @invites
		}
		resp.to_json
	end




end