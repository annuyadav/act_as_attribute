# Act As Attribute

Gem for making getter, setter method for a model from its association.

## Installation

Add to `Gemfile` run `bundle install`:

```ruby
# Gemfile
gem 'act_as_attribute'
```

# Usage

if we are having two models user and book. In user we have declare:

```ruby
class User < ActiveRecord::Base
  AVAILABLE_ATTRIBUTES = ["english", "hindi", "social", "science", "math"]
  ACCEPTANCE_LEVEL = "error"
  has_many :books
  act_as_attribute :books, "name", "description"
end
```

and the book.rb is something like this:
```ruby
class Book < ActiveRecord::Base
  belongs_to :user
end
```

Now every user object will have a getter and setter method for 'name' attribute of book object and the value for it will be the 'description' attribute.
These methods are created only if they are present in the array 'AVAILABLE_ATTRIBUTES' which is defined in the model as above.
and the 'ACCEPTANCE_LEVEL' indicates how to deal if model is already having the same attribute as of method. If it is defined as 'error' then it will raise an exception otherwise it will just give a warning before creating.




