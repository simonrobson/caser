# Caser

This gem is an extraction of a pattern that I've evolved in a few recent web apps to find a home for our business logic between the controller and the persistence layer.

It's somewhat inspired by the ideas in Hexagonal Architecture and Bob Martin's talks on structuring web applications. But it is very light and simple.

I've found it gives me an easy way out of the world of Rails (or your framework of choice) and into pure application code for many common cases once CRUD moves beyond simple single model updates. It tends to make business logic easily testable in isolation and usable from scripts and the console.

## Installation

Add this line to your application's Gemfile:

    gem 'caser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install caser

## Usage

To create a basic use case, extend Caser::Action and implement after_initialize (any arity you like) and do_process:

    class Api::CreateContact < Caser::Action
      attr_accessor :user, params
      def after_initialize
        @user, @params = current_user, params
      end

      def do_process
        if valid?(params)
          contact = SecretSauce::CreateContact(params)
          set_outcome(contact)
        end
      end
      
      def valid?(params)
        unless :whatever
          errors << "No, we're not going to do that"
          return false
        end
        true
      end


Here is typical usage in a controller:

    def create
      update = Api::CreateContact.new(current_user, params[:contact]).process
      if update.success?
        ... code for success response (update.outcome contains any result object from the use case)
      else
        ... code for failure response (update.errors contains and array of errors)
      end
    end

These use cases also support call-back style usage:

    def create
      Api::CreateContact.new(current_user, params[:contact]) do |on|
        on.success {|action| ... code for success case}
        on.failure {|action| ... code for failure case}
      end.process
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
