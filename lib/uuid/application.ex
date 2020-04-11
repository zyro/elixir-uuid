defmodule UUID.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Supervisor.start_link([UUID.Node], strategy: :one_for_one)
  end
end
