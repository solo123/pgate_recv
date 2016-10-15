require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :domain, 'rb@a.pooulcloud.cn'
set :deploy_to, '/home/rb/work/pgate_recv'
set :repository, 'git://github.com/solo123/pgate_recv'
set :branch, 'deploy'

task :environment do
  invoke :'rvm:use[ruby-2.3.1@default]'
end
# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :pull => :environment do
  queue  %[echo "-----> git pull"]
  queue  %[cd #{deploy_to}]
  queue! %{git checkout deploy}
  queue! %{git reset --hard}
  queue! %{git pull origin deploy}
  queue  %{rm config/puma.rb}
  queue  %{ln -s /home/rb/work/puma/pgate_recv.rb config/puma.rb}
  queue  %{mkdir -p tmp/sockets}
  queue  %{mkdir -p tmp/pids}
  queue! %{bundle install --without development test}

  queue  %[echo "-----> restart puma"]
  queue! %{pumactl --state tmp/pids/puma-production.state restart}

  queue %{echo "====== test after pull ======"}
  queue! %{curl -X POST -d 'app=pgate_recv' http://a.pooulcloud.cn:8010/notify/deploy}
end
