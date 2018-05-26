defmodule AgentsTest do
  use ExUnit.Case, async: true

  setup do
    Agents.start_link(:test_agent, [])
  end

  test "stores values by key" do
    assert Agents.get(:test_agent, "milk") == nil

    Agents.put(:test_agent, "milk", 3)
    assert Agents.get(:test_agent, "milk") == 3
  end

  test "delete value by key" do
    assert Agents.get(:test_agent, "milk") == nil

    Agents.put(:test_agent, "milk", 3)
    Agents.delete(:test_agent, "milk")
    assert Agents.get(:test_agent, "milk") == nil
  end
end
