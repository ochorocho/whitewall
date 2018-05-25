class IndexController < ApplicationController

	
	include Redmine::Utils::DateCalculation

	helper :issueweek
	include IssueweekHelper

	def index
		require "date"

		@usersGroup = User.current.groups.all
		@groupIds = []
		@usersGroup.each do |group|

			@settings = Setting.plugin_whitewall["whitewall_group"]
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

			# CHECK PARAMS
			if !params[:from].nil?
				@fromDate = Date.parse(params[:from]).beginning_of_week + 4.days
				@fromInput = Date.parse(params[:from]).beginning_of_week
			else
				@fromDate = Date.today.beginning_of_week + 4.days
				@fromInput = Date.parse("#{Date.today}").beginning_of_week
			end
			if !params[:to].nil?
				@toDate = Date.parse(params[:to]).end_of_week + 4.days
				@toInput = Date.parse(params[:to]).end_of_week
			else
				@toDate = (Date.today.end_of_week + 4.days).end_of_week + 2.weeks
				@toInput = (Date.today.end_of_week + 4.days).end_of_week + 2.weeks
			end

			# CONVERT GIVEN DATE TO WEEK
			@fromWeek = @fromDate.strftime("%U").to_i
			@toWeek = @toDate.strftime("%U").to_i

			weeks = []
			while @fromDate < @toDate
				weeks << [@fromDate.cweek, @fromDate.year]
				@fromDate += 1.week
			end

			@weeks = []
			weeks.each do |w,y|
				date = []
				7.times do |day|
					day = day + 1
					date << Date.parse("#{Date.commercial(y, w, day)}").to_s(:short_date)
				end
				@weeks << [w,y,date]
			end

			@hideUser = Setting.plugin_whitewall["whitewall_hideuser"].split(/,/);
			@hideUser << '2'
			@usersAll = User.joins(:groups).where("users.id NOT IN (?) AND users.status NOT IN (?)", @hideUser, [3]).distinct

			@users = []

			if !params[:user_select].nil?

				@userSelect = params[:user_select]
				if User.current.id.in?(params[:user_select])
					@userSelect = User.current.id + @userSelect
				end
				@userSelect << '2'
				@users += User.joins(:groups).where("users.id IN (?) AND users.id NOT IN (?) AND users.status NOT IN (?)", @userSelect, @hideUser, [3]).distinct

			else
				@users += User.joins(:groups).where("users.id NOT IN (?) AND users.status NOT IN (?)", @hideUser, ['3']).distinct
			end
				# Move User.current to top ...
				@users.unshift(@users.delete(User.current))
		else
			# NOT LOGGED IN
		end
	end
end