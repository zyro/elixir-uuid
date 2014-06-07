Elixir UUID
===========

UUID generator and utilities for Elixir. See [RFC 4122](http://www.ietf.org/rfc/rfc4122.txt).

### Installation

Add as a dependency to your `mix.exs` file:
```elixir
defp deps do
  [{:uuid, github: "zyro/elixir-uuid"}]
end
```

_Coming soon to [Hex.pm](https://hex.pm/)._

### UUID v1

Generated using a combination of time since the west adopted the gregorian calendar and the node id MAC address.

```elixir
iex> UUID.uuid1()
"5976423a-ee35-11e3-8569-14109ff1a304"
```

### UUID v3

Generated using the MD5 hash of a name and either a namespace atom or an existing UUID. Valid namespaces are: `:dns`, `:url`, `:oid`, `:x500`, `:nil`.

```elixir
iex> UUID.uuid3(:dns, "my.domain.com")
"eecf4c2b-f6e5-3ae3-bef7-1ea09f91d3e7"

iex> UUID.uuid3("5976423a-ee35-11e3-8569-14109ff1a304", "my.domain.com")
"0609d667-944c-3c2d-9d09-18af5c58c8fb"
```

### UUID v4

Generated based on pseudo-random bytes.

```elixir
iex> UUID.uuid4()
"fcfe5f21-8a08-4c9a-9f97-29d2fd6a27b9"
```

### UUID v5

Generated using the SHA1 hash of a name and either a namespace atom or an existing UUID. Valid namespaces are: `:dns`, `:url`, `:oid`, `:x500`, `:nil`.

```elixir
iex> UUID.uuid5(:dns, "my.domain.com")
"ae119419-7776-563d-b6e8-8a177abccc7a"

iex> UUID.uuid5("fcfe5f21-8a08-4c9a-9f97-29d2fd6a27b9", "my.domain.com")
"b8e85535-761a-586f-9c04-0fb0df2cbe84"
```

### Formatting

All UUID generator functions have an optional format parameter as the last argument.

Possible values: `:default`, `:hex`, `:urn`. Default value is `:default` and can be omitted.

`:default` is a standard UUID representation:
```elixir
iex> UUID.uuid1()
"3c69679f-774b-4fb1-80c1-7b29c6e7d0a0"

iex> UUID.uuid4(:default)
"3c69679f-774b-4fb1-80c1-7b29c6e7d0a0"

iex> UUID.uuid3(:dns, "my.domain.com")
"eecf4c2b-f6e5-3ae3-bef7-1ea09f91d3e7"

iex> UUID.uuid5(:dns, "my.domain.com", :default)
"ae119419-7776-563d-b6e8-8a177abccc7a"
```

`:hex` is a valid hex string, corresponding to the standard UUID without the `-` (dash) characters:
```elixir
iex> UUID.uuid4(:hex)
"19be859d0c1f4a7f95ddced995037350"
```

`:urn` is a standard UUID representation prefixed with the UUID URN:
```elixir
iex> UUID.uuid1(:urn)
"urn:uuid:b7483bde-ee35-11e3-8daa-14109ff1a304"
```

### Utility functions

Use `UUID.info/1` to get a keyword list containing information about the given UUID:
```elixir
iex> UUID.info("4995555a-1361-4b45-5803-9ef16250956c")
[uuid: "4995555a-1361-4b45-5803-9ef16250956c",
 type: :default,
 version: 4,
 variant: :rfc4122]

iex> UUID.info("8ea1513df8a14dea9bea6b8f4b5b6e73")
[uuid: "8ea1513df8a14dea9bea6b8f4b5b6e73",
 type: :hex,
 version: 4,
 variant: :rfc4122]

iex> UUID.info("urn:uuid:ef1b1a28-ee34-11e3-8813-14109ff1a304")
[uuid: "urn:uuid:ef1b1a28-ee34-11e3-8813-14109ff1a304",
 type: :urn,
 version: 1,
 variant: :rfc4122]
```

### Attribution

Some code ported from [avtobiff/erlang-uuid](https://github.com/avtobiff/erlang-uuid).

### License

```
   Copyright 2014 Andrei Mihu

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
