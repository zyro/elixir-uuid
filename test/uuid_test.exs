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

  test "UUID v1 to UUID v6 conversion" do
    uuid1 = UUID.uuid1() |> validate_uuid(1)
    assert uuid1 == UUID.uuid1_to_uuid6(uuid1) |> validate_uuid(6) |> UUID.uuid6_to_uuid1()
  end

  test "UUID v6 to UUID v1 conversion" do
    uuid6 = UUID.uuid6() |> validate_uuid(6)
    assert uuid6 == UUID.uuid6_to_uuid1(uuid6) |> validate_uuid(1) |> UUID.uuid1_to_uuid6()
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
      validate_uuid(UUID.binary_to_string!(result[:binary]), expected[:version])
    end
    test "UUID.info/1 #{name}" do
      {expected, []} = Code.eval_string(unquote(expected))
      {:ok, result} = UUID.info(unquote(input))
      assert ^expected = result
      validate_uuid(UUID.binary_to_string!(result[:binary]), expected[:version])
    end
  end

  defp validate_uuid(uuid, version) when version in 1..6 do
    assert Regex.match?(~r/^[0-9a-f]{8}-[0-9a-f]{4}-#{version}[0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i, uuid)
    uuid
  end
end
