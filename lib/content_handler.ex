defmodule ContentHandler do

  def parse_content(content) do
    content
    |> list()
  end

  def list(elements) do
    elements_map = %{"agents" => [],
                     "jobs" => [],
                     "jobRequests" => []}
    elements
    |> List.foldl(elements_map, &list_agent/2)
  end

  defp list_agent(%{"new_agent" => agent}, acc) do
    agent = Map.put(agent, "created_at", DateTime.utc_now())
            |> Map.put("available", nil)

    acc
    |> Map.update!("agents", &(&1 ++ [agent]))
  end

  defp list_agent(%{"new_job" => job}, acc) do
    job = Map.put(job, "created_at", DateTime.utc_now())

    acc
    |> Map.update!("jobs", &(&1 ++ [job]))
  end

  defp list_agent(%{"job_request" => jobRequest}, acc) do
    jobRequest = Map.put(jobRequest, "created_at", DateTime.utc_now())

    acc
    |> Map.update!("jobRequests", &(&1 ++ [jobRequest]))
  end

end
