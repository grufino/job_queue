defmodule AgentsTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    Agents.start_link(:test_agent_1, [])
    assert Agents.get(:test_agent_1) == []

    Agents.put(:test_agent_1, "milk")
    assert Agents.get(:test_agent_1) == ["milk"]
  end

  test "delete value by key" do
    Agents.start_link(:test_agent_2, [])
    assert Agents.get(:test_agent_2) == []

    Agents.put(:test_agent_2, "milk")
    Agents.delete(:test_agent_2, "milk")
    assert Agents.get(:test_agent_2) == []
  end

  test "put value as last" do
    Agents.start_link(:test_agent_3, [])

    Agents.put_last(:test_agent_3, 1)
    Agents.put_last(:test_agent_3, 2)

    assert Agents.get(:test_agent_3) |> List.first() == 1
  end

  test "perform operation on all values (map)" do
    Agents.start_link(:test_agent_4, [])
    Agents.put(:test_agent_4, 4)
    Agents.put(:test_agent_4, 4)

    Agents.execute(:test_agent_4, fn jobs -> Enum.map(jobs, fn element -> element + 1 end) end)
    assert Agents.get(:test_agent_4) == [5,5]
  end

  test "check bucket size" do
    Agents.start_link(:test_agent_5, [])
    Agents.put(:test_agent_5, 4)
    Agents.put(:test_agent_5, 4)

    assert Agents.size(:test_agent_5) == 2
  end

  test "take values" do
    Agents.start_link(:test_agent_6, [])
    Agents.put(:test_agent_6, 4)
    Agents.put(:test_agent_6, 4)
    assert Agents.take(:test_agent_6) == 4
    assert Agents.take(:test_agent_6) == 4
    assert Agents.get(:test_agent_6) == []
  end
end
