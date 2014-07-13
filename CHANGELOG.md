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
