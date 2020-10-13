defmodule UUIDBench do
  use Benchfella

  @uuid_string "716c654f-d2b7-436b-9751-2440a9cb079d"
  @uuid_binary <<113, 108, 101, 79, 210, 183, 67, 107, 151, 81, 36, 64, 169, 203, 7, 157>>

  bench "info!" do
    UUID.info!(@uuid_string)
  end

  bench "binary_to_string!" do
    UUID.binary_to_string!(@uuid_binary)
  end

  bench "string_to_binary!" do
    UUID.string_to_binary!(@uuid_string)
  end

  bench "uuid1" do
    UUID.uuid1
    :ok
  end

  bench "uuid3 dns" do
    UUID.uuid3(:dns, "test.example.com")
  end

  bench "uuid4" do
    UUID.uuid4
    :ok
  end

  bench "uuid5 dns" do
    UUID.uuid5(:dns, "test.example.com")
  end

  bench "uuid6 mac_address" do
    UUID.uuid6(:mac_address)
    :ok
  end

  bench "uuid6 random_bytes" do
    UUID.uuid6(:random_bytes)
    :ok
  end
end
