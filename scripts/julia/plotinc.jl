using GLMakie, NCDatasets, ArgParse


function parse_commandline() 
    s = ArgParseSettings()
    @add_arg_table! s begin
        "--level", "-l"
            help = "Model level"
            arg_type = Int
           default = 40
        "--field", "-f"
            help = "field: e.g. WIND.U.PHYS WIND.V.PHYS TEMPERATURE HUMI.SPECIFI"
            arg_type = String
            default = "TEMPERATURE"
        "an"
           help = "NetCDF file analysis"
            required = true
        "bg"
            help = "NetCDF file background"
            required = true
    end
    return parse_args(s)
end 

parsed_args = parse_commandline()


lev = parsed_args["level"]
var = parsed_args["field"]  #  "TEMPERATURE"

fg_ds = NCDataset(parsed_args["an"] )
an_ds = NCDataset(parsed_args["bg"])

bg = fg_ds["S$(lpad(lev ,3,"0"))$var"][:,:]
an = an_ds["S$(lpad(lev,3,"0"))$var"][:,:]

inc  = an - bg  



fig = Figure()
ax1  = Axis3(fig[1,1],
             viewmode=:stretch,
             alignmode=Outside(), # aspect=(1,1,0.1),            
             title="$var  level $lev",
             elevation = pi/2, azimuth=-pi/2  ,                       
        )
hidedecorations!(ax1)

maxabs =  0.3*maximum(abs.(inc))
crange = (-maxabs,maxabs)
cmap = :RdBu 

hm =  surface!(ax1,bg,colormap=cmap,color=inc,colorrange=crange)
Colorbar(fig[2,1], hm, vertical=false,tellheight=true)

display(fig)
