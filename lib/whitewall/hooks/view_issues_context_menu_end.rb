module Whitewall
	module Hooks
		
		class ViewIssuesContextMenuEnd < Redmine::Hook::ViewListener
			render_on(:view_issues_context_menu_end, :partial => 'hooks/whitewall/view_issues_context_menu_end')
		end
	end
end