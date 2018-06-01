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
  Puts the `element` in the `bucket` at first position.
  """
  def put(bucket, element) do
    Agent.update(bucket, &[element | &1])
  end

  @doc """
  Puts the `element` in the `bucket` at last position.
  """
  def put_last(bucket, element) do
    Agent.update(bucket, &(&1 ++ [element]))
  end

  @doc """
  Deletes the `element` from the `bucket`.
  """
  def delete(bucket, element) do
    Agent.update(bucket, &List.delete(&1, element))
  end

  @doc """
  Runs a `function` on the `bucket`
  """
  def execute(bucket, operation) do
    Agent.update(bucket, &operation.(&1))
  end

  @doc """
  Returns de current `size` of the `bucket`
  """
  def size(bucket) do
    Agent.get(bucket, &Enum.count(&1))
  end

  @doc """
  Returns one element by it's id
  """
  def get_by_id(bucket, id) do
    Agent.get(bucket, &Enum.filter(&1, fn element -> element["id"] == id end) |> List.first())
  end

  @doc """
  Returns true if the id exists inside the bucket and false if not
  """
  def id_exists?(bucket, id) do
    Agent.get(bucket, &Enum.map(&1, fn element -> element["id"] end) |> Enum.member?(id))
  end
end
