class IndexController < ApplicationController
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
				@fromDate = Date.parse(params[:from]).beginning_of_week + 4.days
			else
				@fromDate = Date.today.beginning_of_week + 4.days
			end
			if !params[:to].nil?
				@toDate = Date.parse(params[:to]).beginning_of_week + 4.days
			else
				@toDate = (Date.today.beginning_of_week + 4.days) + 4.weeks
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
			@test = []
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

	 				@test << weekBegin
					user["week#{calWeek}year#{calYear}"] = Issue.where(:assigned_to_id => user.id, :start_date => weekBegin..weekEnd).select { |i| i.project.active? }
	  			end
			end
		else
			
		end
	end

# 	def check_for_group
# 
# 		@usersGroup = User.current.groups.all
# 		@usersGroup.each do |group|
# 
# 			@settings = Setting.plugin_whitewall["whitewall_group"]
# 			if @settings.nil?
# 				@UserAllowed = 'false'
# 			else
# 				@settings = Setting.plugin_whitewall["whitewall_group"]["#{group.id}"]
# 				if @settings.blank?
# 					@UserAllowed = 'false'
# 				else 
# 					@UserAllowed = 'true'
# 				end
# 			end			
# 		end
# 
# 		if @UserAllowed == 'true'
# 	      return true
# 	    else
# 	      return false
# 	    end
# 	end

end