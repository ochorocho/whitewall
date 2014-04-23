# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

#get 'whitewall', :to => 'whitewall#index'

get 'whitewall', :controller => 'index', :action => 'index'
get 'whitewall_graph', :controller => 'graph', :action => 'index'