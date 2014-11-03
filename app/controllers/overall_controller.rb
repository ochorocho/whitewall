class OverallController < ApplicationController
  unloadable

	include Redmine::Utils::DateCalculation

  def allgraph
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
      
      # TICKETS PER SYSTEM
      @classifyId = Setting.plugin_whitewall["whitewall_classification"]
    end

    render :layout => false    
  end

  def timespan
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

      # TICKETS PER SYSTEM
      @systemId = Setting.plugin_whitewall["whitewall_ticketSystem"]
      @system = IssueCustomField.find(@systemId).possible_values.to_a
      @chartLinesSystem = @system.to_s        
      
      @systemAll = []
      @system.each do |system|
        @custom = []
        @fromDate.upto(@toDate) { |date|
          today = Issue.find(:all, :conditions => ["created_on < ? AND project_id IN (?)", date.end_of_day, @projects])
          @value = CustomValue.where('value = ? and customized_id IN (?)', system, today).all
          @custom << @value.count
        } 
        @systemAll << @custom
      end
        
      # TICKETS VS COMMENTS | BUGS
      @issues = []
      @journals = []
      @bugsTotal = []
      @bugsClosed = []
      @bugsOpen = []

      # BY SYSTEM
      @chart = []

      @issuesAll = Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?)", @toDate.end_of_day, @projects]) 
      @fromDate.upto(@toDate) { |date|
        @issues << Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?)", date.end_of_day, @projects]).count
        @journals << Journal.find(:all, :conditions => ["created_on < ? AND (notes IS NOT NULL AND notes != '') AND journalized_id IN (?)", date.end_of_day, @issuesAll]).count
        @bugsTotal << Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND project_id IN (?) AND tracker_id IN (?)", date.end_of_day, @projects, [1,2]]).count
        @bugsClosed << Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND (closed_on IS NULL) AND project_id IN (?) AND tracker_id IN (?)", date.end_of_day, @projects, [1,2]]).count
        @bugsOpen <<  Issue.find(:all, :order => "created_on ASC", :conditions => ["created_on < ? AND (closed_on IS NOT NULL AND closed_on != '') AND project_id IN (?) AND tracker_id IN (?)", date.end_of_day, @projects, [1,2]]).count
      }     
      render :layout => false              
    else
      # NOT LOGGED IN
    end
  end
	def index

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
					              
		else
			# NOT LOGGED IN
		end
	end
end
