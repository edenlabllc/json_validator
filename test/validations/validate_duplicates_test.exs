defmodule JsonValidator.Validations.ValidateDuplicatesTest do
  use ExUnit.Case

  alias JsonValidator.Validations.ValidateDuplicates
  alias JsonValidator.Errors.DuplicatedKeyError

  describe "when json is invalid" do
    test "returns {:error, 'Invalid JSON'}" do
      assert {:error, "Invalid JSON"} = ValidateDuplicates.call("not a json")
    end
  end

  describe "where there is no duplicates" do
    test "returns :ok when root is object" do
      assert :ok = ValidateDuplicates.call(~s({"a": {"c": 3, "d": {"e": 5, "f": 6}}, "b": 2}))
    end

    test "returns :ok when root is list" do
      assert :ok = ValidateDuplicates.call(~s([{"a": {"c": 3, "d": {"e": 5, "f": 6}}, "b": 2}]))
    end

    test "returns :ok when nested value is list" do
      assert :ok =
               ValidateDuplicates.call(~s({"a": {"c": 3, "d": [{"e": 5}, {"f": 6}]}, "b": 2}))
    end
  end

  describe "where there are duplicates" do
    test "returns [%DuplicatedKeyError{}, ...] when root is object" do
      assert {:error,
              [
                %DuplicatedKeyError{
                  message: "Duplicated key 'b' at $",
                  key: "b",
                  path: "$"
                },
                %DuplicatedKeyError{
                  message: "Duplicated key 'f' at $.a.d",
                  key: "f",
                  path: "$.a.d"
                }
              ]} =
               ValidateDuplicates.call(
                 ~s({"a": {"c": 3, "d": {"e": 5, "f": 6, "f": 6}}, "b": 2, "b": 2})
               )
    end

    test "returns [%DuplicatedKeyError{}, ...] when root is list" do
      assert {:error,
              [
                %DuplicatedKeyError{
                  message: "Duplicated key 'b' at $.[0]",
                  key: "b",
                  path: "$.[0]"
                },
                %DuplicatedKeyError{
                  message: "Duplicated key 'f' at $.[0].a.d",
                  key: "f",
                  path: "$.[0].a.d"
                }
              ]} =
               ValidateDuplicates.call(
                 ~s([{"a": {"c": 3, "d": {"e": 5, "f": 6, "f": 6}}, "b": 2, "b": 2}])
               )
    end

    test "returns [%DuplicatedKeyError{}, ...] when nested value is list" do
      assert {:error,
              [
                %DuplicatedKeyError{
                  message: "Duplicated key 'b' at $",
                  key: "b",
                  path: "$"
                },
                %DuplicatedKeyError{
                  message: "Duplicated key 'f' at $.a.d.[1]",
                  key: "f",
                  path: "$.a.d.[1]"
                }
              ]} =
               ValidateDuplicates.call(
                 ~s({"a": {"c": 3, "d": [{"e": 5}, {"f": 6, "f": 6}]}, "b": 2, "b": 2})
               )
    end
  end
end
