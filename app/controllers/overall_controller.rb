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
					
			# CHECK PARAMS
			if !params[:from].nil?
				@fromDate = Date.parse(params[:from])
				@fromInput = Date.parse(params[:from])
			else
				@fromDate = Date.today - 4.weeks
				@fromInput = Date.parse("#{Date.today}") - 4.weeks
			end
			if !params[:to].nil?
				@toDate = Date.parse(params[:to])
				@toInput = Date.parse(params[:to])
			else
				@toDate = Date.today
				@toInput = Date.today
			end
						      
      @projectsAll = Project.find(:all, :order => "name asc")
      
      if !params[:project_select].nil?
        @projectsSelect = params[:project_select]
        @projects = Project.find(:all, :order => "name asc", :conditions => ["projects.id IN (?)", @projectsSelect])
      else
        @projects = Project.find(:all, :order => "name asc")
      end
			
			# TICKETS PER TRACKER
			@trackers = Tracker.find(:all)
      
			@chartLines = []
			@trackers.each do | tracker |
        @chartLines << tracker.name
			  @fromDate.upto(@toDate) { |date|
          tracker["issues#{date}"] = Issue.find(:all, :include => [ :priority ], :conditions => ["tracker_id = ? AND (created_on < ?) AND project_id IN (?)", tracker.id, date.end_of_day, @projects]).count
        }
			end			

      # TICKETS VS COMMENTS	| BUGS
      @issues = []
      @journals = []
      @bugsTotal = []
      @bugsClosed = []
      @bugsOpen = []

      # BY SYSTEM
      @system = IssueCustomField.find(Setting.plugin_whitewall["whitewall_ticketSystem"]).possible_values
      @chart = []

                
      @issuesAll = Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?)", @toDate.end_of_day, @projects]) 
      @fromDate.upto(@toDate) { |date|
        @issues << Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?)", date.end_of_day, @projects]).count
        @journals << Journal.find(:all, :conditions => ["created_on < ? AND (notes IS NOT NULL AND notes != '') AND journalized_id IN (?)", date.end_of_day, @issuesAll]).count
        @bugsTotal << Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?) AND tracker_id IN (?)", date.end_of_day, @projects, [1,2]]).count
        @bugsClosed << Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND (closed_on IS NULL) AND project_id IN (?) AND tracker_id IN (?)", date.end_of_day, @projects, [1,2]]).count
        @bugsOpen <<  Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND (closed_on IS NOT NULL AND closed_on != '') AND project_id IN (?) AND tracker_id IN (?)", date.end_of_day, @projects, [1,2]]).count

          @issuesCustom = Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?)", date.end_of_day, @projects])
          @count = 0
          @issuesCustom.each do |custom|
            #LOOP THROUGH SYSTEMS
            @system.each do |system|
              chart = CustomValue.find(:all, :conditions => ["customized_id = (?) AND value = (?)", custom.id, system]).count
              @systemVar = system.camelize.gsub(' ', '')
              systemVar = system.camelize.gsub(' ', '')
              if !chart.nil?
                custom["system#{systemVar}"] = @count + chart
              end
            end
          end  
        }      
      
		else
			# NOT LOGGED IN
		end
	end
end
