defmodule CliTest do
  # ExUnit; an Elixir testing framework
  use ExUnit.Case
  # allows automatic testing and validation of code
  doctest Issues

  # imports the parse_args/1 function from the Issues.CLI module. The only: [parse_args: 1] option restricts the import to only the parse_args/1 function and not any other functions in the Issues.CLI module
  import Issues.CLI, only: [parse_args: 1, sort_into_descending_order: 1]

  # tests all use the basic assert macro that ExUnit provides
  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is default if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort in descending orders in the right way" do
    result = sort_into_descending_order(fake_created_list(["a", "b", "c"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{ c b a}
  end

  defp fake_created_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
