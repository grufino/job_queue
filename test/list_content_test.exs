defmodule ListContentTest do
  use ExUnit.Case

  test "reads input agent" do
    content = [
      %{
        "new_agent" => %{
          "id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
          "name" => "BoJack Horseman",
          "primary_skillset" => ["bills-questions"],
          "secondary_skillset" => []
        }
      }
    ]

    expected_output = %{
      "agents" => [
        %{
          "id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
          "name" => "BoJack Horseman",
          "primary_skillset" => ["bills-questions"],
          "secondary_skillset" => []
        }
      ],
      "jobRequests" => [],
      "jobs" => []
    }

    assert expected_output == ListContent.list(content)
  end

  test "reads input job" do
    content = [
      %{
        "new_job" => %{
          "id" => "690de6bc-163c-4345-bf6f-25dd0c58e864",
          "type" => "bills-questions",
          "urgent" => false
        }
      }
    ]

    expected_output = %{
      "jobs" => [
        %{
          "id" => "690de6bc-163c-4345-bf6f-25dd0c58e864",
          "type" => "bills-questions",
          "urgent" => false
        }
      ],
      "agents" => [],
      "jobRequests" => []
    }

    assert expected_output == ListContent.list(content)
  end

  test "reads input jobRequest" do
    content = [
      %{
        "job_request" => %{
          "agent_id" => "ed0e23ef-6c2b-430c-9b90-cd4f1ff74c88"
        }
      }
    ]


    expected_output = %{
      "jobRequests" => [
        %{
          "agent_id" => "ed0e23ef-6c2b-430c-9b90-cd4f1ff74c88"
        }
    ],
      "agents" => [],
      "jobs" => []
    }

    assert expected_output == ListContent.list(content)
  end

  test "reads input one of each" do

    expected_output =
    %{
      "agents" => [
        %{
          "id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
          "name" => "BoJack Horseman",
          "primary_skillset" => ["bills-questions"],
          "secondary_skillset" => []
        }
      ],
      "jobRequests" => [
        %{"agent_id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260"}
      ],
      "jobs" => [
        %{
          "id" => "c0033410-981c-428a-954a-35dec05ef1d2",
          "type" => "bills-questions",
          "urgent" => true
        }
      ]
    }

    input =
    [
      %{
        "new_agent" => %{
          "id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",
          "name" => "BoJack Horseman",
          "primary_skillset" => ["bills-questions"],
          "secondary_skillset" => []
        }
      },
      %{
        "new_job" => %{
          "id" => "c0033410-981c-428a-954a-35dec05ef1d2",
          "type" => "bills-questions",
          "urgent" => true
        }
      },
      %{
        "job_request" => %{
          "agent_id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260"
        }
      }
    ]

     assert ListContent.list(input) == expected_output
  end

  test "list agent" do
    assert %{"agents" => ["gabriel"]} ==
         ListContent.list_agent(%{"new_agent" => "gabriel"}, %{"agents" => []})
 end

 test "list job" do
     assert %{"jobs" => ["gabriel"]} ==
          ListContent.list_agent(%{"new_job" => "gabriel"}, %{"jobs" => []})
  end

  test "list job request" do
     assert %{"jobRequests" => ["gabriel"]} ==
          ListContent.list_agent(%{"job_request" => "gabriel"}, %{"jobRequests" => []})
  end
end
