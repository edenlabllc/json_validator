defmodule JsonValidator.Errors.DuplicatedKeyError do
  @moduledoc false

  @type t :: %__MODULE__{
          message: binary(),
          key: binary(),
          path: list(binary())
        }

  @enforce_keys [:message, :key, :path]

  defstruct [:message, :path, :key]

  def new(key, path) do
    rendered_path = render_path(path)

    %__MODULE__{
      message: "Duplicated key '#{key}' at #{rendered_path}",
      path: rendered_path,
      key: key
    }
  end

  def render(%__MODULE__{} = error) do
    {%{
       description: error.message,
       params: [error.key],
       rule: :invalid
     }, error.path}
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
