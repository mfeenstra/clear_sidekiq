#!/usr/bin/env ruby
require_relative "#{ENV['HOME']}/RAILS_ROOT/config/application.rb"
require 'sidekiq'

include Sidekiq::Worker

Sidekiq::Queue.all.each(&:inspect)
Sidekiq::Queue.all.each(&:clear)
Sidekiq::RetrySet.new.clear
Sidekiq::ScheduledSet.new.clear
Sidekiq::DeadSet.new.clear

# reset processed jobs:
Sidekiq.redis {|c| c.del('stat:processed') }

# To reset failed jobs:
Sidekiq.redis {|c| c.del('stat:failed') }

# To reset statistics:
Sidekiq::Stats.new.reset
