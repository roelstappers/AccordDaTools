using GLMakie, NCDatasets, Statistics, Dates

abstract type Archive end

struct Metcoop <: Archive 
    url::String
end

function Base.show(io::IO, a::Metcoop)
    print(io, a.url)
end

# At MET use 
archive=Metcoop("/lustre/storeB/immutable/archive/projects/metproduction/MEPS/") 
# archive=Metcoop("https://thredds.met.no/thredds/dodsC/meps25epsarchive")

# Read air_tem

# Metcoop
function thredds(dt) 
    x = 0:1:948;  y = 0:1:1068; lev = 0:1:64; fcint=Hour(3)
    vars = ["air_temperature_ml", "specific_humidity_ml","x_wind_ml","y_wind_ml"]
    var = vars[1]
    subdir(dt) = Dates.format(dt,"yyyy/mm/dd")
    filename(dt) = "meps_det_2_5km_$(Dates.format(dt,"yyyymmddTHHZ.nc"))"
    bgurl = joinpath(archive,subdir(dt-fcint), filename(dt-fcint))
    anurl = joinpath(archive,subdir(dt),filename(dt)) 
    ands =  NCDataset(anurl * "?$var[0:1:0][$lev][$y][$x]")[var][:,:,:,1]
    bgds =  NCDataset(bgurl * "?$var[3:1:3][$lev][$y][$x]")[var][:,:,:,1]
    return ands, bgds
end 

fig = Figure()
sdt = Slider(fig[2,2], range = 0:60, startvalue = 0,horizontal=true)
slev = Slider(fig[1,1], range = 65:-1:1, startvalue = 17,horizontal=false)

var=vars[1]
andf = @lift(ands[$var][:,:,$(slev.value),$(sdt.value)+1])
bgdf = @lift(bgds[$var][:,:,$(slev.value),$(sdt.value)+4])
inc = @lift($andf - $bgdf)

title = @lift(var * " level " * string($(slev.value))  * " " * Dates.format(dtg,"yyyymmddHH+") * string($(sdt.value)))
maxabsc = @lift(maximum(abs.($inc)))
crange = lift( m -> (-m,m),  maxabsc) 
ax = Axis3(fig[1,2], title=title, viewmode  = :stretch, elevation = pi/2, azimuth=-pi/2     )
hidedecorations!(ax)
hidespines!(ax)

surface!(ax,inc,color=inc, colormap=Reverse(:RdBu), colorrange=crange)
fig
