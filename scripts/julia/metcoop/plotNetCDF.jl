using NCDatasets, Dates, GLMakie

archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
constructpath(x) = Dates.format(x,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(x,"yyyymmddTHHZ.nc")
dtg = DateTime(2022,01,01,00)


file = archive * constructpath(dtg)

ds = NCDataset(file)
dskeys = keys(ds) 


keys4d = [k for k in dskeys if length(dimnames(ds[k])) == 4]

menukeys = Observable(keys4d)

dims = ["x","y","hybrid","t"]

fig = Figure() 
# varmenu  = Menu(fig[0,1], options = menukeys) #, default  = dtg) # ,horizontal=true)
dim1    = Menu(fig[1,1], options = dims) 
dim2    = Menu(fig[1,2], options = dims) 
dim3    = Menu(fig[1,3], options = dims) 
dim4    = Menu(fig[1,4], options = dims) 

Makie.inline!(false)

on(varmenu.selection) do varsi
    vari = varsi
    println(ds[vari])    
    println(dimnames(ds[vari]))
    # fig[1,1] = heatmap(ds[vari][:,:,:,1])
end


field = ds["air_temperature_z"][dim1.selection.val,dim2.value,dim3.value,dim4.value]

plot(heatmap(field))

fig

