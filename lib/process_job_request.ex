defmodule ProcessJobRequest do
  def process(job_request) when is_list(job_request) do
    Agents.execute(:agents, fn agents -> set_agents_available(agents, job_request) end)
  end

  def process(job_request) when is_map(job_request) do
    Agents.execute(:agents, fn agents -> set_agents_available(agents, [job_request]) end)
  end

  def set_agents_available(agents, job_request) do
    request_agent_ids =
      Enum.map(job_request, fn request -> request["agent_id"] end)
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
