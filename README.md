# Glimpse::PerformanceBar

Provide a glimpse into the MySQL queries made during your application's requests.

Things this glimpse view provides:

- Total number of MySQL queries called during the request
- The duration of the queries made during the request

## Installation

Add this line to your application's Gemfile:

    gem 'glimpse-performance_bar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glimpse-performance_bar

## Usage

Add the following to your `config/initializers/glimpse.rb`: 

```ruby
Glimpse.into Glimpse::Views::PerformanceBar
```

You'll then need to add the following CSS and CoffeeScript:

CSS:

```css
//= require glimpse
//= require glimpse/views/performance_bar
```

CoffeeScript:

```coffeescript
#= require glimpse
#= require glimpse/views/performance_bar
```

Lastly this view requires you insert an additional partial after the `glimpse/results`:

```erb
...
<%= yield %>
<%= render 'glimpse/results' %>
<%= render 'glimpse/results/performance_bar' %>
...
```

## Contributors

- [@josh](https://github.com/josh) - The original implementation.
- [@dewski](https://github.com/dewski) - Just the extractor.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
