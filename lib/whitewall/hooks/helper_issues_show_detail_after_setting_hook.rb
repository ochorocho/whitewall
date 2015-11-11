module Whitewall
  module Hooks
    class HelperIssuesShowDetailAfterSettingHook < Redmine::Hook::ViewListener

      def helper_issues_show_detail_after_setting(context = { })

        if context[:detail].prop_key == 'editor_id'
          context[:detail].reload
                    
          # SET EDITOR TO VALUE
          userid = context[:detail].value
          
          if userid.nil?
			  Rails.logger.info ">>> VALUE IS NIL <<<"
	          d = User.find(0)
	          context[:detail].value = d.firstname + ' ' + d.lastname
		  else
			  Rails.logger.info ">>> VALUE #{context[:detail].value}"
	          d = User.find(userid)
	          context[:detail].value = d.firstname + ' ' + d.lastname
		  end

          # SET EDITOR FROM VALUE (old value)
		  userid = context[:detail].old_value

          if userid.nil?
			  Rails.logger.info ">>> VALUE IS NIL <<<"
	          d = User.find(0)
	          context[:detail].old_value = d.firstname + ' ' + d.lastname
	      else
			  Rails.logger.info ">>> VALUE #{context[:detail].old_value}"
	          d = User.find(userid)
	          context[:detail].old_value = d.firstname + ' ' + d.lastname
	      end

        end
        ''
      end
      
    end
  end
end
