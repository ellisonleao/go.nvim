local docgen = require('babelfish')
local metadata = {
  input_file = 'README.md',
  output_file = 'help.txt',
  project_name = 'go.nvim',
}
docgen.generate_readme(metadata)
