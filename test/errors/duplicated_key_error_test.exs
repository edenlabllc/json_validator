defmodule JsonValidator.Errors.DuplicatedKeyErrorTest do
  use ExUnit.Case

  alias JsonValidator.Errors.DuplicatedKeyError

  describe "new/1" do
    test "returns %DuplicatedKeyError{}" do
      assert %DuplicatedKeyError{
               message: "Duplicated key 'b' at $",
               key: "b",
               path: "$"
             } = DuplicatedKeyError.new("b", [])
    end
  end

  describe "render/1" do
    test "returns {%{description: '...', params: ['b'], rule: :invalid}, '$'}" do
      assert {
               %{
                 description: "Duplicated key 'b' at $",
                 params: ["b"],
                 rule: :invalid
               },
               "$"
             } =
               DuplicatedKeyError.render(%DuplicatedKeyError{
                 message: "Duplicated key 'b' at $",
                 key: "b",
                 path: "$"
               })
    end
  end
end
