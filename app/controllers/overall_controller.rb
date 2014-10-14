class OverallController < ApplicationController
  unloadable

	include Redmine::Utils::DateCalculation

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

			@issuesUndefined = Issue.where("assigned_to_id IS NULL OR start_date IS NULL").all
					
			# CHECK PARAMS
			if !params[:from].nil?
				@fromDate = Date.parse(params[:from])
				@fromInput = Date.parse(params[:from])
			else
				@fromDate = Date.today
				@fromInput = Date.parse("#{Date.today}")
			end
			if !params[:to].nil?
				@toDate = Date.parse(params[:to])
				@toInput = Date.parse(params[:to])
			else
				@toDate = Date.today + 2.weeks
				@toInput = Date.today + 2.weeks
			end
						
			@hideUser = Setting.plugin_whitewall["whitewall_hideuser"].split(/,/);
			@hideUser << 2
			
			### TICKETS PER TRACKER
			@trackers = Tracker.find(:all)
      
			@chartLines = []
			@trackers.each do | tracker |
        @chartLines << tracker.name
			  @fromDate.upto(@toDate) { |date|
          tracker["issues#{date}"] = Issue.find(:all, :include => [ :priority ], :conditions => ["tracker_id = ? AND (created_on BETWEEN ? AND ?)", tracker.id, date, date.end_of_day]).count
        }
			end			
						
		else
			# NOT LOGGED IN
		end
	end
end
