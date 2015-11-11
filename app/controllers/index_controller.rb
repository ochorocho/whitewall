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

			@issuesUndefined = Issue.find(:all, :conditions => ["status_id NOT IN (?) AND (editor_id IS NULL OR start_date IS NULL OR due_date IS NULL)", [5,6]])
					
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
				weeks << [@fromDate.cweek, @fromDate.year, Date.parse("#{@fromDate}").to_s(:short_date)]
				@fromDate += 1.week
			end
			
			@weeks = []
			weeks.each do |w,y,today|
				date = []
				year = Date.parse("#{today}").year
				7.times do |day|
					day = day + 1
					date << Date.parse("#{today}")
				end
				@weeks << [w,year,date]
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
	 					 				
 					calYear = week[1].to_i
 					calWeek = week[0].to_i
 					calToday = week[2][0]
	 					 				
	 				weekBegin = calToday.beginning_of_week
	 				weekEnd = calToday.end_of_week
	 					 				
	 				user["week#{calWeek}year#{calYear}"] = Issue.find(:all, :include => [ :priority ], :conditions => ["editor_id = ? AND ((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?) OR (start_date <= ? AND due_date >= ?))", user.id, weekBegin, weekEnd, weekBegin, weekEnd, weekBegin, weekEnd]).select { |i| i.project.active? }
	 				
	 				user["week#{calWeek}year#{calYear}"].each do |issue|


						issue['showHours'] = 0
						
						issue['no_children'] = issue.children.count



		 				if issue.due_date.blank? || issue.start_date.blank? || issue.estimated_hours.blank?
			 				issue['hoursToServe'] = '0'
		 				else
							
							if issue.due_date.sunday?
								issue.due_date = issue.due_date - 2.days
							end
							if issue.due_date.saturday?
								issue.due_date = issue.due_date - 1.days
							end

		 					if issue.start_date < Date.today && issue.due_date > Date.today
		 						@dayRest = Date.today
		 					else
		 						@dayRest = issue.start_date
		 					end 
		 					
		 					# TODO: Wenn Startdatum über aktuellem Datum
		 					# TODO: Feiertage ermitteln und auslassen (was macht working_days)
		 					@workDaysTotal = (working_days(@dayRest, issue.due_date) + 1) ### + 1 Für richtiges Ergebnis
		 					issue['daysTotal'] = @workDaysTotal
		 					issue['hourPerDay'] = ((issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)) / @workDaysTotal).round(2)

							# START WEEK						
							if(@dayRest.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "BEGINNING WEEK"
								issue['hourPerWeek'] = (issue['hourPerDay'] * (@dayRest.end_of_week.to_date - (@dayRest.to_date + 1)).to_f)
							end

							# END WEEK
							if(issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "ENDING WEEK"
								issue['hourPerWeek'] =  (issue['hourPerDay'] * ((issue.due_date.to_date + 1) - issue.due_date.beginning_of_week.to_date).to_f)
							end

							# START / STOP IN SAME WEEK
							if(@dayRest.strftime("%U").to_i + 1) == week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) == week[0].to_i
								issue['whereAmI'] = "START STOP IN SAME WEEK"
								issue['hourPerWeek'] = (issue.estimated_hours - (issue.estimated_hours * issue.done_ratio / 100)).to_f
							end

							# NEITHER START NOR STOP DATE - FULL WEEK!
							if (@dayRest.strftime("%U").to_i + 1) != week[0].to_i && (issue.due_date.strftime("%U").to_i + 1) != week[0].to_i
								issue['whereAmI'] = "MIDDLE WEEK - WEEK IS A I AM"
								issue['hourPerWeek'] = issue['hourPerDay'] * 5
							end
							
							# WEEK IS IN THE PAST
							if(Date.today.strftime("%U").to_i + 1) <= week[0].to_i
								issue['showHours'] = 1
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