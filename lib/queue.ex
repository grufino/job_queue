defmodule Queue do
  require Logger

  def dequeue() do
    Enum.map(Agents.get(:jobs), fn job -> dequeue_job(job) end)
  end

  def dequeue_job(job) do
    Agents.get(:agents)
    |> Enum.map(fn agent -> assign_if_elegible(agent, job) end)
    |> Enum.filter(& !is_nil(&1))
  end

  def assign_if_elegible(agent, job) do
    cond do
      agent_is_available?(agent) && agent_has_skill?(agent, job) -> assign_job_to_agent(agent, job)
      true -> assign_if_has_second_skill(agent, job)
    end
  end

  def assign_if_has_second_skill(agent, job) do
    cond do
      agent_is_available?(agent) && agent_has_second_skill?(agent, job) -> assign_job_to_agent(agent, job)
      true -> nil
    end
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
        "agent_id" => agent["id"],
        "created_at" => DateTime.utc_now()
      })
  end

  def create_or_update_assigned_jobs(%{} = job_assignment) do
    with nil <- Process.whereis(:assigned_jobs) do
      Agents.start_link(:assigned_jobs, [job_assignment])
    else
      _ -> Agents.put(:assigned_jobs, job_assignment)
    end
  end
end
