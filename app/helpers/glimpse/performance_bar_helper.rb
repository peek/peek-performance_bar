module Glimpse
  module PerformanceBarHelper
    def render_server_response_time
      if start_time = request.env['process.request_start']
        time = "%.5f" % (Time.now - start_time)
        "<span id='glimpse-server_response_time' data-time='#{time}'></span>".html_safe
      end
    end
  end
end
