require 'redmine'
require_dependency 'issue'

module IssuePatch
	def self.included(base) # :nodoc:
		base.send(:include, InstanceMethods)
		base.class_eval do
			unloadable
			# ALLOW editor_id to be saved ... HOW SIMPLE IS THAT, EY?
			safe_attributes 'editor_id'
		end 
	end
	
	module InstanceMethods
		# Returns the users that should be notified
		def notified_users
			notified = []
			# Author and assignee are always notified unless they have been
			# locked or don't want to be notified
			notified << author if author
			notified << editor_id if editor_id
			if assigned_to
			  notified += (assigned_to.is_a?(Group) ? assigned_to.users : [assigned_to])
			end
			if assigned_to_was
			  notified += (assigned_to_was.is_a?(Group) ? assigned_to_was.users : [assigned_to_was])
			end
			notified = notified.select {|u| u.active? && u.notify_about?(self)}
			
			notified += project.notified_users
			notified.uniq!
			# Remove users that can not view the issue
			notified.reject! {|user| !visible?(user)}
			notified
		end
	end	
	
end

# Add module to Issue
Issue.send(:include, IssuePatch)
