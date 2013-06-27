require 'minitest/autorun'
require 'caser'

describe Caser::Action do

  describe 'A basic action' do
    class BasicAction < Caser::Action
      attr_accessor :will_fail
      def after_initialize(will_fail = false)
        @will_fail = will_fail
      end
      
      def do_process
        errors << "It failed" if will_fail?
      end

      def will_fail?
        will_fail
      end
    end

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
