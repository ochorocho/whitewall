require 'redmine'
require_dependency 'issue'

module IssuePatch
	def self.included(base) # :nodoc:
		base.class_eval do
			unloadable
			# ALLOW editor_id to be saved ... HOW SIMPLE IS THAT, EY?
			safe_attributes 'editor_id'
		end 
	end
end

# Add module to Issue
Issue.send(:include, IssuePatch)
