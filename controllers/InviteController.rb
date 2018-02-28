class InviteController < ApplicationController 

	get '/' do
		@invites = Invite.all

		resp = {
			status: 200,
			invites: @invites
		}
		resp.to_json
	end

	put '/:id' do
		@invite = Invite.find(params[:id])
		@invite.accepted = true;
		@invite.save

		resp = {
			status: 200,
			invite: @invite
		}
		resp.to_json
	end

	delete '/:id' do
		@invite = Invite.find(params[:id])
		@invites = Pool.find(@invite.pool_id).invites
		@invite.delete

		resp = {
			status: 200,
			message: "The invite has been deleted",
			invites: @invites
		}
		resp.to_json
	end





	
end