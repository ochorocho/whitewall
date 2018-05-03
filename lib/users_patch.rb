require 'redmine'
require_dependency 'issue'

module WallUsersHelperPatch
	def self.included(base) # :nodoc:
		base.send(:include, InstanceMethods)

		base.class_eval do
			alias_method_chain :user_settings_tabs, :wall_tab
		end
	end

	module InstanceMethods
		# Add wall tab
		def user_settings_tabs_with_wall_tab
			tabs = user_settings_tabs_without_wall_tab
			tabs << {:name => 'wall', :partial => 'users/wall', :label => :label_whitewall}
			return tabs
		end
	end
end

# Add module to Issue
UsersHelper.send(:include, WallUsersHelperPatch)
