Changelog
=========

### Unreleased changes

* Vastly improved binary handling: ~3.5x faster UUID generation and UUID binary to string, ~1.5x faster UUID string to binary.
* Rename `info/1` to `info!/1` for consistency with Elixir best practices.
* Add `binary_to_string!/2` and `string_to_binary!/1` utility functions.
* Bump Elixir version requirement to `~> 1.0`.
* [Internal] Additional tests, integrate repo with Travis CI.

---

### v0.1.5, 12 Aug 2014, Elixir `>= 0.15.0`

* [Internal] Allow Elixir `0.15.0` and above for convenience.

### v0.1.4, 10 Aug 2014, Elixir `~> 0.15.0`

* [Internal] Use new Elixir binary matching type declaration format.

### v0.1.3, 14 Jul 2014, Elixir `~> 0.14.3`

* [Internal] Use new Elixir default parameter declaration format in separate function header.

### v0.1.2, 01 Jul 2014, Elixir `~> 0.14.2`

* [Enhancement] `UUID.info/1` now also returns the binary value of the given UUID.

### v0.1.1, 14 Jun 2014, Elixir `~> 0.14.0`

* [Enhancement] Added `UUID.uuid1/3` which allows optional preset `clock_seq` and `node_id`, the last argument is still an optional format atom.

### v0.1.0, 07 Jun 2014, Elixir `== 0.13.3 or ~> 0.14.0-dev`

* Initial release.
