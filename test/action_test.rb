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

    it 'reports failure' do
      @action = BasicAction.new(true)
      @action.process
      @action.success?.must_equal false
    end

    it 'gives access to errors in failure case' do
      @action = BasicAction.new(true)
      @action.process
      @action.errors.length.must_equal 1
    end
  end

end
