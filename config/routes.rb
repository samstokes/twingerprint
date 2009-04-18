ActionController::Routing::Routes.draw do |map|
  map.resources :prints

  map.print '/:username', :controller => 'prints', :action => 'show'

  map.root :controller => 'prints', :action => 'new'
end
