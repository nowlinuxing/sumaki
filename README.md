# Sumaki

---

[![Gem Version](https://badge.fury.io/rb/sumaki.svg)](https://badge.fury.io/rb/sumaki)
![example workflow](https://github.com/nowlinuxing/sumaki/actions/workflows/main.yml/badge.svg?branch=main)
[![Maintainability](https://api.codeclimate.com/v1/badges/dd92d4092d6858cbcfb2/maintainability)](https://codeclimate.com/github/nowlinuxing/sumaki/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/dd92d4092d6858cbcfb2/test_coverage)](https://codeclimate.com/github/nowlinuxing/sumaki/test_coverage)

**Sumaki** is a wrapper for structured data like JSON.

Since Sumaki wraps the target data as it is, rather than parsing it using a schema, the original data can be referenced at any time.

This makes it easy to add or modify definitions as needed while checking the target data.

This feature may be useful when there is no document defining the structure of the data, or when the specification is complex and difficult to grasp, and the definition is written little by little starting from the obvious places.

```ruby
class AnimeList
  include Sumaki::Model
  repeated :anime
  field :name

  class Anime
    include Sumaki::Model
    singular :studio
    field :title

    class Studio
      include Sumaki::Model
      field :name
    end
  end
end

data = {
  name: 'Winter 2023',
  anime: [
    {
      title: 'The Vampire Dies in No Time',
      studio: {
        name: 'MADHOUSE Inc.'
      }
    },
    {
      title: '“Ippon” again!',
      studio: {
        name: 'BAKKEN RECORD'
      }
    }
  ]
}

anime_list = AnimeList.new(data)
anime_list.name #=> 'Winter 2023'
anime_list.anime[0].title #=> 'The Vampire Dies in No Time'
anime_list.anime[0].studio.name #=>  'MADHOUSE Inc.'
anime_list.anime[0].object #=> { title: 'The Vampire Dies in No Time', studio: { name: 'MADHOUSE Inc.' } }
```


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add sumaki

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install sumaki

## Usage

Include `Sumaki::Model` module in the class that wraps the data, and give the data when creating the instance.

```ruby
class Anime
  include Sumaki::Model
end

Anime.new({})
```

Only this does not give access to fields or structured data, so the following declarations need to be added.

### Access to the fields

By declaring `field`, you can access the field.

```ruby
class Anime
  include Sumaki::Model
  field :title
  field :url
end

anime = Anime.new({ title: 'The Vampire Dies in No Time', url: 'https://sugushinu-anime.jp/' })
anime.title #=> 'The Vampire Dies in No Time'
anime.url #=> 'https://sugushinu-anime.jp/'
```

If the data contains attributes not declared in the field, it raises no error and is simply ignored.

### Access to the sub object

By declaring `singular`, you can access the sub object.

```ruby
class Book
  include Sumaki::Model
  singular :company
  field :title

  class Company
    include Sumaki::Model
    field :name
    field :prefecture
  end
end

data = {
  title: 'The Ronaldo Chronicles',
  company: {
    name: 'Autumn Books',
    prefecture: 'Tokyo'
  }
}

comic = Book.new(data)
comic.company.name #=> 'Autumn Books'
```

sub object is wrapped with the class inferred from the field name under the original class.

This can be changed by specifying the class to wrap.

```ruby
class Book
  include Sumaki::Model
  singular :author, class_name: 'Character'
  field :title

  class Character
    include Sumaki::Model
    field :name
  end
end

data = {
  title: 'The Ronaldo Chronicles',
  author: {
    name: 'Ronaldo'
  }
}

book = Book.new(data)
book.author.class #=> Book::Character
```

### Access to the repeated sub objects

By declaring `repeated`, you can access the repeated sub objects as an Array.

```ruby
class Company
  include Sumaki::Model
  repeated :member
  field :name

  class Member
    include Sumaki::Model
    field :name
  end
end

data = {
  name: 'The Ronaldo Vampire Hunter Agency',
  member: [
    { name: 'Ronaldo' },
    { name: 'Draluc' },
    { name: 'John' }
  ]
}

company = Company.new(data)
company.member.size #=> 3
company.member[2].name #=> 'John'
```

The `class_name` option can also be used to specify the class to wrap.

### Access to the parent object

Parent object can be referenced from sub object by `#parent` method.

```ruby
class Character
  include Sumaki::Model
  singular :child
  field :name

  class Child
    include Sumaki::Model
    field :name
  end
end

data = {
  name: 'Draus',
  child: {
    name: 'Draluc'
  }
}

character = Character.new(data)
character.child.name #=> 'Draluc'
character.child.parent.name #=> 'Draus'
```

### Enumerations

By declaring `enum`, You can map a field to the specified value.

```ruby
class Character
  include Sumaki::Model
  field :name
  enum :type, { vampire: 1, vampire_hunter: 2, familier: 3, editor: 4 }
end

data = {
  name: 'John',
  type: 3
}

character = Character.new(data)
character.type #=> :familier
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nowlinuxing/sumaki.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
