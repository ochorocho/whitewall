class GraphController < ApplicationController
  unloadable

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
				@users = User.find(:all, :joins => :issues, :order => "login asc", :include => [:issues], :conditions => ["users.id IN (?) AND users.id NOT IN (?) AND users.status NOT IN (?)", @userSelect, [2], [3]])
			else
				@users = User.find(:all, :joins => :issues, :order => "login asc", :conditions => ["users.id NOT IN (?) AND users.status NOT IN (?) AND groups_users.id IN (?)", [2], [3], @groupIds])
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

# 	 				user["estimatedHours_#{calWeek}"] = @estimated
# 	 				user["issueCount_#{calWeek}"] = @issues.count
# 	 				user["issueDaysInWeek_#{calWeek}"] = @issueDaysInWeek
	 				
	  			end
			end
		else
			# ELSE	
		end
	end
end
