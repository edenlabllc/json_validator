defmodule JsonValidator.Errors.DuplicatedKeyError do
  @moduledoc false

  @type t :: %__MODULE__{
          message: binary(),
          key: binary(),
          path: list(binary())
        }

  @enforce_keys [:message, :key, :path]

  defstruct [:message, :key, :path]

  def new(key, path) do
    %__MODULE__{
      message: "Duplicated key #{key} at #{render_path(path)}",
      path: Enum.map(path, &to_string/1),
      key: key
    }
  end

  defp render_path(path) do
    ["$" | path]
    |> Enum.map(fn
      part when is_integer(part) -> "[#{part}]"
      part -> part
    end)
    |> Enum.join(".")
  end
end
