defmodule GlobalMap do
  use GenServer

  # GenServer callbacks
  def start_link(initial_map \\ %{}) do
    GenServer.start_link(__MODULE__, initial_map, name: __MODULE__)
  end

  def init(initial_map) do
    {:ok, initial_map}
  end

  def handle_call(:get_map, _from, map) do
    {:reply, map, map}
  end

  def handle_call({:get, key}, _from, map) do
    {:reply, Map.get(map, key), map}
  end

  def handle_call({:update, key, value}, _from, map) do
    updated_map = Map.put(map, key, value)
    {:reply, :ok, updated_map}
  end
end
