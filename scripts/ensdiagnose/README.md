# Git clone 

To obtain the scripts

```bash 
git clone git@github.com:roelstappers/AccordDaTools.git -b ww_ensdiag 
```


# Installing Julia 

It is strongly recommended that the official generic binaries from the downloads page be used to install Julia

1. Download [Julia](https://julialang.org/downloads/#current_stable_release) and untar.
2. Add the julia bin directory to your PATH
   ```
   export PATH=/path/to/julia/bin:$PATH
   ```

Alternative you can use juliaup see [here](https://julialang.org/downloads/)

# Install dependencies (Needs to be done only once)


```bash
cd /path/to/AccordDaTools/scripts/ensdiagnose/
julia --project -e 'using Pkg; Pkg.instantiate()'
```

# Get the data 


```bash 
sftp hpc-login 
mget /hpcperm/fars/beni_ens/lam_ens/S085HUMI.SPECIFI.nc
```

# Use scripts 

Use vscode with the julia extension installed or use the Julia REPL. Start REPL with `--project`   

```
julia --project 
```

To activate the project environment from the `toml` files  

