defmodule UUIDTest do
  use ExUnit.Case

  test "UUID.info/1 invalid argument type" do
    assert_raise(
      ArgumentError,
      "Invalid argument; Expected: String",
      fn ->
        UUID.info(:not_a_uuid)
      end
    )
  end

  test "UUID.info/1 invalid UUID" do
    assert_raise(
      ArgumentError,
      "Invalid argument; Not a valid UUID: not_a_uuid",
      fn ->
        UUID.info("not_a_uuid")
      end
    )
  end

  # Expand the lines in info_tests.txt into individual tests for the
  # UUID.info/1 function, assuming the lines are:
  #   test name || expected output || input value
  for line <- File.stream!(Path.join([__DIR__, "info_tests.txt"]), [], :line) do
    [name, expected, input] =
      line |> String.split("||") |> Enum.map(&String.strip(&1))
    test name do
      {expected, []} = Code.eval_string(unquote(expected))
      result = UUID.info(unquote(input))
      assert ^expected = result
    end
  end

end
