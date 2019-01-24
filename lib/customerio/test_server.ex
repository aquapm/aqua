defmodule Customerio.TestServer do
  use GenServer
  
  defp via_tuple(args) do
    # TODO: Change name resolution here!
    {:via, Registry, {Customerio.TestServer.Registry, args}}
  end
    
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: via_tuple(args))
  end
  
  ### API
  
  def get(name) do
    GenServer.call(via_tuple(name), :get)
  end

  def set(name, data) do
    GenServer.cast(via_tuple(name), {:set, data})
  end
  
  ### Callbacks
  
  @impl GenServer
  def handle_call(:get, _from, state) do
    # TODO: Do some usefull job here
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:set, data}, state) do
    # TODO: Do some usefull job here
    {:noreply, state, data}
  end
end
