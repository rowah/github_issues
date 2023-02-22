defmodule Issues.CLI do
  # module attribute
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end up generating a table of the last _n_ issues in a github project
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  'argv' can be -h or --help, which returns :help.
  Otherwise it is a github username, project name, and an optional number of entries to format
  """

  def parse_args(argv) do
    # OptionParser module allows definition and parsing of command-line options and conveniently handle arguments passed to a script
    # parse will be a tuple which will contain a list(argv), another list with help which will be a boolean
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      # when a user enter help on command-line it returns help
      {[help: true], _, _} ->
        :help

      # if they enter a github user, project, and count; it returns just that
      {_, [user, project, count], _} ->
        {user, project, count}

      # without the count, the default count is set to the returned tuple
      {_, [user, project], _} ->
        {user, project, @default_count}
    end
  end
end
