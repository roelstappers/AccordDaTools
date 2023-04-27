using GLMakie, NCDatasets, Statistics, Dates

#const archive="/home/roels/plots/"
const archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
#const an_filename="MXMIN1999+0000.nc"   
#const bg_filename="ICMSHHARM+0003.nc"
const fcint = Hour(3)

dtg = Dates.DateTime(2022,09,01,00)
vars = ["air_temperature_ml", "specific_humidity_ml","x_wind_ml","y_wind_ml"]


# helper functions
#dt2str(dt) = Dates.format(dt,"yyyymmddHH")


fig = Figure()
sdt = Slider(fig[2,2], range = 0:60, startvalue = 0,horizontal=true)
slev = Slider(fig[1,1], range = 65:-1:1, startvalue = 17,horizontal=false)
# menu = Menu(fig[2,1], options = ["inc","bg"], default= "inc",tellwidth=true)

anfilename = Dates.format(dtg,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(dtg,"yyyymmddTHHZ.nc")
bgfilename = Dates.format(dtg-fcint,"yyyy/mm/dd") * "/meps_det_2_5km_" * Dates.format(dtg-fcint,"yyyymmddTHHZ.nc")

# fig
#andt2str = lift(x->Dates.format(x,"yyyy/mm/dd"),sdt.value)
#bgdt2str = lift(x->Dates.format(x-fcint,"yyyy/mm/dd"),sdt.value)


# field = @lift("S$(lpad($(slev.value),3,"0"))$(var.val)")

ands = NCDataset(joinpath(archive,anfilename))
andf = @lift(ands[$var][:,:,$(slev.value),$(sdt.value)+1])

bgds = NCDataset(joinpath(archive,bgfilename))
bgdf = @lift(bgds[$var][:,:,$(slev.value),$(sdt.value)+4])
inc = @lift($andf - $bgdf)

# title = @lift($field)
maxabsc = @lift(maximum(abs.($inc)))
crange = lift( m -> (-m,m),  maxabsc) 
# surfp = @lift($(menu.selection) == "inc" ? $inc : $bgdf)

# title = @lift($field * " " * $exp * " " * $(andt2str))
ax = Axis3(fig[1,2], viewmode  = :stretch, elevation = pi/2, azimuth=-pi/2     )
# on(x->reset_limits!(ax), surfp) 
#tightlimits!.(ax)
hidedecorations!(ax)
hidespines!(ax)

# on(slider)

surface!(ax,inc,color=inc, colormap=Reverse(:RdBu), colorrange=crange)
fig
