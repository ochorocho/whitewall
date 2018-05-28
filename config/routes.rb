# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'whitewall', :controller => 'index', :action => 'index'
get 'whitewall/ajax/norelation', :controller => 'norelation', :action => 'index'
get 'whitewall/graph', :controller => 'graph', :action => 'index'
post 'whitewall/user/settings', :controller => 'user_settings', :action => 'save'
# get 'whitewall_graph', :controller => 'projects', :action => 'index'
# get 'whitewall_overall', :controller => 'overall', :action => 'index'
# get 'whitewall_timespan', :controller => 'overall', :action => 'timespan'
# get 'whitewall_allgraph', :controller => 'overall', :action => 'allgraph'