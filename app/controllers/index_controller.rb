class IndexController < ApplicationController
  unloadable
	
	include Redmine::Utils::DateCalculation
	
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

			@issuesUndefined = Issue.where("editor_id IS NULL OR start_date IS NULL").all
					
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
			@hideUser << 2

			@usersAll = User.find(:all, :joins => :groups, :order => "login asc", :conditions => ["users.id NOT IN (?) AND users.status NOT IN (?)", @hideUser, [3]])
			
			if !params[:user_select].nil?
				@userSelect = params[:user_select]
				@userSelect << 2
				@users = User.find(:all, :joins => :groups, :order => "login asc", :conditions => ["users.id IN (?) AND users.id NOT IN (?) AND users.status NOT IN (?)", @userSelect, [2], [3]])
				
			else
				@users = User.find(:all, :joins => :groups, :order => "login asc", :conditions => ["users.id NOT IN (?) AND users.status NOT IN (?)", @hideUser, [3]])
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
	 				
	 				user["week#{calWeek}year#{calYear}"] = Issue.find(:all, :include => [ :priority ], :conditions => ["editor_id = ? AND parent_id IS NULL AND ((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?) OR (start_date <= ? AND due_date >= ?))", user.id, weekBegin, weekEnd, weekBegin, weekEnd, weekBegin, weekEnd]).select { |i| i.project.active? }
	 				
	 				user["week#{calWeek}year#{calYear}"].each do |issue|

		 				if issue.due_date.blank? || issue.start_date.blank? || issue.estimated_hours.blank?
			 				issue['hoursToServe'] = '0'							
		 				else

		 					@workDaysTotal = working_days(issue.start_date, issue.due_date)
		 					issue['multiplierHours'] = (issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)) / @workDaysTotal


### IF START DATE BEFORE TODAY
						if issue.start_date < Date.today && issue.due_date > Date.today
## TIME WAVE PUSHER
# CHECKED					# START WEEK						
							if(issue.start_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "BEGINNING WEEK - WAVE"
								issue['multiplierDays'] = (Date.today.end_of_week.to_date - (Date.today.to_date + 1 )).to_int
								issue['hoursToServe'] = issue['multiplierDays'] * issue['multiplierHours']
								# issue['hoursToServe'] = 666
							end

# CHECKED					# END WEEK
							if(issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "ENDING WEEK"
								issue['multiplierDays'] = (issue.due_date.to_date - (Date.today.beginning_of_week.to_date)).to_int
#								issue['hoursToServe'] = issue['multiplierDays'] * issue['multiplierHours']
								issue['hoursToServe'] = 666
							end

# CHECKED					# START / STOP IN SAME WEEK
							if(issue.start_date.strftime("%U").to_i + 1) == week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "START STOP IN SAME WEEK"
								issue['multiplierDays'] = "NOT REQUIRED IN THIS CASE"
								# SPECIAL CASE - CALC done_ratio within here
#								issue['hoursToServe'] = issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)
								issue['hoursToServe'] = 666
							end

# CHECKED					# NEITHER START NOR STOP DATE - FULL WEEK!
							if (issue.start_date.strftime("%U").to_i + 1) != week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) != week[0].to_i
								issue['whereAmI'] = "MIDDLE WEEK - WEEK IS A I AM"
								issue['multiplierDays'] = 5
#								issue['hoursToServe'] = issue['multiplierDays'] * issue['multiplierHours'] 
								issue['hoursToServe'] = 666
							end

						else

## IF START DATE IS IN THE FUTURE

# CHECKED					# START WEEK						
							if(issue.start_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "BEGINNING WEEK"
								issue['multiplierDays'] = (issue.start_date.end_of_week.to_date - (issue.start_date.to_date + 1 )).to_int
								issue['hoursToServe'] = issue['multiplierDays'] * issue['multiplierHours']
							end

# CHECKED					# END WEEK
							if(issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "ENDING WEEK"
								issue['multiplierDays'] = (issue.due_date.to_date - (issue.due_date.beginning_of_week.to_date)).to_int
								issue['hoursToServe'] = issue['multiplierDays'] * issue['multiplierHours']
							end

# CHECKED					# START / STOP IN SAME WEEK
							if(issue.start_date.strftime("%U").to_i + 1) == week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "START STOP IN SAME WEEK"
								issue['multiplierDays'] = "NOT REQUIRED IN THIS CASE"
								# SPECIAL CASE - CALC done_ratio within here
								issue['hoursToServe'] = issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)
							end

# CHECKED					# NEITHER START NOR STOP DATE - FULL WEEK!
							if (issue.start_date.strftime("%U").to_i + 1) != week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) != week[0].to_i
								issue['whereAmI'] = "MIDDLE WEEK - WEEK IS A I AM"
								issue['multiplierDays'] = 5
								issue['hoursToServe'] = issue['multiplierDays'] * issue['multiplierHours'] 
							end
		 				end
		 				end
	 				end	 				
	  			end
			end
		else
			# NOT LOGGED IN
		end
	end
end