defmodule ProcessJobRequest do
  def process(jobRequest) do
    Agents.execute(:agents, fn agents -> set_agents_available(agents, jobRequest) end)
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
