defmodule CreateOrUpdateQueue do
  def create_or_update_queue(%{"jobs" => jobs, "agents" => agents, "jobRequests" => jobRequests}) do
    insert_agents(agents)
    insert_jobs(jobs)

    jobRequests
  end

  def insert_jobs(jobs) do
    create_or_update_agent(jobs, :jobs)
  end

  def insert_agents(agents) do
    create_or_update_agent(agents, :agents)
  end

  def create_or_update_agent(list, agent_id) do
    with nil <- Process.whereis(agent_id) do
      Agents.start_link(agent_id, list)
    else
      _ -> update(list, agent_id)
    end
  end

  defp update(list, agent_id) do
    Enum.map(list, fn element ->
      element
      |> element_id_already_exists?(agent_id)
      |> put_if_not_exists(agent_id, element)
    end)
  end

  defp put_if_not_exists(true, _, _), do: nil

  defp put_if_not_exists(false, agent_id, element), do: Agents.put(agent_id, element)

  defp element_id_already_exists?(element, agent_id) do
    Agents.get(agent_id)
    |> Enum.map(&Map.fetch!(&1, "id"))
    |> Enum.member?(element["id"])
   end
end
