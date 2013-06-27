require 'observer'

module Caser
  class Action
    include Observable

    def initialize(*params)
      @_success_cb = @_failure_cb = nil
      yield self if block_given?
      after_initialize(*params)
    end

    def process
      processed!
      do_process
      success? ? succeed! : fail!
      self
    end

    def succeed!
      @_success_cb.call(self) if @_success_cb
    end

    def fail!
      @_failure_cb.call(self) if @_failure_cb
    end

    def processed!
      @_processed = true
    end

    def processed?
      @_processed
    end

    def success?
      processed? && errors.empty?
    end

    def errors
      @_errors ||= []
    end

    def emit(event)
      changed
      notify_observers(event)
    end

    def success(&cb)
      @_success_cb = cb
    end

    def failure(&cb)
      @_failure_cb = cb
    end
  end
end
