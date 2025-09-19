this is not chip-agnostic so if you have a different msp430 then gg lor

additionally, the run.sh doesn't seem to work to load the thing rightaway. you need to `prog main.elf, run` keyi liao

todo: automatic gdb server + attaching setup?

note that the compile flags in `compile.sh` compile with minimimum optimization + debugging symbols, this is so that it's not a fucking headache for me to debug shit


