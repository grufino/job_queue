defmodule QueueProcessor do
  def process_queue() do
    FolderHandler.readFolder()
    |> Enum.map(&ContentHandler.parse_content/1)
    |> Enum.map(&CreateOrUpdateQueue.create_or_update_queue/1)
    |> Enum.map(&OrderJobs.order_jobs/1)
    |> Enum.map(&ProcessJobRequest.process/1)

    Queue.dequeue()
    Agents.get(:assigned_jobs)
  end
end
