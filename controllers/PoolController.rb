class PoolController < ApplicationController

	get "/all" do
		@pools = Pool.all

		resp = {
			status: 200,
			pools: @pools
		}
		resp.to_json
	end

	get '/:id' do
		@pool = Pool.find(params[:id])
		@pool_members = @pool.users
		@pool_bids = @pool.bids
		@teams = Team.all

		resp = {
			status: 200,
			message: "Pool #{@pool.id} info, pool's user info, pool's bid info, team info",
			data: {
				pool: @pool,
				users: @pool_members,
				bids: @pool_bids,
				teams: @teams	
			}
		}
		resp.to_json

	end

	post '/' do
		# Create new pool
		@pool = Pool.new
		@pool.name = params[:name]
		@pool.owner = params[:user_id]
		@pool.save

		# Create an invite to link the user with the pool
		@pool.invites.create(user_id: params[:user_id], accepted: true)

		# Find all of that user's pools
		@pools = User.find(params[:user_id]).pools

		resp = {
			status: 200,
			message: "Created #{@pool.name}",
			data: {
				pools: @pools,
				number_of_pools: @pools.length
			}
		}
		resp.to_json
	end

	post '/invite' do
		@pool = Pool.find(params[:pool_id])
		@user = User.find_by(name: params[:username])
		@invite = @pool.invites.create(user_id: @user.id, accepted: true)

		resp = {
			status: 200,
			message: "Invited #{@user.name} to #{@pool.name} ",
			data: {
				pool: @pool,
				user: @user,
				invite: @invite
			}
		}
		resp.to_json
	end

	post '/bid' do
		
	end

	get '/bids' do
		@bids = Pool.find(1).bids

		resp = {
			status: 200,
			number_of_bids: @bids.length,
			bids: @bids
		}
		resp.to_json
	end



end