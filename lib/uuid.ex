defmodule UUID do
  use Bitwise, only_operators: true
  @moduledoc """
  UUID generator and utilities for [Elixir](http://elixir-lang.org/).
  See [RFC 4122](http://www.ietf.org/rfc/rfc4122.txt).
  """

  @nanosec_intervals_offset 122192928000000000 # 15 Oct 1582 to 1 Jan 1970.
  @nanosec_intervals_factor 10 # Microseconds to nanoseconds factor.

  @variant10 2 # Variant, corresponds to variant 1 0 of RFC 4122.
  @uuid_v1 1 # UUID v1 identifier.
  @uuid_v3 3 # UUID v3 identifier.
  @uuid_v4 4 # UUID v4 identifier.
  @uuid_v5 5 # UUID v5 identifier.

  @urn "urn:uuid:" # UUID URN prefix.

  @doc """
  Inspect a UUID and return information about its 128-bit binary content, type,
  version and variant.

  Timestamp portion is not checked to see if it's in the future, and therefore
  not yet assignable. See "Validation mechanism" in section 3 of RFC 4122.

  ## Examples

    iex> UUID.info("870df8e8-3107-4487-8316-81e089b8c2cf")
    [uuid: "870df8e8-3107-4487-8316-81e089b8c2cf",
     binary: <<135, 13, 248, 232, 49, 7, 68, 135, 131,
                22, 129, 224, 137, 184, 194, 207>>,
     type: :default,
     version: 4,
     variant: :rfc4122]

    iex> UUID.info("8ea1513df8a14dea9bea6b8f4b5b6e73")
    [uuid: "8ea1513df8a14dea9bea6b8f4b5b6e73",
     binary: <<142, 161, 81, 61, 248, 161, 77, 234, 155,
                234, 107, 143, 75, 91, 110, 115>>,
     type: :hex,
     version: 4,
     variant: :rfc4122]

    iex> UUID.info("urn:uuid:ef1b1a28-ee34-11e3-8813-14109ff1a304")
    [uuid: "urn:uuid:ef1b1a28-ee34-11e3-8813-14109ff1a304",
     binary: <<239, 27, 26, 40, 238, 52, 17, 227, 136,
                19, 20, 16, 159, 241, 163, 4>>,
     type: :urn,
     version: 1,
     variant: :rfc4122]

  """
  def info(<<uuid::binary>> = original) do
    {type, <<uuid::128>>} = uuid_string_to_hex_pair(uuid)
    <<_::48, version::4, _::12, v0::1, v1::1, v2::1, _::61>> = <<uuid::128>>
    [uuid: original,
     binary: <<uuid::128>>,
     type: type,
     version: version,
     variant: variant(<<v0, v1, v2>>)]
  end
  def info(_) do
    raise ArgumentError, message: "Invalid argument; Expected: String"
  end

  @doc """
  Generate a new UUID v1. This version uses a combination of one or more of:
  unix epoch, random bytes, pid hash, and hardware address.

  Optionally takes two parameters: a 14 bit clock sequence and a 48 bit node id.

  ## Examples

    iex> UUID.uuid1()
    "cdfdaf44-ee35-11e3-846b-14109ff1a304"

    iex> UUID.uuid1(:default)
    "cdfdaf44-ee35-11e3-846b-14109ff1a304"

    iex> UUID.uuid1(:hex)    
    "cdfdaf44ee3511e3846b14109ff1a304"

    iex> UUID.uuid1(:urn)
    "urn:uuid:cdfdaf44-ee35-11e3-846b-14109ff1a304"

  """
  def uuid1(format \\ :default) do
    uuid1(uuid1_clockseq(), uuid1_node(), format)
  end

  def uuid1(clock_seq, node, format \\ :default)
  def uuid1(<<clock_seq::14>>, <<node::48>>, format) do
    <<time_hi::12, time_mid::16, time_low::32>> = uuid1_time()
    <<clock_seq_hi::6, clock_seq_low::8>> = <<clock_seq::14>>
    <<time_low::32, time_mid::16, @uuid_v1::4, time_hi::12, @variant10::2,
      clock_seq_hi::6, clock_seq_low::8, node::48>>
      |> uuid_to_string format
  end
  def uuid1(_, _, _) do
    raise ArgumentError, message:
    "Invalid argument; Expected: <<clock_seq::14>>, <<node::48>>"
  end

  @doc """
  Generate a new UUID v3. This version uses an MD5 hash of fixed value (chosen
  based on a namespace atom - see Appendix C of RFC 4122) and a name value. Can
  also be given an existing UUID String instead of a namespace atom.

  Accepted arguments are: :dns|:url|:oid|:x500|:nil OR uuid, String

  ## Examples

    iex> UUID.uuid3(:dns, "my.domain.com")
    "eecf4c2b-f6e5-3ae3-bef7-1ea09f91d3e7"

    iex> UUID.uuid3(:dns, "my.domain.com", :default)
    "eecf4c2b-f6e5-3ae3-bef7-1ea09f91d3e7"

    iex> UUID.uuid3(:dns, "my.domain.com", :hex)
    "eecf4c2bf6e53ae3bef71ea09f91d3e7"

    iex> UUID.uuid3(:dns, "my.domain.com", :urn)
    "urn:uuid:eecf4c2b-f6e5-3ae3-bef7-1ea09f91d3e7"

    iex> UUID.uuid3("cdfdaf44-ee35-11e3-846b-14109ff1a304", "my.domain.com")
    "8808f33a-3e11-3708-919e-15fba88908db"

  """
  def uuid3(namespace_or_uuid, name, format \\ :default)
  def uuid3(:dns, <<name::binary>>, format) do
    namebased_uuid(:md5, <<"6ba7b8109dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid3(:url, <<name::binary>>, format) do
    namebased_uuid(:md5, <<"6ba7b8119dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid3(:oid, <<name::binary>>, format) do
    namebased_uuid(:md5, <<"6ba7b8129dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid3(:x500, <<name::binary>>, format) do
    namebased_uuid(:md5, <<"6ba7b8149dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid3(:nil, <<name::binary>>, format) do
    namebased_uuid(:md5, <<0::128, name::binary>>)
      |> uuid_to_string format
  end
  def uuid3(<<uuid::binary>>, <<name::binary>>, format) do
    {_type, <<uuid::128>>} = uuid_string_to_hex_pair(uuid)
    namebased_uuid(:md5, <<uuid::128, name::binary>>)
      |> uuid_to_string format
  end
  def uuid3(_, _, _) do
    raise ArgumentError, message:
    "Invalid argument; Expected: :dns|:url|:oid|:x500|:nil OR String, String"
  end

  @doc """
  Generate a new UUID v4. This version uses pseudo-random bytes generated by
  the `crypto` module.

  ## Examples

    iex> UUID.uuid4()
    "fb49a0ec-d60c-4d20-9264-3b4cfe272106"

    iex> UUID.uuid4(:default)
    "fb49a0ec-d60c-4d20-9264-3b4cfe272106"

    iex> UUID.uuid4(:hex)
    "fb49a0ecd60c4d2092643b4cfe272106"

    iex> UUID.uuid4(:urn)
    "urn:uuid:fb49a0ec-d60c-4d20-9264-3b4cfe272106"

  """
  def uuid4(format \\ :default) do
    <<u0::48, _::4, u1::12, _::2, u2::62>> = :crypto.rand_bytes(16)
    <<u0::48, @uuid_v4::4, u1::12, @variant10::2, u2::62>>
      |> uuid_to_string format
  end

  @doc """
  Generate a new UUID v5. This version uses an SHA1 hash of fixed value (chosen
  based on a namespace atom - see Appendix C of RFC 4122) and a name value. Can
  also be given an existing UUID String instead of a namespace atom.

  Accepted arguments are: :dns|:url|:oid|:x500|:nil OR uuid, String

  ## Examples

    iex> UUID.uuid5(:dns, "my.domain.com")
    "ae119419-7776-563d-b6e8-8a177abccc7a"

    iex> UUID.uuid5(:dns, "my.domain.com", :default)
    "ae119419-7776-563d-b6e8-8a177abccc7a"

    iex> UUID.uuid5(:dns, "my.domain.com", :hex)
    "ae1194197776563db6e88a177abccc7a"

    iex> UUID.uuid5(:dns, "my.domain.com", :urn)
    "urn:uuid:ae119419-7776-563d-b6e8-8a177abccc7a"

    iex> UUID.uuid5("fb49a0ec-d60c-4d20-9264-3b4cfe272106", "my.domain.com")
    "822cab19-df58-5eb4-98b5-c96c15c76d32"

  """
  def uuid5(namespace_or_uuid, name, format \\ :default)
  def uuid5(:dns, <<name::binary>>, format) do
    namebased_uuid(:sha1, <<"6ba7b8109dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid5(:url, <<name::binary>>, format) do
    namebased_uuid(:sha1, <<"6ba7b8119dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid5(:oid, <<name::binary>>, format) do
    namebased_uuid(:sha1, <<"6ba7b8129dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid5(:x500, <<name::binary>>, format) do
    namebased_uuid(:sha1, <<"6ba7b8149dad11d180b400c04fd430c8", name::binary>>)
      |> uuid_to_string format
  end
  def uuid5(:nil, <<name::binary>>, format) do
    namebased_uuid(:sha1, <<0::128, name::binary>>)
      |> uuid_to_string format
  end
  def uuid5(<<uuid::binary>>, <<name::binary>>, format) do
    {_type, <<uuid::128>>} = uuid_string_to_hex_pair(uuid)
    namebased_uuid(:sha1, <<uuid::128, name::binary>>)
      |> uuid_to_string format
  end
  def uuid5(_, _, _) do
    raise ArgumentError, message:
    "Invalid argument; Expected: :dns|:url|:oid|:x500|:nil OR String, String"
  end

  #
  # Internal utility functions.
  #

  # Convert UUID bytes to String.
  defp uuid_to_string(<<u0::32, u1::16, u2::16, u3::16, u4::48>>, :default) do
    :io_lib.format("~8.16.0b-~4.16.0b-~4.16.0b-~4.16.0b-~12.16.0b",
                   [u0, u1, u2, u3, u4])
      |> to_string
  end
  defp uuid_to_string(<<u::128>>, :hex) do
    :io_lib.format("~32.16.0b", [u])
      |> to_string
  end
  defp uuid_to_string(<<u::128>>, :urn) do
    @urn <> uuid_to_string(<<u::128>>, :default)
  end
  defp uuid_to_string(_u, format) do
    raise ArgumentError, message:
    "Invalid format " <> to_string(format) <> "; Expected: :default|:hex|:urn"
  end

  # Extract the type (:default etc) and pure byte value from a UUID String.
  defp uuid_string_to_hex_pair(<<uuid::binary>>) do
    uuid = String.downcase(uuid)
    {type, hex_str} = case uuid do
      <<u0::64, "-", u1::32, "-", u2::32, "-", u3::32, "-", u4::96>> ->
        {:default, <<u0::64, u1::32, u2::32, u3::32, u4::96>>}
      <<u::256>> ->
        {:hex, <<u::256>>}
      <<@urn, u0::64, "-", u1::32, "-", u2::32, "-", u3::32, "-", u4::96>> ->
        {:urn, <<u0::64, u1::32, u2::32, u3::32, u4::96>>}
      _ ->
        raise ArgumentError, message:
        "Invalid argument; Not a valid UUID: " <> uuid
    end
    fread = :io_lib.fread('~16u', to_char_list(hex_str))
    case fread do
      {:ok, [hex_int], []} ->
        {type, <<hex_int::128>>}
      _ ->
        raise ArgumentError, message:
        "Invalid argument; Not a valid UUID: " <> uuid
    end
  end

  # Get unix epoch as a 60-bit timestamp.
  defp uuid1_time() do
    {mega_sec, sec, micro_sec} = :erlang.now()
    epoch = (mega_sec * 1000000000000 + sec * 1000000 + micro_sec)
    timestamp = @nanosec_intervals_offset + @nanosec_intervals_factor * epoch
    <<timestamp::60>>
  end

  # Generate random clock sequence.
  defp uuid1_clockseq() do
    pid_sum = :erlang.phash2(:erlang.self())
    <<n0::32, n1::32, n2::32>> = :crypto.rand_bytes(12)
    now_xor_pid = {n0 ^^^ pid_sum, n1 ^^^ pid_sum, n2 ^^^ pid_sum}
    :random.seed(now_xor_pid)
    rnd = :random.uniform(2 <<< 14 - 1)
    <<rnd::14>>
  end

  # Get local IEEE 802 (MAC) address, or a random node id if it can't be found.
  defp uuid1_node() do
    {:ok, ifs0} = :inet.getifaddrs()
    uuid1_node(ifs0)
  end

  # Skip loopback adapter.
  defp uuid1_node([{"lo", _if_config} | rest]) do
    uuid1_node(rest)
  end
  defp uuid1_node([{_if_name, if_config} | rest]) do
    case :lists.keyfind(:hwaddr, 1, if_config) do
      {:hwaddr, hw_addr} ->
        :erlang.list_to_binary(hw_addr)
      :false ->
        uuid1_node(rest)
    end
  end
  defp uuid1_node(_) do
    <<rnd_hi::7, _::1, rnd_low::40>> = :crypto.rand_bytes(6)
    <<rnd_hi::7, 1::1, rnd_low::40>>
  end

  # Generate a hash of the given data.
  defp namebased_uuid(:md5, data) do
    md5 = :crypto.hash(:md5, data)
    compose_namebased_uuid(@uuid_v3, md5)
  end
  defp namebased_uuid(:sha1, data) do
    <<sha1::128, _::32>> = :crypto.hash(:sha, data)
    compose_namebased_uuid(@uuid_v5, <<sha1::128>>)
  end

  # Format the given hash as a UUID.
  defp compose_namebased_uuid(version, hash) do
    <<time_low::32, time_mid::16, _::4, time_hi::12, _::2,
      clock_seq_hi::6, clock_seq_low::8, node::48>> = hash
    <<time_low::32, time_mid::16, version::4, time_hi::12, @variant10::2,
      clock_seq_hi::6, clock_seq_low::8, node::48>>
  end

  # Identify the UUID variant according to section 4.1.1 of RFC 4122.
  defp variant(<<1, 1, 1>>) do
    :reserved_future
  end
  defp variant(<<1, 1, _v>>) do
    :reserved_microsoft
  end
  defp variant(<<1, 0, _v>>) do
    :rfc4122
  end
  defp variant(<<0, _v::[2, binary]>>) do
    :reserved_ncs
  end
  defp variant(_) do
    raise ArgumentError, message: "Invalid argument; Not valid variant bits"
  end

end
