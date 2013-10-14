require 'minitest/autorun'
require 'caser'

describe Caser::Action do
  class BasicAction < Caser::Action
    attr_accessor :will_fail, :eventual_outcome
    def after_initialize(will_fail = false, eventual_outcome = eventual_outcome)
      @will_fail = will_fail
      @eventual_outcome = eventual_outcome
    end

    def do_process
      errors << "It failed" if will_fail?
      set_outcome(eventual_outcome) if eventual_outcome
    end

    def will_fail?
      will_fail
    end
  end

  describe 'A basic action' do
    it 'results in success' do
      @action = BasicAction.new
      @action.process
      @action.success?.must_equal true
    end

    it 'returns self from process' do
      @action = BasicAction.new
      @action.process.must_be_same_as @action
    end

    it 'reports failure' do
      @action = BasicAction.new(true).process
      @action.success?.must_equal false
    end

    it 'gives access to errors in failure case' do
      @action = BasicAction.new(true).process
      @action.errors.length.must_equal 1
    end

    it 'provides an outcome accessor' do
      @outcome = Object.new
      @action = BasicAction.new(true, @outcome).process
      @action.outcome.must_equal @outcome
    end
  end

  describe 'callback style' do
    def setup
      @bug = Minitest::Mock.new
    end

    it 'calls back on success' do
      @bug.expect(:succeeded, true)
      @action = BasicAction.new do |on|
        on.success { @bug.succeeded }
        on.failure { @bug.failed }
      end
      @action.process
      @bug.verify
    end

    it 'passes the action instance to the callbacks' do
      @passed_in = nil 
      @action = BasicAction.new do |on|
        on.success { |a| @passed_in = a }
      end
      @action.process
      @passed_in.must_equal @action
    end

    it 'calls back on failure' do
      @bug.expect(:failed, true)
      BasicAction.new(true) do |on|
        on.success { @bug.succeeded }
        on.failure { @bug.failed }
      end.process
      @bug.verify
    end
  end

  describe 'observability' do
    class ObservedAction < Caser::Action
      def after_initialize
      end

      def do_process
        emit(:working)
      end
    end

    class Watcher
      def update(message)
        messages << message
      end

      def messages
        @messages ||= []
      end
    end

    it 'implements observable and provides and emit method to notify observers' do
      @action = ObservedAction.new
      @observer = Watcher.new
      @action.add_observer(@observer)
      @action.process
      @observer.messages.must_equal [:working]
    end
  end

end
