class GraphController < ApplicationController
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

			@usersAll = User.find(:all, :joins => :groups, :order => "login asc", :conditions => ["users.id NOT IN (?) AND users.status NOT IN (?) AND groups_users.id IN (?)", [2], [3], @groupIds])
			
			if !params[:user_select].nil?
				@userSelect = params[:user_select]
				@userSelect << 2
				@users = User.find(:all, :joins => :groups, :order => "login asc", :conditions => ["users.id IN (?) AND users.id NOT IN (?) AND users.status NOT IN (?) AND groups_users.id IN (?)", @userSelect, [2], [3], @groupIds])
			else
				@users = User.find(:all, :joins => :groups, :order => "login asc", :conditions => ["users.id NOT IN (?) AND users.status NOT IN (?) AND groups_users.id IN (?)", [2], [3], @groupIds])
			end

	 		@users.each do |user|  
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

		 			@issues = Issue.find(:all, :include => [ :priority ], :conditions => ["assigned_to_id = ? AND ((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?) OR (start_date <= ? AND due_date >= ?))", user.id, weekBegin, weekEnd, weekBegin, weekEnd, weekBegin, weekEnd]).select { |i| i.project.active? }

					# ESTIMATED HOURS
	 				@estimated = 0
	 				@issues.each do |issue| 
		 				
		 				if issue.due_date.blank? || issue.start_date.blank? || issue.estimated_hours.blank?
							@estimated += 0
		 				else

		 					@workDaysTotal = working_days(issue.start_date, issue.due_date)
		 					issue['multiplierHours'] = issue.estimated_hours / (@workDaysTotal + 1)
	
		 					### DECIDE WHETHER WE ARE IN A "START", "MIDDLE" OR "END" WEEK
							if(issue.start_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['multiplierDays'] = (issue.start_date.end_of_week.to_date - (issue.start_date.to_date + 1 )).to_i
							end
	
							if(issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['multiplierDays'] = issue.estimated_hours / (issue.due_date.to_date - issue.start_date.to_date) + 1
							end
						
							if (issue.start_date.strftime("%U").to_i + 1) != week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) != week[0].to_i
								issue['multiplierDays'] = 5 * issue['multiplierHours']
							end
	
							@estimated += (issue['multiplierDays'] * issue['multiplierHours']).round(2)
			 				
			 			end
	 				end
	 				user["estimatedHours_#{calWeek}"] = @estimated	 				
	  			end
			end
		else
			# NOT LOGGED IN
		end
	end
end
