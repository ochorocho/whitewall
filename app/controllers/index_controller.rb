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


			@test = @toDate
	
			# CALC WEEKS TO SHOW
			@weeksToShow = @toWeek - @fromWeek
	
			# BUILD WEEKS-TO-SHOW ARRAY
			@weeks = []
			@weeksToShow.times do |x|
				@weeks << (x + @fromWeek)
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
	 				wkBegin = Date.commercial(2014, week, 1)
	 				wkEnd = Date.commercial(2014, week, 7)
	 				user["week#{week}"] = Issue.where(:assigned_to_id => user.id, :start_date => wkBegin..wkEnd).select { |i| i.project.active? }
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