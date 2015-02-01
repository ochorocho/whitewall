module Whitewall
	module Hooks
		class ViewIssuesBulkEditDetailsBottom < Redmine::Hook::ViewListener
			render_on(:view_issues_bulk_edit_details_bottom, :partial => 'hooks/whitewall/view_issues_bulk_edit_details_bottom')
		end
	end
end