require 'observer'

module Caser
  class Action
    include Observable

    attr_reader :outcome
    def initialize(*params)
      @_callbacks = nil
      @outcome = nil
      yield @_callbacks = Callbacks.new if block_given?
      after_initialize(*params)
    end

    def process
      processed!
      do_process
      success? ? succeed! : fail!
      self
    end

    def succeed!
      @_callbacks.on_success(self) if @_callbacks
    end

    def fail!
      @_callbacks.on_failure(self) if @_callbacks
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

    def set_outcome(outcome)
      @outcome = outcome
    end
  end
end
