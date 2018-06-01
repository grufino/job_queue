defmodule Queue do
  require Logger

  def dequeue() do
    case Process.whereis(:assigned_jobs) do
      nil -> Agents.start_link(:assigned_jobs, [])
              Logger.info("Starting dequeue with no jobs assigned")
      _ -> Logger.info("Starting dequeue with jobs assigned #{inspect(Agents.get(:assigned_jobs))}")
    end

    Enum.map(Agents.get(:jobs), fn job -> dequeue_job(job) end)
  end

  def dequeue_job(job) do
    Agents.get(:agents)
    |> Enum.filter(&agent_is_available?/1)
    |> Enum.map(fn agent -> assign_if_elegible(agent, job) end)
    |> Enum.map(&assign_if_has_second_skill/1)
  end

  def assign_if_elegible(agent, job) do
    with true <- agent_has_skill?(agent, job) && Agents.id_exists?(:jobs, job["id"]) do
      assign_job_to_agent(agent, job)
      {false, agent, job}
    else
      false -> {true, agent, job}
    end
  end

  def assign_if_has_second_skill({true, agent, job}) do
    with true <- agent_has_second_skill?(agent, job) && Agents.id_exists?(:jobs, job["id"]) do
       assign_job_to_agent(agent, job)
    else
      false -> nil
    end
  end

  def assign_if_has_second_skill({false, _, _}) do
    nil
  end

  def agent_has_skill?(agent, job) do
      Enum.member?(agent["primary_skillset"], job["type"])
  end

  def agent_has_second_skill?(agent, job) do
    Enum.member?(agent["secondary_skillset"], job["type"])
  end

  def agent_is_available?(agent) do
    agent["available"]
  end

  def assign_job_to_agent(agent, job) do
    Agents.delete(:agents, agent)
    Agents.delete(:jobs, job)

    Map.replace!(agent, "available", false)
    |> (&Agents.put(:agents, &1)).()

    create_or_update_assigned_jobs(
    %{
        "job_id" => job["id"],
        "agent_id" => agent["id"]
      })

    Logger.info("job #{job["id"]} assigned to agent #{agent["id"]}")
  end

  def create_or_update_assigned_jobs(%{} = job_assignment) do
    with nil <- Process.whereis(:assigned_jobs) do
      Agents.start_link(:assigned_jobs, [job_assignment])
    else
      _ -> Agents.put_last(:assigned_jobs, job_assignment)
    end
  end
end
