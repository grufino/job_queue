defmodule QueueProcessor do
  def process_queue() do
    File.cwd!
    |> fn project_path -> project_path <> "/input/*" end.()
    |> FolderHandler.readFolder()
    |> Enum.map(&ListContent.list/1)
    |> Enum.map(&CreateOrUpdateQueue.create_or_update_queue/1)
    |> Enum.map(&ProcessJobRequest.process/1)

    Queue.dequeue()
    Agents.get(:assigned_jobs)
  end
end
