defmodule FolderHandler do
  require Logger

  def readFolder(path) do
    Path.wildcard(path)
    |> Enum.map(&read_and_decode/1)
    |> Enum.filter(fn file -> is_list(file) end)
  end

  def read_and_decode(file) do
    with {:ok, fileContent} <- File.read(file),
         {:ok, parsedContent} <- Poison.decode(fileContent) do
          parsedContent
    else
          {:error, error} -> Logger.error("Unparseable file: #{file}, error: #{inspect(error)}")
    end
  end
end
