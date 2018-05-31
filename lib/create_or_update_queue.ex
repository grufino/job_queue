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
  end

  def insert_jobs(jobs) when is_map(jobs) do
    jobs =
    Map.put(jobs, "created_at", DateTime.utc_now())
    create_or_update_agent([jobs], :jobs)
  end

  def insert_agents(agents) when is_list(agents) do
    agents
    |> Enum.map(fn agent -> Map.put(agent, "available", nil) end)
    |> create_or_update_agent(:agents)
  end

  def insert_agents(agents) when is_map(agents) do
    agents =
      Map.put(agents, "available", nil)
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

  defp element_id_already_exists?(element, agent_list) when is_list(agent_list) do
    agent_list
    |> Enum.map(&Map.fetch!(&1, "id"))
    |> Enum.member?(element["id"])
  end

  defp element_id_already_exists?(element, agent_list) when is_map(agent_list) do
    agent_list
    |> Map.fetch!("id")
    |> fn agent -> agent == element end.()
  end
end
