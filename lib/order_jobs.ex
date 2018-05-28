defmodule OrderJobs do

  def order_jobs(jobRequests) do
    Agents.map(:jobs, fn jobs -> Enum.sort(jobs, &sort_by_urgency_and_creation/2) end)

    jobRequests
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
end
