defmodule QueueProcessor do
  def process_queue() do
    FolderHandler.readFolder()
    |> Enum.map(&ContentHandler.parse_content/1)
    |> Enum.map(&PrepareQueue.order_jobs_by_priority_and_created_at/1)
    |> Enum.map(&PrepareQueue.create_or_update_queue/1)

    Queue.dequeue()

    IO.puts "Jobs assigned history: #{inspect(Agents.get(:assigned_jobs))}"
  end
end
