module Caser
  class Callbacks
    def initialize
      @_success_cb = @_failure_cb = nil
    end

    def on_success(*args)
      return unless @_success_cb
      @_success_cb.call(*args)
    end

    def on_failure(*args)
      return unless @_failure_cb
      @_failure_cb.call(*args)
    end

    def success(&cb)
      @_success_cb = cb
    end

    def failure(&cb)
      @_failure_cb = cb
    end
  end
end
