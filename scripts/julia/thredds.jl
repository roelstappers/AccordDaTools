using GLMakie, NCDatasets, Statistics, Dates


# Metcoop
function thredds(dt) 
    x = 0:1:948;  y = 0:1:1068; lev = 0:1:64; fcint=Hour(3)
    vars = ["air_temperature_ml", "specific_humidity_ml","x_wind_ml","y_wind_ml"]
    var = vars[1]
  #  https://thredds.met.no/thredds/dodsC/meps25epsarchive/2023/05/01/meps_det_2_5km_20230501T06Z.nc?time[0:1:66]
   
#  https://thredds.met.no/thredds/dodsC/meps25epsarchive/2023/05/01/meps_det_2_5km_20230501T06Z.nc?air_temperature_ml[0:1:3][0:1:65][0:1:1000][0:1:900]
#  https://thredds.met.no/thredds/dodsC/meps25epsarchive/2023/04/30/meps_det_2_5km_20230430T00Z.nc?air_temperature_ml[0:1:0][0:1:64][0:1:1068][0:1:948]
    archive = "https://thredds.met.no/thredds/dodsC/meps25epsarchive"
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
