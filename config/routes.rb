ActionController::Routing::Routes.draw do |map|
  map.print '/:username', :controller => 'prints', :action => 'show'
end
