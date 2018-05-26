defmodule PrepareQueue do

  def order_jobs_by_priority_and_created_at(queue) do
    ordered_jobs =
      queue["jobs"]
      |> Enum.sort(&sort_rules/2)

    agents_availability =
      queue["agents"]
      |> set_agents_available(queue["jobRequests"])

    %{"agents" => agents_availability, "jobs" => ordered_jobs}
  end

  def sort_rules(job_1, job_2) do
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

  def create_or_update_queue(%{"agents" => agents, "jobs" => jobs}) do
    case Process.whereis(:agents) do
      nil -> Agents.start_link(:agents, agents)
      _ -> Enum.map(agents, fn agent -> Agents.put(:agents, agent) end)
    end

    case Process.whereis(:jobs) do
      nil -> Agents.start_link(:jobs, jobs)
      _ -> Enum.map(jobs, fn job -> Agents.put(:jobs, job) end)
    end

    case Process.whereis(:job_assigned) do
      nil -> Agents.start_link(:assigned_jobs, [])
      _ -> nil
    end
  end
end
