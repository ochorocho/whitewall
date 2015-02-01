module Whitewall
	module Hooks
		class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener
			render_on(:view_issues_show_details_bottom, :partial => 'hooks/whitewall/view_issues_show_details_bottom')
		end
	end
end