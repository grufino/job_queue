defmodule CreateOrUpdateQueueTest do
  use ExUnit.Case

  def expected_map_pattern?(job_input, job_expected, keys_to_ignore) do
    Map.drop(job_input, keys_to_ignore) == job_expected
  end

  @doc """
    - You can assume the list of jobs passed 
    in is ordered by the time the they 
    have entered the system.

    In the first 4 tests it is possible to see how jobs are ordered
    when enters the program, but agents doesn't, this ordering is
    done everytime a new job or job list arrives.
  """

  test "create jobs unitarily test" do

    job_1 = %{
      "id" => "f26e890b-df8e-422e-a39c-7762aa0bac36",
      "type" => "rewards-question",
      "urgent" => true
    }

    job_2 = %{
      "id" => "123",
      "type" => "rewards-question",
      "urgent" => false
    }

    CreateOrUpdateQueue.insert_jobs(job_1)

    CreateOrUpdateQueue.insert_jobs(job_2)

    assert true == Agents.take(:jobs)
                  |> expected_map_pattern?(job_1, ["created_at"])

    assert true == Agents.take(:jobs)
                  |> expected_map_pattern?(job_2, ["created_at"])
    end

    test "create jobs array test" do

      job_1 = %{
        "id" => "f26e890b-df8e-422e-a39c-7762aa0bac36",
        "type" => "rewards-question",
        "urgent" => true
      }

      job_2 = %{
        "id" => "123",
        "type" => "rewards-question",
        "urgent" => false
      }

      job_list = [job_2, job_1]

      CreateOrUpdateQueue.insert_jobs(job_list)

      assert true == Agents.take(:jobs)
                    |> expected_map_pattern?(job_1, ["created_at"])

      assert true == Agents.take(:jobs)
                    |> expected_map_pattern?(job_2, ["created_at"])
      end

      test "create agents unitarily test" do

        agent_1 = %{
            "id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
            "name" => "BoJack Horseman",
            "primary_skillset" => ["bills-questions"],
            "secondary_skillset" => []
          }

        agent_2 = %{
            "id" => "ed0e23ef-6c2b-430c-9b90-cd4f1ff74c88",
            "name" => "Mr. Peanut Butter",
            "primary_skillset" => ["rewards-question"],
            "secondary_skillset" => ["bills-questions"]
          }

        CreateOrUpdateQueue.insert_agents(agent_1)

        CreateOrUpdateQueue.insert_agents(agent_2)

        assert true == Agents.take(:agents)
                      |> expected_map_pattern?(agent_2, ["available"])

        assert true == Agents.take(:agents)
                      |> expected_map_pattern?(agent_1, ["available"])
        end

        test "create agents array test" do

          agent_1 = %{
              "id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
              "name" => "BoJack Horseman",
              "primary_skillset" => ["bills-questions"],
              "secondary_skillset" => []
            }


          agent_2 = %{
              "id" => "ed0e23ef-6c2b-430c-9b90-cd4f1ff74c88",
              "name" => "Mr. Peanut Butter",
              "primary_skillset" => ["rewards-question"],
              "secondary_skillset" => ["bills-questions"]
            }

          agent_list = [agent_2, agent_1]

          CreateOrUpdateQueue.insert_agents(agent_list)

          assert true == Agents.take(:agents)
                      |> expected_map_pattern?(agent_2, ["available"])

          assert true == Agents.take(:agents)
                      |> expected_map_pattern?(agent_1, ["available"])
      end

      test "create custom agent" do
        CreateOrUpdateQueue.create_or_update_agent([%{"id" => 1},%{"id" => 2},%{"id" => 3}], :custom_agent)

        assert Agents.get(:custom_agent) == [%{"id" => 1},%{"id" => 2},%{"id" => 3}]
      end

      test "update custom agent" do
        CreateOrUpdateQueue.create_or_update_agent([%{"id" => 1},%{"id" => 2},%{"id" => 3}, %{"id" => 4}], :custom_agent)

        assert Agents.get(:custom_agent) == [%{"id" => 1},%{"id" => 2},%{"id" => 3}, %{"id" => 4}]
      end

      test "element id already exists in list" do
        assert true ==
          CreateOrUpdateQueue.element_id_already_exists?(%{"id" => 1}, [%{"id" => 1},%{"id" => 2},%{"id" => 3}])
      end

      test "element id doesnt exist in list" do
        assert false == 
          CreateOrUpdateQueue.element_id_already_exists?(%{"id" => 10}, [%{"id" => 1},%{"id" => 2},%{"id" => 3}])
      end
end
