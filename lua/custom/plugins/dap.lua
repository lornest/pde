return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mason-org/mason.nvim",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()
      require("dap-go").setup()

      -- Native debugging (C/C++/Rust) via codelldb, installed by Mason.
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Remembered per session so you only type the binary path once.
      local last_binary = nil

      dap.configurations.c = {
        {
          name = "Launch binary",
          type = "codelldb",
          request = "launch",
          program = function()
            local default = last_binary or (vim.fn.getcwd() .. "/")
            local path = vim.fn.input("Path to executable: ", default, "file")
            last_binary = path
            return path
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            return vim.split(vim.fn.input "Args: ", " ", { trimempty = true })
          end,
        },
      }

      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c

      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>rb", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
