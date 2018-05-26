defmodule PrepareQueue do

  def order_jobs_and_set_agents_available(jobRequests) do

    Agents.map(:jobs, fn jobs -> Enum.sort(jobs, &sort_by_urgency_and_creation/2) end)

    Agents.map(:agents, fn agents -> set_agents_available(agents, jobRequests) end)

  end

  def sort_by_urgency_and_creation(job_1, job_2) do
    cond do
      job_1["urgent"] && job_2["urgent"] ->
        job_1["created_at"] < job_2["created_at"]
      !job_1["urgent"] && !job_2["urgent"] ->
        job_1["created_at"] < job_2["created_at"]
      job_1["urgent"] -> true
      true -> false
    end
  end

  def set_agents_available(agents, job_requests) do
    request_agent_ids =
      Enum.map(job_requests, fn request -> request["agent_id"] end)
    agents
    |> Enum.map(fn agent ->
          set_agent_job_request(request_agent_ids, agent)
      end)
  end

  def set_agent_job_request(request_agent_ids, agent) do
    with true <- Enum.member?(request_agent_ids, agent["id"]) do
      Map.replace!(agent, "available", true)
    else
      false -> agent
    end
  end
end
