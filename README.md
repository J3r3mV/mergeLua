# mergeLua

**Version**: 1.0  
**Author**: [J3r3m](https://github.com/J3r3mV)

`mergeLua` is a Lua script designed to merge an entire Lua project into a single file, making it easier to distribute standalone scripts without external dependencies.

## Description
The **mergeLua.lua** script takes a main Lua file as input and generates an output file containing the merged code, including all required modules. This allows the script to be executed without managing separate modules or global paths.

## Prerequisites
- `require` calls must be used directly without assigning to a variable:  
  ```lua
  require("mymodule")  -- Correct
  local mymodule = require("mymodule")  -- Incorrect
  ```
- Modules must be located at the same level as the input script or in a subfolder.  
  Modules installed in global `package.path` directories are **not supported** to ensure scripts remain fully self-contained.

## Syntax
```sh
lua mergeLua.lua fileInput.lua fileOutput.lua
```

### Parameters
- `fileInput.lua`: The main Lua file to be merged.
- `fileOutput.lua`: The output file containing the merged code.

## Intended Use
- Simplify the distribution of Lua scripts without external dependencies.
- Enhance the portability of projects by bundling them into a single script file.

## Contributions
Contributions are welcome! Feel free to suggest improvements or report issues via [GitHub issues](https://github.com/J3r3mV).

## License
[MIT License](LICENSE) – Free to reuse, modify, and distribute under certain conditions.

