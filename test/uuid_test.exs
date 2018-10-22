defmodule UUIDTest do
  use ExUnit.Case

  test "UUID.info/1 invalid argument type" do
    assert UUID.info(:not_a_uuid) == {:error, "Invalid argument; Expected: String"}
  end

  test "UUID.info/1 invalid UUID" do
    assert UUID.info("not_a_uuid") == {:error, "Invalid argument; Not a valid UUID: not_a_uuid"}
  end

  test "UUID.info!/1 invalid argument type" do
    assert_raise(
      ArgumentError,
      "Invalid argument; Expected: String",
      fn ->
        UUID.info!(:not_a_uuid)
      end
    )
  end

  test "UUID.info!/1 invalid UUID" do
    assert_raise(
      ArgumentError,
      "Invalid argument; Not a valid UUID: not_a_uuid",
      fn ->
        UUID.info!("not_a_uuid")
      end
    )
  end

  # Expand the lines in info_tests.txt into individual tests for the
  # UUID.info!/1 and UUID.info/1 functions, assuming the lines are:
  #   test name || expected output || input value
  for line <- File.stream!(Path.join([__DIR__, "info_tests.txt"]), [], :line) do
    [name, expected, input] =
      line |> String.split("||") |> Enum.map(&String.trim/1)
    test "UUID.info!/1 #{name}" do
      {expected, []} = Code.eval_string(unquote(expected))
      result = UUID.info!(unquote(input))
      assert ^expected = result
    end
    test "UUID.info/1 #{name}" do
      {expected, []} = Code.eval_string(unquote(expected))
      {:ok, result} = UUID.info(unquote(input))
      assert ^expected = result
    end
  end

end
