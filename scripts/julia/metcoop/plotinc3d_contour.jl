using NCDatasets, Dates, GLMakie

archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
constructpath(x) = Dates.format(x,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(x,"yyyymmddTHHZ.nc")
dtg = DateTime(2023,01,02,09)



# file = archive * constructpath(dtg)
fcint = Hour(3)

var = "air_temperature_ml"
#var = "specific_humidity_ml"
an(dtg) = NCDataset("$archive$(constructpath(dtg))")[var][:,:,:,1]
bg(dtg) = NCDataset("$archive$(constructpath(dtg-fcint))")[var][:,:,:,4]

data = an(dtg)-bg(dtg) 
data2 = (data .- minimum(data))./(maximum(data)-minimum(data));
cmap = :Hiroshige
Makie.inline!(false)
fig=Figure() 
ax= Axis3(fig[1,1],perspectiveness = 0.5, azimuth = 7.19, elevation = 0.57, aspect = (1, 1, 1))
# levslider = Slider(fig[2,1], range = 230:10:290, startvalue = 270, horizontal=true)
# levels = @lift([$(levslider.value)])
plt = contour!(ax,data,color=:red,levels=[0.5],alpha=0.5)
plt = contour!(ax,data,color=:blue,levels=[-0.5],alpha=0.5)

# Colorbar(fig[1,2],plt)
fig


