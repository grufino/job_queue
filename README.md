# JOB_QUEUE

Simple queue to get "jobs" executed and generate assigned jobs based on "agents", which are marked available via job requests when they are ready to get a new job.

## Installation

- For being able to run Elixir programs, you need to have Erlang/OTP installed, which is the Erlang's virtual machine, as Elixir runs on top of it, and then install Elixir from your favorite package manager (on unix-like environments), eg. on MacOs High Sierra the command "brew install elixir" installs the whole stack (with Erlang/OTP if you don't have it yet).

- For the project set up all you need it is to run `mix deps.get` and then `iex -S mix` to activate Elixir's project CLI where you can run any public function of the project.

## Architectural choices and Project Overview

- Please don't confuse Agent, elixir library for holding state with the entity Agent introduced by the problem, they are different things and I talk about both in here.

- As a Queue, I think the most important decision of the project was how to control State, and Elixir provides great tools for that, which are called GenServer (general servers), this solution used Agent, which is a built-in library based on GenServer, it means that it doesn't do everything a GenServer can do, but it abstracts all the most common tasks, which is just what we needed here. 

- QueueProcessor is the module that wraps all other modules to process a single file, parse the content, add the new agents, jobs, set agents avaiable based on the job requests and process jobs. But it doesn't have to be used that way, the project was separated in a way that you can access, for example module `CreateOrUpdateQueue` module to insert jobs or agents totally separate from the whole flow. Let's say you want to plug in a RESTful API to send you jobs and another one to send agents and job requests? no problem, just add the right functions to the controller and you got it, the agent (state holder) will be created if needed, the queue can be processed through it's module whenever you're done adding.

- The project has a big test coverage (run `mix test --cover` for statistics) and each rule passed on the problem have a specific test to validate it.

- An Agent (state holder) was created for assigned jobs also just to keep history, but it would be nice to have it elsewhere if the project was to receive lots of data traffic.

- The Agent abstraction was built the most generalistic way possible to support all types of operations on lists (some still even unused), but it is very flexible because of this.
