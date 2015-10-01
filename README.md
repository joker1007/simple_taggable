# simple\_taggable
[![Gem Version](https://badge.fury.io/rb/simple_taggable.svg)](http://badge.fury.io/rb/simple_taggable)
[![Build Status](https://travis-ci.org/joker1007/simple_taggable.svg?branch=master)](https://travis-ci.org/joker1007/simple_taggable)
[![Coverage Status](https://coveralls.io/repos/joker1007/simple_taggable/badge.png)](https://coveralls.io/r/joker1007/simple_taggable)
[![Code Climate](https://codeclimate.com/github/joker1007/simple_taggable.png)](https://codeclimate.com/github/joker1007/simple_taggable)

This is Hyper simple tagging plugin for ActiveRecord.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_taggable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_taggable

## Usage

```
$ rails g simple_taggable:install
# generate migration files of Tag, Taggable class

$ rake db:migrate
```

```ruby
class User < ActiveRecord::Base
  include SimpleTaggable

  add_tag_filter    ->(tag_list, tag_name) { !tag_list.include?(tag_name) }
  add_tag_converter ->(_, tag_name) { tag_name.downcase }
end

user = User.new(name: "joker1007")
user.tag_list.add("Ruby")
user.tag_list << "CoffeeScript"
user.save!

# tagged_with scope
User.tagged_with("Ruby")                # eq [user]
User.tagged_with("Ruby", exclude: true) # eq []
User.tagged_with("CoffeeScript")        # eq [user]

User.tagged_with("Ruby", "CoffeeScript")                  # eq [user]
User.tagged_with("Ruby", "CoffeeScript", exclude: true)   # eq []
User.tagged_with("Ruby", "CoffeeScript", match_all: true) # eq [user]
User.tagged_with("Ruby", "JavaScript")                    # eq [user]
User.tagged_with("Ruby", "JavaScript", exclude: true)     # eq []
User.tagged_with("Ruby", "JavaScript", match_all: true)   # eq []

# Direct tag_list assign
user.tag_list = "Ruby"

# or

user.tag_list = ["Ruby"]

# or

user.tag_list = SimpleTaggable::TagList.new("Ruby")
```

## Contributing

1. Fork it ( https://github.com/joker1007/simple_taggable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
