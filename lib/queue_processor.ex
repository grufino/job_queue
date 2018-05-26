defmodule QueueProcessor do
  def process_queue() do
    FolderHandler.readFolder()
    |> Enum.map(&ContentHandler.parse_content/1)
    |> Enum.map(&CreateOrUpdateQueue.create_or_update_queue/1)
    |> Enum.map(&PrepareQueue.order_jobs_and_set_agents_available/1)

    Queue.dequeue()
    IO.puts "Agents history: #{inspect(Agents.get(:agents))}"
    IO.puts "Jobs assigned history: #{inspect(Agents.get(:assigned_jobs))}"
  end
end
