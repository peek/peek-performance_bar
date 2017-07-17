module Peek
  module Views
    class PerformanceBar
      # Middleware that tracks the amount of time this process spends processing
      # requests, as opposed to being idle waiting for a connection. Statistics
      # are dumped to rack.errors every 5 minutes.
      #
      # NOTE This middleware is not thread safe. It should only be used when
      # rack.multiprocess is true and rack.multithread is false.
      class ProcessUtilization
        class << self
          # The instance of this middleware in a single-threaded production server.
          # Useful for fetching stats about the current request:
          #
          #   o = Rack::ProcessUtilization.singleton
          #   time, calls = o.gc_stats if o.track_gc?
          attr_accessor :singleton
        end

        def initialize(app, opts={})
          @app = app
          @window = opts[:window] || 100
          @horizon = nil
          @requests = nil
          @active_time = nil
          @total_requests = 0

          self.class.singleton = self
        end

        # time when we began sampling. this is reset every once in a while so
        # averages don't skew over time.
        attr_accessor :horizon

        # total number of requests that have been processed by this worker since
        # the horizon time.
        attr_accessor :requests

        # decimal number of seconds the worker has been active within a request
        # since the horizon time.
        attr_accessor :active_time

        # total requests processed by this worker process since it started
        attr_accessor :total_requests

        # the amount of time since the horizon
        def horizon_time
          Time.now - horizon
        end

        # decimal number of seconds this process has been active since the horizon
        # time. This is the inverse of the active time.
        def idle_time
          horizon_time - active_time
        end

        # percentage of time this process has been active since the horizon time.
        def percentage_active
          (active_time / horizon_time) * 100
        end

        # percentage of time this process has been idle since the horizon time.
        def percentage_idle
          (idle_time / horizon_time) * 100
        end

        # number of requests processed per second since the horizon
        def requests_per_second
          requests / horizon_time
        end

        # average response time since the horizon in milliseconds
        def average_response_time
          (active_time / requests.to_f) * 1000
        end

        # called exactly once before the first request is processed by a worker
        def first_request
          reset_horizon
        end

        # reset various counters before the new request
        def reset_stats
          @start = Time.now
        end

        # resets the horizon and all dependent variables
        def reset_horizon
          @horizon = Time.now
          @active_time = 0.0
          @requests = 0
        end

        # called immediately after a request to record statistics, update the
        # procline, and dump information to the logfile
        def record_request
          now = Time.now
          diff = (now - @start)
          @active_time += diff
          @requests += 1

          reset_horizon if now - horizon > @window
        rescue => boom
          warn "ProcessUtilization#record_request failed: #{boom.inspect}"
        end

        # Rack entry point.
        def call(env)
          @env = env
          reset_stats

          @total_requests += 1
          first_request if @total_requests == 1

          env['process.request_start'] = @start.to_f
          env['process.total_requests'] = total_requests

          status, headers, body = @app.call(env)
          body = Rack::BodyProxy.new(body) { record_request }
          [status, headers, body]
        end
      end
    end
  end
end
