# Glimpse::PerformanceBar

Provide a glimpse into `window.performance` timing.

![image](https://f.cloud.github.com/assets/79995/268624/14d9df90-8f47-11e2-9718-111c7c367974.png)

Things this glimpse view provides:

- Frontend
- Latency / Receiving
- Backend
- TCP / SSL
- Redirect
- DNS Lookup

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

```scss
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
- [@tmm1](https://github.com/tmm1) - The original implementation.
- [@rtomayko](https://github.com/rtomayko) - The original implementation.
- [@kneath](https://github.com/kneath) - The original implementation.
- [@dewski](https://github.com/dewski) - Just the extractor.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
