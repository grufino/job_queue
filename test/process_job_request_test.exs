defmodule ProcessJobRequestTest do
    use ExUnit.Case

    test "process request and set agent available" do
        agent_1 = %{
            "id" => "123",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => []
        }

        agent_2 = %{
            "id" => "456",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => []
        }
        CreateOrUpdateQueue.insert_agents(agent_1)

        CreateOrUpdateQueue.insert_agents(agent_2)

        job_request_1 = %{
            "agent_id" => "123"
          }

        job_request_2 = %{
            "agent_id" => "456"
        }  
        ProcessJobRequest.process(job_request_1)

        ProcessJobRequest.process(job_request_2)

        assert [
            %{
              "available" => true,
              "id" => "456",
              "name" => "BoJack Horseman",
              "primary_skillset" => ["bills-questions"],
              "secondary_skillset" => []
            },
            %{
              "available" => true,
              "id" => "123",
              "name" => "BoJack Horseman",
              "primary_skillset" => ["bills-questions"],
              "secondary_skillset" => []
            }
          ] == Agents.get(:agents)
    end

    test "process request and do nothing" do
        agent_1 = %{
            "id" => "123456",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => []
        }
        CreateOrUpdateQueue.insert_agents(agent_1)

        job_request_1 = %{
            "agent_id" => "123"
          }
        ProcessJobRequest.process(job_request_1)

        assert [
            %{
              "available" => false,
              "id" => "123456",
              "name" => "BoJack Horseman",
              "primary_skillset" => ["bills-questions"],
              "secondary_skillset" => []
            }
          ] == Agents.get(:agents)
    end
end