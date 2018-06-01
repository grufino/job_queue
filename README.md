# JOB_QUEUE

Simple queue to get "jobs" executed and generate assigned jobs based on "agents", which are marked available via job requests when they are ready to get a new job.

## Architectural choices and Project Overview

- Please don't confuse Agent, elixir library for holding state with the entity Agent introduced by the problem, they are different things and I talk about both in here.

- As a Queue, I think the most important decision of the project was how to control State, and Elixir provides great tools for that, which are called GenServer (general servers), this solution used Agent, which is a built-in library based on GenServer, it means that it doesn't do everything a GenServer can do, but it abstracts all the most common tasks, which is just what we needed here. 

- QueueProcessor is the module that wraps all other modules to process a single file, parse the content, add the new agents, jobs, set agents avaiable based on the job requests and process jobs. But it doesn't have to be used that way, the project was separated in a way that you can access, for example module `CreateOrUpdateQueue` module to insert jobs or agents totally separate from the whole flow. Let's say you want to plug in a RESTful API to send you jobs and another one to send agents and job requests? no problem, just add the right functions to the controller and you got it, the agent (state holder) will be created if needed, the queue can be processed through it's module whenever you're done adding.

- The project has a big test coverage (run `mix test --cover` for statistics) and each rule passed on the problem have a specific test to validate it.

- An Agent (state holder) was created for assigned jobs also just to keep history, but it would be nice to have it elsewhere if the project was to receive lots of data traffic.

- The Agent abstraction was built the most generalistic way possible to support all types of operations on lists (some still even unused), but it is very flexible because of this.

## Installation

- For being able to run Elixir programs, you need to have Erlang/OTP installed, which is the Erlang's virtual machine, as Elixir runs on top of it, and then install Elixir from your favorite package manager (on unix-like environments), eg. on MacOs High Sierra the command "brew install elixir" installs the whole stack (with Erlang/OTP if you don't have it yet).

- For the project set up all you need is to clone project from github: `git clone https://bitbucket.org/grufino/job_queue/` and then run `mix deps.get` at the project's root to download the project's dependencies.

## Execution

- After installing, it is possible to run the given input file(s) by QueueProcessor module via Elixir CLI:
`job_queue git:(master) iex -S mix`
`Erlang/OTP 20 [erts-9.2.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]`

`Interactive Elixir (1.6.1) - press Ctrl+C to exit (type h() ENTER for help)`
`iex(1)> QueueProcessor.process_queue()`

`14:26:05.867 [info]  Starting dequeue with no jobs assigned`

`14:26:05.867 [info]  job c0033410-981c-428a-954a-35dec05ef1d2 assigned to agent 8ab86c18-3fae-4804-bfd9-c3d6e8f66260`

`14:26:05.867 [info]  job f26e890b-df8e-422e-a39c-7762aa0bac36 assigned to agent ed0e23ef-6c2b-430c-9b90-cd4f1ff74c88`
`[`
`  %{`
`    "agent_id" => "8ab86c18-3fae-4804-bfd9-c3d6e8f66260",`
`    "job_id" => "c0033410-981c-428a-954a-35dec05ef1d2"`
`  },`
`  %{`
`    "agent_id" => "ed0e23ef-6c2b-430c-9b90-cd4f1ff74c88",`
`    "job_id" => "f26e890b-df8e-422e-a39c-7762aa0bac36"`
`  }`
`]`