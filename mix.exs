defmodule JobQueue.MixProject do
  use Mix.Project

  def project do
    [
      app: :job_queue,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [
        tool: Coverex.Task
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      test_coverage: [tool: Coverex.Task]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:file_system, "~> 0.2"},
      {:poison, "~> 3.1"},
      {:coverex, "~> 1.4.10", only: :test}
    ]
  end
end
