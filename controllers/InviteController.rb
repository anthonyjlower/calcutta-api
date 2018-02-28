class InviteController < ApplicationController 

	get '/' do
		@invites = Invite.all

		resp = {
			status: 200,
			invites: @invites
		}
		resp.to_json
	end





	
end