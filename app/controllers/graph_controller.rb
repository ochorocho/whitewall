class GraphController < ApplicationController
  unloadable

	def index
		require "date"

		@usersGroup = User.current.groups.all
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
				end
			end			
		end

		if @UserAllowed == 'true'

			@issuesUndefined = Issue.where("assigned_to_id IS NULL OR start_date IS NULL").all
					
			# CHECK PARAMS
			if !params[:from].nil?
				@fromDate = Date.parse(params[:from])
			else
				@fromDate = Date.today
			end
			if !params[:to].nil?
				@toDate = Date.parse(params[:to])
			else
				@toDate = Date.today + 4.weeks
			end
			
			# CONVERT GIVEN DATE TO WEEK
			@fromWeek = @fromDate.strftime("%U").to_i
			@toWeek = @toDate.strftime("%U").to_i

			start = Date.new( 2012, 5, 10 )
			ende = Date.new( 2013, 6, 20 )
			
			weeks = []
			while @fromDate < @toDate
				weeks << [@fromDate.cweek, @fromDate.year]  # <-- enhanced
				@fromDate += 1.week
			end
			
			@weeks = []
			weeks.each do |w,y|   # <-- take two arguments in the block
				@weeks << "#{w},#{y}"  #     and print them both out
			end

			@usersAll = User.find(:all, :order => "login asc", :conditions => ["id NOT IN (?)", [2]])
			
			if !params[:user_select].nil?
				@userSelect = params[:user_select]
				@userSelect << 2
				@users = User.find(:all, :order => "login asc", :conditions => ["id IN (?) AND id NOT IN (?)", @userSelect, [2]])
			else
				@users = User.find(:all, :order => "login asc", :conditions => ["id NOT IN (?)", [2]])
			end

	 		@users.each do |user|  
	 			@weeks.each do |week|
	 				if week.split(',')[0].to_f == '53'
	 					calYear = week.split(',')[1].to_i
	 					calWeek = week.split(',')[0].to_i
	 				else
	 					calYear = week.split(',')[1].to_i
	 					calWeek = week.split(',')[0].to_i
	 				end

	 				weekBegin = Date.commercial(calYear, calWeek, 1)
	 				weekEnd = Date.commercial(calYear, calWeek, 7)
	 				
	 				@dates = []
	 				7.times do |day|
	 					day = day + 1
	 					date = Date.commercial(calYear, calWeek, day)
		 				@dates << date

						# ISSUE COUNT
		 				@issues = Issue.where(:assigned_to_id => user.id, :start_date => date).select { |i| i.project.active? }
		 				user["issueCount_#{date}"] = @issues.count

						# ESTIMATED HOURS
		 				@estimated = 0
		 				@issues.each do |issue| 
			 				#@estimated = @estimated + issue.estimated_hours
		 				end
		 				user["estimatedHours_#{date}"] = @estimated
	 				end	 				
	  			end
			end
		else
			
		end
	end
end
