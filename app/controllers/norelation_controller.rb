class NorelationController < ApplicationController
  unloadable

	include Redmine::Utils::DateCalculation

	helper :issueweek
	include IssueweekHelper

	def index
		require "date"

		@usersGroup = User.current.groups.all
		@usersGroup.each do |group|

			@settings = Setting.plugin_whitewall["whitewall_group"]
			@groupIds = []
			if @settings.nil?
				@UserAllowed = 'false'
			else
				@settings = Setting.plugin_whitewall["whitewall_group"]["#{group.id}"]
				if @settings.blank?
					@UserAllowed = 'false'
				else 
					@UserAllowed = 'true'
					@groupIds << group.id
				end
			end			
		end

		if @UserAllowed == 'true'
			closed_status_ids = IssueStatus.where(:is_closed => true).pluck(:id)
			@issuesUndefined = Issue.where(editor_id: nil, start_date: nil).where.not(:status_id => closed_status_ids).all
		else
			# NOT LOGGED IN
		end
		render layout: false
	end
end
