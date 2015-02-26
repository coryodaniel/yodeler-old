Yodeler
=======

Spouting noise to whoever is listening.

Yodeler is an easy way to notify users of different events that occur in your app.

  * Notify your marketing team on the 10,000 sign-up.
  * Notify user's when their profile has been viewed
  * Notify your dev team about events that are not quite exception worthy, but you don't want to dig through a bunch of logs to find.


Features
========

  * store notifications via ActiveRecord
  * benchmark event duration
  * i18n support  
  * flexible payloads


What's wrong with XMPP?
=======================

  Why don't you fly to Walmart on a rocket?

  Don't even say it's because you don't have a rocket.

  Why don't you kill ants with a bazooka?

  Nevermind, you get it.


Usage
=====

```ruby
# in config/initializers/yodeler.rb
Yodeler.register :another_thousand_users

Yodeler.register :view_user do
  # Default states are unread: 0, read: 1
  config.states = {
    unread:    0,
    read:      1,
    ignored:   2
  }
end
```

```ruby
# in a controller or Anywhere you want to hear some noise
class UserController < ApplicationController
  around_action :track_user_view, only: :show
  
  def show
    # do your User#show as normal
  end

  private

  def track_user_view
    # This will also benchmark the action since it is in a block
    Yodeler.dispatch :view_user, {viewer_id: 3, viewee_id: 23} do |payload|
      yield #yield the action dispatch, the payload is available
    end
  end
end
```

```ruby
# off in some scorned rails-observer
class UserObserver
  observers :user

  def after_create
    # let the marketing know another thousandth user has registered!
    if (User.count % 1000).zero?
      Yodeler.dispatch :another_thousand_users, {give_him_a_prize: @user.id}
    end
  end
end
```


Getting around the objects
==========================

```ruby
@event.subscriptions #=> Array<Yodeler::Subscription> all subscriber subscriptions
@event.notifications #=> Array<Yodeler::Notifications>

@notification.subscriber #=> Your 'subscriber' class, delegated to #subscription
@notification.subscription.subscriber
@notification.event #=> The subscriber to event, delegated to #subscription
@notification.message #=> i18n message interpolated w/ the payload

@subscription.subscriber #=> the 'subscriber' subscribed to this event
@subscription.notifications #=> all notifications of this event type for this subscriber
@subscription.event

```

TODO
=======
* Pluggable back-end, redis, obvi