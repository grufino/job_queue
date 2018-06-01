defmodule WriteOutput do

    def write(assigned_jobs, project_path) do
        file_path = "#{project_path}/output/job_queue_output_#{DateTime.to_string(DateTime.utc_now())}.txt"

        parsed_jobs = Poison.encode!(assigned_jobs)

        File.write(file_path, parsed_jobs, [:append])
    end
end