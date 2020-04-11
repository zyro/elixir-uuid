defmodule UUID.Node do
  @moduledoc false

  use GenServer

  @persistent_term_available Code.ensure_loaded(:persistent_term) == {:module, :persistent_term}

  def start_link([] = _options) do
    GenServer.start_link(__MODULE__, :no_state)
  end

  if @persistent_term_available do
    def get() do
      :persistent_term.get(:__uuid_mac_address__)
    rescue
      _ -> uuid1_node()
    end
  else
    def get() do
      case :ets.lookup(__MODULE__, :__uuid_mac_address__) do
        [] -> uuid1_node()
        [{_key, node}] -> node
      end
    end
  end

  ## Callbacks

  @impl true
  def init(:no_state) do
    _ = start_key_value_store()
    _ = schedule_next_refresh()
    _ = store_updated(uuid1_node())
    {:ok, :no_state}
  end

  @impl true
  def handle_info(:refresh, state) do
    _ = store_updated(uuid1_node())
    {:noreply, state}
  end

  ## Helpers

  defp schedule_next_refresh() do
    Process.send_after(self(), :refresh, 10_000)
  end

  if @persistent_term_available do
    defp start_key_value_store(), do: IO.inspect(:ok)
  else
    defp start_key_value_store() do
      :ets.new(__MODULE__, [:public, :named_table, read_concurrency: true])
    end
  end

  if @persistent_term_available do
    defp store_updated(value) do
      :persistent_term.put(:__uuid_mac_address__, value)
    end
  else
    defp store_updated(value) do
      :ets.insert(__MODULE__, {:__uuid_mac_address__, value})
    end
  end

  # Get local IEEE 802 (MAC) address, or a random node id if it can't be found.
  defp uuid1_node() do
    {:ok, ifs0} = :inet.getifaddrs()
    uuid1_node(ifs0)
  end

  defp uuid1_node([{_if_name, if_config} | rest]) do
    case :lists.keyfind(:hwaddr, 1, if_config) do
      false ->
        uuid1_node(rest)

      {:hwaddr, hw_addr} ->
        if length(hw_addr) != 6 or Enum.all?(hw_addr, fn n -> n == 0 end) do
          uuid1_node(rest)
        else
          :erlang.list_to_binary(hw_addr)
        end
    end
  end

  defp uuid1_node(_) do
    <<rnd_hi::7, _::1, rnd_low::40>> = :crypto.strong_rand_bytes(6)
    <<rnd_hi::7, 1::1, rnd_low::40>>
  end
end
