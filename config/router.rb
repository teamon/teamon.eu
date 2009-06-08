Merb.logger.info("Compiling routes...")
Merb::Router.prepare do

  # Change this for your home page to be available at /
  match('/:action').to(:controller => 'default')
  match('/').to(:controller => 'default', :action =>'index')
end