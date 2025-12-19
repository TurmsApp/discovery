defmodule Turms.Cache.Sdp do
  @moduledoc """
  An ETS based cache for user's SDP.
  """

  use GenServer

  @table :sdp_locale_cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    :ets.new(@table, [
      :named_table,
      :set,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, %{}}
  end

  @doc """
  Retrieve a cached SDP with its key.
  """
  def get(key) do
    case :ets.lookup(@table, key) do
      [value | _] -> check_freshness(value)
      [] -> nil
    end
  end

  defp check_freshness({key, value, expiration}) do
    cond do
      expiration > :os.system_time(:seconds) -> value
      :else ->
        :ets.delete(@table, key)
        nil
    end
  end

  @doc """
  Set a value with its key on SDP cache.
  """
  def set(key, value, opts \\ []) do
    ttl = Keyword.get(opts, :ttl, 3600)
    expiration = :os.system_time(:seconds) + ttl
    :ets.insert(@table, {key, value, expiration})
    value
  end
end
