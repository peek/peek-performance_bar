require 'peek/views/performance_bar/process_utilization'

module Peek
  module PerformanceBar
    class Railtie < ::Rails::Engine
      initializer 'peek.performance_bar.mount_process_utilization' do |app|
        app.config.middleware.use Peek::Views::PerformanceBar::ProcessUtilization
      end
    end
  end
end
