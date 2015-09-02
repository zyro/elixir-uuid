defmodule UUID.DocTest do
  use ExUnit.Case, async: true

  doctest UUID, except: [uuid1: 1, uuid1: 3, uuid4: 1]
end
