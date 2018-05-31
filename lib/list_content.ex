defmodule ContentHandler do

  def list(content) do
    content_map = %{"agents" => [],
                     "jobs" => [],
                     "jobRequests" => []}
    content
    |> List.foldl(content_map, &list_agent/2)
  end

  def list_agent(%{"new_agent" => agent}, acc) do
    acc
    |> Map.update!("agents", &(&1 ++ [agent]))
  end

  def list_agent(%{"new_job" => job}, acc) do
    acc
    |> Map.update!("jobs", &(&1 ++ [job]))
  end

  def list_agent(%{"job_request" => jobRequest}, acc) do
    acc
    |> Map.update!("jobRequests", &(&1 ++ [jobRequest]))
  end

end
