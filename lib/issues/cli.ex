defmodule Issues.CLI do
  # module attribute
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end up generating a table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  # handles h, help, -h, --help args
  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  #
  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
    # decoding the response got
    |> decode_response()
  end

  # no error response
  def decode_response({:ok, body}), do: body

  # incase of error
  def decode_response({:error, error}) do
    IO.puts("Error fetching data from Github: #{error["message"]}")

    System.halt(2)
  end

  @doc """
  'argv' can be -h or --help, which returns :help.
  Otherwise it is a github username, project name, and an optional number of entries to format
  OptionParser module allows definition and parsing of command-line options and conveniently handle arguments passed to a script
  parse will be a tuple which will contain a list(argv), another list with help which will be a boolean
  """

  # def parse_args(argv) do
  #   # OptionParser module allows definition and parsing of command-line options and conveniently handle arguments passed to a script
  #   # parse will be a tuple which will contain a list(argv), another list with help which will be a boolean
  #   parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

  #   case parse do
  #     # when a user enter help on command-line it returns help
  #     {[help: true], _, _} ->
  #       :help

  #     # if they enter a github user, project, and count; it returns just that
  #     {_, [user, project, count], _} ->
  #       {user, project, String.to_integer(count)}

  #     # without the count, the default count is set to the returned tuple
  #     {_, [user, project], _} ->
  #       {user, project, @default_count}
  #   end
  # end

  # Refactoring parse_args

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    # extracts a specific element from a collection. It takes two arguments: the collection to extract the element from and the index of the element to extract, one in this case.
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end
end
