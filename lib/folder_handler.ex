defmodule FolderHandler do
  require Logger

  def readFolder do
    Path.wildcard("/Users/cgx-grufino/file_queue/input/*")
    |> Enum.map(&read_and_decode/1)
    |> Enum.filter(fn file -> is_list(file) end)
  end

  defp read_and_decode(file) do
    with {:ok, fileContent} <- File.read(file),
         {:ok, parsedContent} <- Poison.decode(fileContent) do
          parsedContent
    else
          {:error, error} -> Logger.error("Unparseable file: #{file}, error: #{inspect(error)}")
    end
  end
end
