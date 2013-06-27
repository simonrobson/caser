module Caser
  class Action

    def initialize(*params)
      after_initialize(*params)
    end

    def process
      processed!
      do_process
      success? ? succeed! : fail!
      self
    end

    def succeed!
      self.on_success if self.respond_to?(:on_success)
    end

    def fail!
      self.on_fail if self.respond_to?(:on_fail)
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
  end
end
