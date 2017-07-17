# 1.0.0

- Initial release.

# 1.1.0

- Add support for Turbolinks. (#2)

# 1.1.1

- Remove HTML from tooltips to remove any text artifacts. (#4)

# 1.1.2

- Namespace the tooltips to not conflict with application styles. (#8)
- Don't render the performance bar when `window.performance` doesn't exist. (#10)

# 1.1.3

- Use auto-gravity for tooltips on Peek bars that may be fixed to the bottom of the window.

# 1.1.4

- Fixed incorrect time on initial page load with newer Turbolinks - #17 (@brandonweiss)

# 1.1.5

- Don't strip `X-Request-Start` header which New Relic relies on. - #20

# 1.1.6

- Namespace ProcessUtilization middleware to Peek::Views::PerformanceBar - #21 (@jnunemaker)

# 1.2.0

- Allow `PerformanceBar::ProcessUtilization::Body` to behave like normal response body - #22 (@tubaxenor)

# 1.2.1

- Listen to Turbolinks v5 `turbolinks:request-start` and `turbolinks:load` JS events to trigger peek-performance_bar updates. - [#26](https://github.com/peek/peek-performance_bar/pull/26) [@lucasmazza](https://github.com/lucasmazza)

# 1.3.0

- Remove CoffeeScript support in favor of plain JavaScript. - [#28](https://github.com/peek/peek-performance_bar/pull/28) [@gfx](https://github.com/gfx)
- Use Rack::BodyProxy to fix X-Sendfile header being incorrectly set. - [#27](https://github.com/peek/peek-performance_bar/pull/27) [@rymai](https://github.com/rymai)
