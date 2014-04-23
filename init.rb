Redmine::Plugin.register :whitewall do
  name 'Whitewall plugin'
  author 'Jochen Roth'
  description 'Organize HR by week'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  #  INCLUDE TO TOP MENU
  menu :top_menu, :whitewall, { :controller => 'index', :action => 'index'}, :caption => :label_whitewall_menu, :if => Proc.new { User.current.logged? }
  settings :default => {'empty' => true}, :partial => 'settings/whitewall'
  
end

# BRING EM IN! -- THIS PICKY BITCH WANTS TO BE REQUIRED TO WORK! - NO AUTO-MAGIC
require 'whitewall/hooks/view_layouts_base_html_head_hook'