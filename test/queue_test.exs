defmodule QueueTest do
    use ExUnit.Case

    @doc """
    - Jobs that arrived first should be assigned first,
    unless it has a "urgent" flag, in which case it
    has a higher priority.

    In the first test jobs are assigned by the urgent 
    flag and in second test by order as there is no urgency

    - A job cannot be assigned to more than one agent at a time.

    In both tests it can be seen as there are 2 jobs with the 
    same skill type and only one agent, yet only one is assigned
    and that is controlled by the "available" flag, that is set
    to false once an agent receives a job.

    - An agent only receives a job whose type is contained
    among its secondary skill set if no job from its primary
    skill set is available. This rule takes precedence over 
    the "urgent" rule.

    In third test the job is only assigned for the secondary 
    skillset after there is no job of it's primary
  """

    test "assign job because of urgency" do
        agent = %{
            "id" => "123",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => []
        }

        job_1 = %{
            "id" => "1",
            "type" => "bills-questions",
            "urgent" => false
          }

        job_2 = %{
            "id" => "2",
            "type" => "bills-questions",
            "urgent" => true
        }  
        CreateOrUpdateQueue.insert_agents(agent)

        CreateOrUpdateQueue.insert_jobs(job_1)

        CreateOrUpdateQueue.insert_jobs(job_2)

        job_request = %{
            "agent_id" => "123"
          }
        ProcessJobRequest.process(job_request)

        Queue.dequeue()

        assert [%{"agent_id" => "123", "job_id" => "2"}] == Agents.get(:assigned_jobs)
    end

    test "assign job because of time entered" do
        agent = %{
            "id" => "123",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => []
        }

        job_1 = %{
            "id" => "1",
            "type" => "bills-questions",
            "urgent" => false
          }

        job_2 = %{
            "id" => "2",
            "type" => "bills-questions",
            "urgent" => false
        }  
        CreateOrUpdateQueue.insert_agents(agent)

        CreateOrUpdateQueue.insert_jobs(job_1)

        CreateOrUpdateQueue.insert_jobs(job_2)

        job_request = %{
            "agent_id" => "123"
          }
        ProcessJobRequest.process(job_request)

        Queue.dequeue()

        assert [%{"agent_id" => "123", "job_id" => "1"}] == Agents.get(:assigned_jobs)
    end

    test "only assign secondary skillset if no primary found" do
        agent = %{
            "id" => "123",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => ["blow-stones"]
        }

        job_1 = %{
            "id" => "1",
            "type" => "blow-stones",
            "urgent" => false
          }
        CreateOrUpdateQueue.insert_agents(agent)

        CreateOrUpdateQueue.insert_jobs(job_1)

        job_request = %{
            "agent_id" => "123"
          }
        ProcessJobRequest.process(job_request)

        Queue.dequeue()

        assert [%{"agent_id" => "123", "job_id" => "1"}] == Agents.get(:assigned_jobs)
    end

    test "type not found among agents skillset" do
        agent = %{
            "id" => "123",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => ["blow-stones"]
        }

        job_1 = %{
            "id" => "1",
            "type" => "blow-bricks",
            "urgent" => false
          }
        CreateOrUpdateQueue.insert_agents(agent)

        CreateOrUpdateQueue.insert_jobs(job_1)

        job_request = %{
            "agent_id" => "123"
          }
        ProcessJobRequest.process(job_request)

        Queue.dequeue()

        assert [] == Agents.get(:assigned_jobs)
    end

    test "start queue with jobs assigned" do

        Agents.start_link(:assigned_jobs, [%{
            "agent_id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
            "job_id" => "c0033410-981c-428a-954a-35dec05ef1d2"
          }])

        agent = %{
            "id" => "123",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => ["blow-stones"]
        }

        job_1 = %{
            "id" => "1",
            "type" => "blow-bricks",
            "urgent" => false
          }
        CreateOrUpdateQueue.insert_agents(agent)

        CreateOrUpdateQueue.insert_jobs(job_1)

        job_request = %{
            "agent_id" => "123"
          }
        ProcessJobRequest.process(job_request)

        Queue.dequeue()

        assert [%{"agent_id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260", "job_id" => "c0033410-981c-428a-954a-35dec05ef1d2"}] == Agents.get(:assigned_jobs)
    end
end