local osc52 = require('osc52')

vim.keymap.set('n', '<leader>c', function()
  osc52.copy_operator()
end, {expr = true})

vim.keymap.set('v', '<leader>c', function()
  osc52.copy_visual()
end)
