defmodule Aoc2023.Util.Memo do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def stop do
    Agent.stop(__MODULE__)
  end

  def get(inputs) do
    Agent.get(__MODULE__, fn cache ->
      Map.get(cache, inputs, nil)
    end)
  end

  def update(inputs, value) do
    Agent.update(__MODULE__, fn cache ->
      Map.put(cache, inputs, value)
    end)
  end
end
