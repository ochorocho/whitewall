class GraphController < ApplicationController

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
			# TODO: To be remove
			#@issuesUndefined = Issue.where("editor_id IS NULL OR start_date IS NULL").all
					
			# CHECK PARAMS
			@fromDate = Date.today.beginning_of_week + 4.days
			@fromInput = Date.parse("#{Date.today}").beginning_of_week

			if !params[:to].nil?
				@toDate = Date.parse(params[:to]).end_of_week + 4.days
				@toInput = Date.parse(params[:to]).end_of_week
			else
				@toDate = (Date.today.end_of_week + 4.days).end_of_week + 2.weeks
				@toInput = (Date.today.end_of_week + 4.days).end_of_week + 2.weeks
			end
			
			# CONVERT GIVEN DATE TO WEEK
			@fromWeek = @fromDate.strftime("%W").to_i
			@toWeek = @toDate.strftime("%W").to_i
			
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

			@usersAll = User.joins(:groups).where.not(id: @hideUser, status: [3]).order(login: :asc).distinct

			user_display.each do |user|
	 			@weeks.each do |week|
	 				if week[0].to_f == '53'
	 					calYear = week[1].to_i
	 					calWeek = week[0].to_i
	 				else
	 					calYear = week[1].to_i
	 					calWeek = week[0].to_i
	 				end

	 				weekBegin = Date.commercial(calYear, calWeek, 1)
	 				weekEnd = Date.commercial(calYear, calWeek, 7)


					@issues = Issue.where("editor_id = ? AND ((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?) OR (start_date <= ? AND due_date >= ?))", user.id, weekBegin, weekEnd, weekBegin, weekEnd, weekBegin, weekEnd).select { |i| i.project.active? }

					### ADD ESTIMATED HOURS HELPER HERE ...

	  			end
			end
		else
			# NOT LOGGED IN
		end
	end
end
