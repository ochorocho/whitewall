# Patches to the Redmine core. Will not work in development mode
require 'redmine'

require "users_patch"
require "issue_patch"

require_dependency 'issue_helper_patch'

Redmine::Plugin.register :whitewall do
  name 'Whitewall plugin'
  author 'Jochen Roth'
  description 'Organize HR by week'
  version '0.0.1'
  url 'https://github.com/ochorocho/whitewall'
  author_url 'http://dokuwiki.knallimall.org/'

  #  INCLUDE TO TOP MENU
  menu :top_menu, :whitewall, { :controller => 'index', :action => 'index'}, :caption => :label_whitewall_menu, :if => Proc.new {
    # Allow access to top_menu item based on allowed user groups
    @subjects = Setting.plugin_whitewall["whitewall_group"]
    @groupS = []

    # Make sure 'whitewall_group' is present before loop
    if Setting.plugin_whitewall["whitewall_group"].present?
      @subjects.each.with_index(1) do |subject, index|
        @groupS << subject[0]
      end
    end
    User.current.groups.where(id: @groupS).present?
  }, :last => false
  settings :default => {'empty' => true}, :partial => 'settings/whitewall'



end

IssuesHelper.send :include, IssueweekHelper

# EXTEND CORE MODEL - REQUIRE SOME STUFF FOR NO REASON ?!
require 'redmine'
require 'user'

require 'application_helper'

# BRING EM IN! -- THIS PICKY BITCH WANTS TO BE REQUIRED TO WORK! - NO AUTO-MAGIC
require 'whitewall/hooks/view_layouts_base_html_head_hook'

# VIEW HOOKS
require 'whitewall/hooks/view_issues_show_details_bottom'
require 'whitewall/hooks/view_issues_context_menu_end'
require 'whitewall/hooks/view_issues_bulk_edit_details_bottom'

require 'whitewall/hooks/view_issues_form_details_bottom'
