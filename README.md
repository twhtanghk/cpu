# cpu
module to get cpu temperature from sysfs

# Installation
```
npm install cpu
```

# Usage
## define and export env variables defined in .env

## get cpu temperature
```
cpu = require 'cpu'

cpu
  .temp()
  .then console.log, console.log

```

## publish cpu temperature to defined mqtt topic
```
cpu = require 'cpu'

cpu.pub()
```
