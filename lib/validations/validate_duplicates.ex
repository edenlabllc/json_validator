defmodule JsonValidator.Validations.ValidateDuplicates do
  @moduledoc """
  Validates JSON for duplicated keys.
  """

  alias Jason.OrderedObject
  alias JsonValidator.Errors.DuplicatedKeyError

  @spec call(binary()) :: :ok | {:error, list(DuplicatedKeyError.t())} | {:error, binary()}
  def call(json_binary) do
    with {:ok, json} <- Jason.decode(json_binary, objects: :ordered_objects),
         [] <- validate(json, []) do
      :ok
    else
      {:error, %Jason.DecodeError{}} -> {:error, "Invalid JSON"}
      errors when is_list(errors) -> {:error, Enum.reverse(errors)}
    end
  end

  defp validate(objects, path) when is_list(objects),
    do: validate_list(objects, 0, path)

  defp validate(%OrderedObject{values: values}, path),
    do: validate_values(values, [], path)

  defp validate(_scalar_value, _path),
    do: []

  defp validate_list([], _index, _path),
    do: []

  defp validate_list([object | tail], index, path),
    do: validate(object, [index | path]) ++ validate_list(tail, index + 1, path)

  defp validate_values([], _unique_keys, _path),
    do: []

  defp validate_values([{key, value} | tail], unique_keys, path) do
    if key in unique_keys do
      [build_error(key, path) | validate_values(tail, unique_keys, path)]
    else
      validate(value, [key | path]) ++ validate_values(tail, [key | unique_keys], path)
    end
  end

  defp build_error(key, path),
    do: DuplicatedKeyError.new(key, Enum.reverse(path))
end
