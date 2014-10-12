# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'whitewall', :controller => 'index', :action => 'index'
get 'whitewall_graph', :controller => 'graph', :action => 'index'
get 'whitewall_graph', :controller => 'projects', :action => 'index'
get 'whitewall_overall', :controller => 'overall', :action => 'index'