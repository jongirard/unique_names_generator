# Changelog

## 0.2.1 (24.07.2026)

### Bug fixes

* Fix `ArgumentError` crash when a string/integer seed hashed to a small float that `Float.to_string/1` renders in scientific notation (e.g. `7.458e-5`); the `e`/exponent-sign characters reached `String.to_integer/1`. Seed digit extraction now keeps only digits, leaving results for all non-scientific seeds unchanged.

## 0.2.0 (03.09.2024)

### Changes

* Implement new `:numbers` dictionary type for dynamic number generation
* Refactor dictionary retrieval/loading mechanism (store dictionaries as modules rather than reading from asset files)

### Bug fixes

* Fix issue which would cause dictionary words containing a space character to be split into multiple words
* Fix issue where separator would not be applied to words containing whitespace

## 0.1.0 (03.07.2024)

* Initial release 