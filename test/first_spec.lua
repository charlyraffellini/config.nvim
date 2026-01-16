-- each of this files are executed in a brand new neovim instance.
-- This implies all  configs in my current instance are not being affected by the tests.
describe("first test", function()
  it("should pass", function()
      print("Hello World")
      assert.is_true(true)
  end)
end)
