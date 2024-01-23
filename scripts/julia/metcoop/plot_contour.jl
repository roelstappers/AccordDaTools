using NCDatasets, Dates, GLMakie

archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
constructpath(x) = Dates.format(x,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(x,"yyyymmddTHHZ.nc")
dtg = DateTime(2022,01,01,00)



file = archive * constructpath(dtg)

ds = NCDataset(file)
time = Observable(1)
level = Observable(273)

data = ds["air_temperature_ml"][:,:,:,1]

Makie.inline!(false)
fig=Figure() 
ax= Axis3(fig[1,1],aspect=:equal)
levslider = Slider(fig[2,1], range = 230:10:290, startvalue = 270, horizontal=true)
levels = @lift([$(levslider.value)])
contour!(ax,data,levels=levels)
fig


