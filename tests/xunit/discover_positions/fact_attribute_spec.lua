local async = require("nio").tests
local plugin = require("neotest-dotnet")
local Tree = require("neotest.types").Tree

A = function(...)
  print(vim.inspect(...))
end

describe("discover_positions", function()
  require("neotest").setup({
    adapters = {
      require("neotest-dotnet"),
    },
  })

  async.it("should discover single tests in sub-class", function()
    local spec_file = "./tests/xunit/specs/nested_class.cs"
    local spec_file_name = "nested_class.cs"
    local positions = plugin.discover_positions(spec_file):to_list()

    local expected_positions = {
      {
        id = spec_file,
        name = spec_file_name,
        path = spec_file,
        range = { 0, 0, 27, 0 },
        type = "file",
      },
      {
        {
          id = spec_file .. "::XUnitSamples",
          is_class = false,
          name = "XUnitSamples",
          path = spec_file,
          range = { 2, 0, 26, 1 },
          type = "namespace",
        },
        {
          {
            id = spec_file .. "::XUnitSamples::UnitTest1",
            is_class = true,
            name = "UnitTest1",
            path = spec_file,
            range = { 4, 0, 26, 1 },
            type = "namespace",
          },
          {
            {
              id = spec_file .. "::XUnitSamples::UnitTest1::Test1",
              is_class = false,
              name = "Test1",
              path = spec_file,
              range = { 6, 1, 10, 2 },
              type = "test",
            },
          },
          {
            {
              id = spec_file .. "::XUnitSamples::UnitTest1+NestedClass",
              is_class = true,
              name = "NestedClass",
              path = spec_file,
              range = { 12, 1, 25, 2 },
              type = "namespace",
            },
            {
              {
                id = spec_file .. "::XUnitSamples::UnitTest1+NestedClass::Test1",
                is_class = false,
                name = "Test1",
                path = spec_file,
                range = { 14, 2, 18, 3 },
                type = "test",
              },
            },
            {
              {
                id = spec_file .. "::XUnitSamples::UnitTest1+NestedClass::Test2",
                is_class = false,
                name = "Test2",
                path = spec_file,
                range = { 20, 2, 24, 3 },
                type = "test",
              },
            },
          },
        },
      },
    }
    assert.same(positions, expected_positions)
  end)
end)
