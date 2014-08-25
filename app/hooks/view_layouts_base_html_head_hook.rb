module RedmineWhitewall
  module Hooksadssadsadad #ä#######
  ----..,,
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
          tags << stylesheet_link_tag('application.css', :plugin => "whitewall")
      end
    end
  end
end