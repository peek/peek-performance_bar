require 'rack/process_utilization'

module Glimpse
  module PerformanceBar
    class Railtie < ::Rails::Engine
      initializer 'glimpse.performance_bar.mount_process_utilization' do |app|
        app.config.middleware.use Rack::ProcessUtilization
      end
    end
  end
end
