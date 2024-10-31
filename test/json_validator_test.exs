defmodule JsonValidatorTest do
  use ExUnit.Case

  doctest JsonValidator

  test "validate_duplicates/1" do
    assert :ok = JsonValidator.validate_duplicates(~s({"a": 1}))
  end
end
