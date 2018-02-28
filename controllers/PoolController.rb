class PoolController < ApplicationController

	get "/" do
		@pools = Pool.all

		resp = {
			status: 200,
			pools: @pools
		}
		resp.to_json
	end

	post '/' do
		@pool = Pool.new
		@pool.name = params[:name]
		@pool.owner = params[:user_id]
		@pool.save

		resp = {
			status: 200,
			pool: @pool
		}
		resp.to_json
	end

	post '/invite' do
		@pool = Pool.find(1)
		@invite = @pool.invites.create(pool_id: @pool.id, user_id: params[:user_id], accepted: false)

		resp = {
			status: 200,
			invite: @invite
		}
		resp.to_json
	end

end