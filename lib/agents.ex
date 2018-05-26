defmodule Agents do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(agent_name, list) do
    Agent.start_link(fn -> list end, name: agent_name)
  end

  @doc """
  Takes the first value from the `bucket`.
  """
  def take(bucket) do
    Agent.get_and_update(bucket, fn list -> {list |> List.first(), Enum.drop(list, 1)} end)
  end

   @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket) do
    Agent.get(bucket, fn list -> list end)
  end

  @doc """
  Puts the `element` in the `bucket`.
  """
  def put(bucket, element) do
    Agent.update(bucket, &List.insert_at(&1, 0, element))
  end

  @doc """
  Deletes the `element` from the `bucket`.
  """
  def delete(bucket, element) do
    Agent.update(bucket, &List.delete(&1, element))
  end

  def size(bucket) do
    Agent.get(bucket, &Enum.count(&1))
  end
end
