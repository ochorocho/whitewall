module Whitewall
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_before_save(context={ })
      # set my_attribute on the issue to a default value if not set explictly
      context[:issue].my_attribute ||= "default"       
      
    end
  end
end
