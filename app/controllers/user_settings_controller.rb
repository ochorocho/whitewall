class UserSettingsController < ApplicationController
	# unloadable
	
	def save

		# @issue = Issue.find(@journalHide.journalized_id)

		# if User.current.allowed_to?(:view_private_notes, @issue.project)
		# ?(:view_private_notes, @issue.project)
		if User.current.admin?
			if !params[:user_id].nil?
				@user = User.find(params[:user_id])
				@user.working_hours = params[:working_hours]

				begin
					@user.save
					flash[:notice] = l(:whitewall_user_settings_flash_successful, :id => view_context.link_to(@user.login, user_path(@user)))
				rescue => error
					flash[:error] = l(:whitewall_user_settings_flash_error, :id => view_context.link_to(@user.login, user_path(@user)))
				end

			else
				flash[:error] = l(:whitewall_user_settings_flash_error, :id => view_context.link_to(@user.login, user_path(@user)))
			end
		else
			flash[:error] = l(:whitewall_user_settings_flash_nopermission, :id => view_context.link_to(@user.login, user_path(@user)))
		end
		redirect_to edit_user_path(@user, tab: 'wall')
	end
end
