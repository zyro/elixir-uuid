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

  describe "uuid1" do
    test "generate a UUIDv1 with no args" do
      info = UUID.uuid1() |> UUID.info!()
      assert info[:type] == :default
      assert <<_::128>> = info[:binary]
    end

    test "generate a UUIDv1 with a type" do
      info = UUID.uuid1(:hex) |> UUID.info!()
      assert info[:type] == :hex
      assert <<_::128>> = info[:binary]
    end

    test "generate a UUIDv1 with a provided clock_seq and node" do
      info = UUID.uuid1(<<1::6, 2::8>>, <<3, 4, 5, 6, 7, 8>>) |> UUID.info!()
      assert info[:type] == :default
      assert <<_::66, 1::6, 2, 3, 4, 5, 6, 7, 8>> = info[:binary]
    end

    test "generate a UUIDv1 with a provided clock_seq, node, and type" do
      info = UUID.uuid1(<<1::6, 2::8>>, <<3, 4, 5, 6, 7, 8>>, :hex) |> UUID.info!()
      assert info[:type] == :hex
      assert <<_::66, 1::6, 2, 3, 4, 5, 6, 7, 8>> = info[:binary]
    end

    test "the default time represents 'now'" do
      {:ok, time} = UUID.uuid1() |> UUID.uuid1_gettime()
      assert DateTime.diff(DateTime.now!("Etc/UTC"), time, :millisecond) < 1000
    end

    test "generate a UUIDv1 with a provided time (bitstring), clock_seq, node, and type" do
      timestamp = <<30, 208, 69, 18, 82, 149, 94, 0::size(4)>>  # ~U[2022-07-15 15:16:48.068144Z]
      uuid = UUID.uuid1(timestamp, <<1::6, 2::8>>, <<3, 4, 5, 6, 7, 8>>, :hex)
      {:ok, time} = UUID.uuid1_gettime(uuid)
      assert time == ~U[2022-07-15 15:16:48.068144Z]
    end

    test "generate a UUIDv1 with a provided time (DateTime), clock_seq, node, and type" do
      timestamp = ~U[2022-07-15 15:16:48.068144Z]
      uuid = UUID.uuid1(timestamp, <<1::6, 2::8>>, <<3, 4, 5, 6, 7, 8>>, :hex)
      {:ok, time} = UUID.uuid1_gettime(uuid)
      assert time == timestamp
    end
  end

  describe "uuid1_gettime" do
    test "invalid arguments" do
      assert UUID.uuid1_gettime(0) == {:error, "Invalid argument; Expected: String"}
      assert UUID.uuid1_gettime(UUID.uuid4()) == {:error, "Invalid argument; Expected a UUIDv1 variant 2"}
    end

    test "gets time from a string or binary uuid" do
      assert {:ok, %DateTime{}} = UUID.uuid1_gettime(UUID.uuid1())
      assert {:ok, %DateTime{}} = UUID.uuid1_gettime(UUID.uuid1(:raw))
    end
  end

  describe "uuid1_gettime!" do
    test "invalid arguments" do
      assert_raise MatchError, fn -> UUID.uuid1_gettime!(0) end
      assert_raise MatchError, fn -> UUID.uuid1_gettime!(UUID.uuid4()) end
    end

    test "gets time from a string or binary uuid" do
      assert %DateTime{} = UUID.uuid1_gettime!(UUID.uuid1())
      assert %DateTime{} = UUID.uuid1_gettime!(UUID.uuid1(:raw))
    end
  end
end
