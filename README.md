#Poppy

## Introduction
TODO

## Installation

``` bundle install poppy ```

### Rails
Add poppy to your `Gemfile`

**optional**

```bash
$> rails g poppy:install
```

will add an initializer that calls

```ruby
ActiveRecord::Base.include(Poppy::ActiveRecord)
``` 

this can be omitted by manually including the adapter in each model that uses Poppy

```ruby
class Sandwhich < ActiveRecord::Base
	include Poppy::ActiveRecord::Adapter
	
	enumeration :bread, of: Bread
	#...
end
```

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
		extend Poppy::Value
		
		def self.enjoyed_by_kids?
			true
		end
	end
	
	class Multigrain
		extend Poppy::Value
		
		def self.enjoyed_by_kids?
			false
		end
	end
end

white = Bread::WHITE
multi = Bread::MULTIGRAIN

puts white.enjoyed_by_kids? # true
puts multi.enoyed_by_kids? # false

```

Each enumeration value is just a Poro. Each value has an interface of one method, `#humanize`. More methods can be added to build a more robust interface.

`Poppy::Value` defines humanize to be the demodulized class name humanized and capitalized. You are free to implement this however you would like.

E.g.

```ruby
class Bread < Poppy::Enum

	value :white, class White
		def self.humanize
			'Black'
		end
	end
	
	value :multigrain, class Multigrain
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

### Model
```ruby
class Sandwhich < ActiveRecord::Base
	
	enumeration :bread, of: Bread
end
```
* Adding an enumeration to an active_record model will add an inclusion validation. There is no support for nullable enumerations. If you would like this functionality you will need to add a null value
E.g. ` Bread::None `

### Migrations

```ruby
class AddJobKindsToJob < ActiveRecord::Migration
  def change
    add_column :sandwhichess, :bread, :string, default: Bread::WHITE
  end
end
```

### In the wild

```
> sandwhich = Sandwhich.new(bread: Bread::WHITE)
> sandwhich.bread
=> Bread::WHITE

> sandwhich.as_json 
=> {bread: 'white', ... }
```

##API

### Poppy::Enum
#### .value_for

```ruby
> Bread.value_for(:white)
=> Bread::WHITE
```

#### .values

```ruby
> Bread.values
=> [:white, :multigrain, :gluten_free]
```

#### .list

```ruby
> Bread.list
=> [Bread::WHITE, BREAD::MULTIGRAIN, Bread::GLUTEN_FREE]
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