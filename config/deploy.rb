set :application, "teamon.eu"

set :scm, :git
set :repository,  "git://github.com/teamon/teamon.eu.git"


set :deploy_to, "/home/teamon/rails_apps/#{application}"

set :use_sudo, false

role :app, "drakor.eu"
role :web, "drakor.eu"
role :db,  "drakor.eu", :primary => true

set :merb_adapter,     "thin"
set :merb_environment, ENV["MERB_ENV"] || "production"
set :merb_port,        3031
set :merb_servers,     1

namespace :deploy do
  desc "stops application server"
  task :stop do
    run "cd #{latest_release}; merb -K all"
  end
  
  desc "starts application server"
  task :start do
    run "cd #{latest_release}; merb -a #{merb_adapter} -p #{merb_port} -c #{merb_servers} -d -e #{merb_environment}"
    # Mutex of: -X off
  end
  
  desc "restarts application server(s)"
  task :restart do
    deploy.stop
    deploy.start
  end
end