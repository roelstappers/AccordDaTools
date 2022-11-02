# plotinc


usage: <PROGRAM> [-l LEVEL] [-f FIELD] [-h] an bg
       
        positional arguments:
          an                 NetCDF file analysis
          bg                 NetCDF file background
       
        optional arguments:
          -l, --level LEVEL  Model level (type: Int64, default: 40)
          -f, --field FIELD  field: e.g. WIND.U.PHYS WIND.V.PHYS TEMPERATURE
                            HUMI.SPECIFI (default: "TEMPERATURE")
          -h, --help         show this help message and exit
      



# Reducing time to first plot

Put this in your .bashrc 

```
alias jss='julia --startup-file=no -e "using DaemonMode; serve()" & '
alias jc='julia --startup-file=no -e "using DaemonMode; runargs()"'
```

Start the server with `jss` and run the scripts with `jc`. 
If the analysis and background are 1.4GB it should take 1 second to produce the plot
Unfortunately it doesn't play nicely with missing arguments 
