defmodule FolderHandlerTest do
    use ExUnit.Case

    test "test empty on unexistent file" do
        assert [] == FolderHandler.readFolder("/")
    end

    test "test specific file input" do
        path = File.cwd!
               |> fn project_path -> project_path <> "/input/sample-input.json.txt" end.()

        assert true == FolderHandler.readFolder(path)
                        |> List.first
                        |> is_list
    end
end