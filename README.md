# Peek::PerformanceBar

Take a peek into the `window.performance` timing behind your app.

![image](https://f.cloud.github.com/assets/79995/268624/14d9df90-8f47-11e2-9718-111c7c367974.png)

Things this peek view provides:

- Frontend
- Latency / Receiving
- Backend
- TCP / SSL
- Redirect
- DNS Lookup

## Installation

Add this line to your application's Gemfile:

    gem 'peek-performance_bar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peek-performance_bar

## Usage

Add the following to your `config/initializers/peek.rb`:

```ruby
Peek.into Peek::Views::PerformanceBar
```

You'll then need to add the following CSS and CoffeeScript:

CSS:

```scss
//= require peek
//= require peek/vendor/tipsy
//= require peek/views/performance_bar
```

CoffeeScript:

```coffeescript
#= require peek
#= require peek/views/performance_bar
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
