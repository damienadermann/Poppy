#Poppy
[![Gem Version](https://badge.fury.io/rb/poppy.svg)](http://rubygems.org/gems/poppy)
[![Build Status](https://travis-ci.org/damienadermann/poppy.svg?branch=master)](http://travis-ci.org/damienadermann/poppy)
[![Code Climate](https://codeclimate.com/github/damienadermann/poppy/badges/gpa.svg)](https://codeclimate.com/github/damienadermann/poppy)

## Introduction
Simple Polymorphic Enumerations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'poppy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poppy


## Usage


### Basic
```ruby
class Bread < Poppy::Enum
  values :white, :multigrain, :gluten_free
end
```

#### Using an enum value
```ruby
> bread = Bread::WHITE
> bread 
=> Bread::WHITE

> bread.humanize
=> White
```


#### Listing all enum values
```
> Bread.list
=> [Bread::WHITE, BREAD::MULTIGRAIN, Bread::GLUTEN_FREE]

> Bread.collection
=> [['White', 'white'], ['Multigrain', 'multigrain'], ['Gluten free', 'gluten_free']
```

### Custom values
Each enumeration value is able to define its own behavior. This makes our enumerations much more polymorphic. By defining classes we can decide the behavior each enumeration value has. Each value added to the enumeration will be created by instantiating the matching class 

E.g. Bread::WHITE is created from the value :white. It is instantiated by the class Bread::White.

If no matching class exists a class will be created before it is instantiated

***Never instantiate a class directly. Enum::Value.new != Enum::VALUE***


```ruby
class Bread < Poppy::Enum
  values :white, :multigrain

  private

  class White
    include Poppy::Value
    
    def enjoyed_by_kids?
      true
    end
  end
  
  class Multigrain
    include Poppy::Value
    
    def enjoyed_by_kids?
      false
    end
  end
end

white = Bread::WHITE
multi = Bread::MULTIGRAIN

puts white.enjoyed_by_kids? # true
puts multi.enoyed_by_kids? # false

```

Each enumeration value is just a Poro. Each value has an interface of one method, `#humanize`. More methods can be added to build a more robust interface. If not using Poppy::Rails humanize can be omitted.

`Poppy::Value` by default, defines humanize to be the demodulized class name humanized and capitalized. You are free to implement this however you would like.

E.g.

```ruby
class Bread < Poppy::Enum
  values :white, :multigrain

  class White
    def humanize
      'Black'
    end
  end
  
  class Multigrain
    extend Poppy::Value
  end
end

```

### Polymorphism


By giving each Enumeration value behavior we can remove switch statements from our codebase.

```ruby
bread = Bread::WHITE

case bread
when Bread::WHITE
  puts 'My kid will love this'
when Bread::MULTIGRAIN
  puts 'My kid will play bread frisbee'
when Bread::GLUTEN_FREE
  puts 'My kid will play bread frisbee'
end

```

becomes

```
if bread.enjoyed_by_kids?
  puts 'My kid will love this'
else
  puts 'My kid will play bread frisbee'
end
```

## ActiveRecord Integration

See the [Poppy Rails](https://github.com/damienadermann/poppy-rails) Gem for a simple integration with ActiveRecord for persistance. Enum arrays are also supported for postgreSQL databases.


##API

### Poppy::Enum
#### .value_for

```ruby
> Bread.value_for(:white)
=> Bread::WHITE
```

#### .values

```ruby
> Bread.list_keys
=> [:white, :multigrain, :gluten_free]
```

#### .list

```ruby
> Bread.list
=> [Bread::WHITE, BREAD::MULTIGRAIN, Bread::GLUTEN_FREE]
```

#### .valid?

```ruby
> Bread.valid?(Bread::WHITE)
=> true
```

### .key_for

```ruby
> Bread.key_for(Bread::WHITE)
=> :white
```

#### .collection
```ruby
> Bread.collection
=> [['White', 'white'], ['Multigrain', 'multigrain'], ['Gluten free', 'gluten_free']
```
* element.first is defined by the humanized value

For use with the Rails form builder

### Poppy::Value

#### #humanize
```ruby
> Bread::WHITE.humanize
=> White 
```

