using GLMakie, NCDatasets, Statistics, Dates

const fcint = Hour(3)
dtg = Dates.DateTime(2022,09,01,00)
vars = ["air_temperature_ml", "specific_humidity_ml","x_wind_ml","y_wind_ml"]


filename(dtg) = 

function getanbg_lustre(dt::DateTime)
     archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
     anfilename = Dates.format(dtg,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(dtg,"yyyymmddTHHZ.nc")
     bgfilename = Dates.format(dtg-fcint,"yyyy/mm/dd") * "/meps_det_2_5km_" * Dates.format(dtg-fcint,"yyyymmddTHHZ.nc")
     ands = NCDataset(joinpath(archive,anfilename))
     bgds = NCDataset(joinpath(archive,bgfilename))
     return ands,bgds
end

ands,bgds = getanbg_lustre(dtg)

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


# Animation with Makie.record 
ax.elevation[] = pi/2
ax.azimuth[]= -pi/2

fcrange = [0,0,0,0,0:1:60...]   # repeat 0 to pause longer on t=0 increment
record(fig, "metcoop_inc.mkv", fcrange; framerate = 5) do fcr
     println(fcr)
     sdt.value[] = fcr
     ax.elevation[] = ax.elevation[]+0.01
     ax.azimuth[] = ax.azimuth[]+0.01
end


# Manual animation
for i=0:60
     sdt.value[]=i
     sleep(0.25)
    
end