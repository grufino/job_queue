defmodule CreateOrUpdateQueue do
  def create_or_update_queue(%{"jobs" => jobs, "agents" => agents, "jobRequests" => jobRequests}) do
    insert_agents(agents)
    insert_jobs(jobs)

    jobRequests
  end

  def insert_jobs(jobs) when is_list(jobs) do
    jobs
    |> Enum.map(fn job -> Map.put(job, "created_at", DateTime.utc_now()) end)
    |> create_or_update_agent(:jobs)

    Agents.execute(:jobs, fn jobs -> Enum.sort(jobs, &sort_by_urgency_and_creation/2) end)
  end

  def insert_jobs(jobs) when is_map(jobs) do
    jobs =
    Map.put(jobs, "created_at", DateTime.utc_now())
    create_or_update_agent([jobs], :jobs)

    Agents.execute(:jobs, fn jobs -> Enum.sort(jobs, &sort_by_urgency_and_creation/2) end)
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

  def insert_agents(agents) when is_list(agents) do
    agents
    |> Enum.map(fn agent -> Map.put(agent, "available", false) end)
    |> create_or_update_agent(:agents)
  end

  def insert_agents(agents) when is_map(agents) do
    agents =
      Map.put(agents, "available", false)
    create_or_update_agent([agents], :agents)
  end

  def create_or_update_agent(list, agent_id) do
    with nil <- Process.whereis(agent_id) do
      Agents.start_link(agent_id, list)
    else
      _ -> update(list, agent_id)
    end
  end

  defp update(list, agent_id) do
    agent_list = Agents.get(agent_id)
    Enum.map(list, fn element ->
      element
      |> element_id_already_exists?(agent_list)
      |> put_if_not_exists(agent_id, element)
    end)
  end

  defp put_if_not_exists(true, _, _), do: nil

  defp put_if_not_exists(false, agent_id, element), do: Agents.put(agent_id, element)

  def element_id_already_exists?(element, agent_list) when is_list(agent_list) do
    agent_list
    |> Enum.map(&Map.fetch!(&1, "id"))
    |> Enum.member?(element["id"])
  end
end
