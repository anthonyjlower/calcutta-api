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





	
end