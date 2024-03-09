# Changelog

## 0.2.0 (03.09.2024)

### Changes

* Implement new `:numbers` dictionary type for dynamic number generation
* Refactor dictionary retrieval/loading mechanism (store dictionaries as modules rather than reading from asset files)

### Bug fixes

* Fix issue which would cause dictionary words containing a space character to be split into multiple words
* Fix issue where separator would not be applied to words containing whitespace

## 0.1.0 (03.07.2024)

* Initial release 