# Spree Store Credits

[![Build
Status](https://secure.travis-ci.org/spree/spree_store_credits.png)](http://travis-ci.org/spree/spree_store_credits)


This Spree extension allows admins to issue arbitrary amounts of store credit to users.

Users can redeem store credit during checkout, as part or full payment for an order.

Also extends My Account page to display outstanding credit balance, and orders that used store credit.

## Installation

### Include the following line in your Gemfile in your rails application with Spree installed:
  * Get the latest greatest from master: 
    
      ```ruby
        gem 'spree_store_credits' , :git => 'git://github.com/spree/spree_store_credits.git'
      ```

  * Get the 1-3-stable branch for Spree 1.3.x from github: 
    
      ```ruby
        gem 'spree_store_credits' , :git => 'git://github.com/spree/spree_store_credits.git', :branch => '1-3-stable'
      ```

  * Or get it from rubygems.org by mentioning the following line in your Gemfile:
    
      ```ruby 
        gem 'spree_store_credits'
      ```

### Then run the following commands in terminal: 

    $ bundle install
    $ rails g spree_store_credits:install 
    $ rake db:migrate
    $ rails s

## Example and usages

* In your rails console:
  ```ruby
    # Find any user in your database:
    user = Spree::User.first

    # Check if user has store credit(s)?
    user.store_credits

    # Check if they have any active store credit(s)
    user.store_credits.active
  ```

A store credit is active only when:

1. Remaining amount( **:remaining_amount** ) is more than 0.
2. Expiry is either nil, or a future date.

## Overriding configuration and preferences

You can use put this at the bottom of your **application's app/config/initializers/spree.rb**:
    
  ```ruby
    Spree::StoreCredit.config do |config|
      #  Default minimum store credit minimum applicable on order
      config.use_store_credit_minimum = 20 # Default is 30
      # Just in case you need to show your users a different label, like: 'Wallet'
      config.user_default_reason = "My Store Wallet" # Default is 'Store Credit'
      # If you want to have unique store credits for customers
      config.unique_store_credits_per_user = true # Default is false
      # if Store Credit Type is mendatory
      config.store_credit_type_required = true
    end
  ```

## Testing

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

## TODOs

* Improve testing and write more test cases.

## Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo) the project
2. Make one or more well commented and clean commits to the repository. You can make a new branch here if you are modifying more than one part or feature.
3. Add tests for it. This is important so I don’t break it in a future version unintentionally.
4. Perform a [pull request](https://help.github.com/articles/using-pull-requests) in github's web interface.

## License

Read LICENSE for more information.