defmodule QueueProcessor do

  def process_queue(absolute_path) do
    absolute_path
    |> FolderHandler.readFolder()
    |> Enum.map(&ListContent.list/1)
    |> Enum.map(&CreateOrUpdateQueue.create_or_update_queue/1)
    |> Enum.map(&ProcessJobRequest.process/1)

    Queue.dequeue()
    
    WriteOutput.write(Agents.get(:assigned_jobs), File.cwd!)
  end

  def process_queue() do
    project_path = File.cwd!

    project_path <> "/input/*"
    |> process_queue()
  end
end
