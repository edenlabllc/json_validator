defmodule JsonValidator do
  @moduledoc """
  Documentation for JsonValidator.
  """

  alias JsonValidator.Errors.DuplicatedKeyError
  alias JsonValidator.Validations.ValidateDuplicates

  @doc """
  Validates JSON for duplicated keys.

  ## Parameters

    * `json_binary` - Binary with JSON content.

  ## Examples

    iex> JsonValidator.validate_duplicates(~s({"a": 1}))
    :ok
  """
  @spec validate_duplicates(json_binary :: binary()) ::
          :ok | {:error, list(DuplicatedKeyError.t())} | {:error, binary()}
  defdelegate validate_duplicates(json_binary),
    to: ValidateDuplicates,
    as: :call
end
