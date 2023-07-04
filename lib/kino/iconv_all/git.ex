defmodule Kino.IconvAll.Git do
  @moduledoc """
  A Kino wrapper for `IconvAll.Git` which lets you configure iconv for a Git
  repository.
  """

  alias Kino.Input

  # FIXME: Add a proper list of encodings supported by iconv
  @supported_encodings ["shift_jis", "utf-8", "euc-jp"]

  @doc """
  Initialize a configuration interface.

  >>> config = Kino.IconvAll.Git.configure("/home/user/sample-repo")
  """
  def configure(repo) do
    %{
      repo: repo,
      pattern: Input.text("Glob pattern"),
      branch:
        Input.select(
          "Branch",
          branches(repo)
          |> Enum.filter(&original_branch?(&1))
          |> Enum.map(&{&1, &1})
        ),
      source_encoding:
        Input.select(
          "Source encoding",
          Enum.map(@supported_encodings, &{&1, &1})
        ),
      target_encoding:
        Input.select(
          "Target encoding",
          Enum.map(@supported_encodings, &{&1, &1})
        ),
      discard: Input.checkbox("Omit invalid characters instead of failing"),
      xml_support: Input.checkbox("Enable processing of XML (*.xml)", default: true)
    }
  end

  @doc """
  Render the interface created using  in the Livebook notebook.

  >>> Kino.IconvAll.Git.render(config)
  """
  def render(config) do
    Kino.Layout.grid([
      config.pattern,
      config.branch,
      config.source_encoding,
      config.target_encoding,
      config.discard,
      config.xml_support
    ])
  end

  @doc """
  Perform conversion and return the path to the resulting working tree.

  {:ok, path} = Kino.IconvAll.Git.run(config)
  """
  def run(config) do
    IconvAll.Git.make_worktree(%{
      repo: config.repo,
      branch: Input.read(config.branch),
      pattern: Input.read(config.pattern),
      source_encoding: Input.read(config.source_encoding),
      target_encoding: Input.read(config.target_encoding),
      discard: Input.read(config.discard),
      xml_support: Input.read(config.xml_support)
    })
  end

  @spec original_branch?(String.t()) :: bool()
  defp original_branch?(branch) do
    !String.starts_with?(branch, "iconv/")
  end

  @spec branches(Path.t()) :: [String.t()]
  defp branches(repo) do
    with {out, 0} <-
           System.cmd(
             "git",
             [
               "branch",
               "--list",
               "--all",
               "--format=%(refname:short)"
             ],
             cd: repo
           ),
         do: String.split(out, "\n") |> Enum.filter(&(&1 != ""))
  end
end
