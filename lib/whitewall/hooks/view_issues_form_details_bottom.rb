module Whitewall
	module Hooks
		class ViewIssuesFormDetailsBottomHook < Redmine::Hook::ViewListener
			render_on(:view_issues_form_details_bottom, :partial => 'hooks/whitewall/view_issues_form_details_bottom')
		end
	end
end