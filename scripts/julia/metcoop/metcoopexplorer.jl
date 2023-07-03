using GLMakie, NCDatasets, Statistics, Dates, FileTrees

archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
fcint = Hour(3)

dtgbeg = Dates.DateTime(2022,06,01,09)
dtgend = Dates.DateTime(2023,06,01,09)
dtrange = dtgbeg:fcint:dtgend
dtrange = dtgbeg:Hour(24):dtgend

vars = ["air_temperature_ml", "specific_humidity_ml","x_wind_ml","y_wind_ml"]
varlabels = ["T","q","u","v"]

var  = Observable(vars[1])
dtg  = Observable(dtgbeg)


constructpath(x) = Dates.format(x,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(x,"yyyymmddTHHZ.nc")





fig = Figure()
# dtgslider = Slider(fig[2,2], range = dtrange, startvalue = dtg,horizontal=true)
dtgmenu  = Menu(fig[0,2], options = dtrange) #, default  = dtg) # ,horizontal=true)
varmenu  = Menu(fig[0,1], options = zip(varlabels,vars),width=25) #, default  = dtg) # ,horizontal=true)

levslider = Slider(fig[1,1], range = 65:-1:1, startvalue = 65,horizontal=false)
fcslider = Slider(fig[2,2], range = 0:60, startvalue = 0, horizontal=true)

anfilename = lift(x-> constructpath(x), dtgmenu.selection)
bgfilename = lift(x-> constructpath(x-fcint), dtgmenu.selection)

dtg = Observable(dtgbeg)

on(dtgmenu.selection) do dtgi
    anfilename[] = constructpath(dtgi)
    bgfilename[] = constructpath(dtgi-fcint)
    dtg[] = dtgi
end

on(varmenu.selection) do varsi
    var[] = varsi
end
#anfilename = lift(x-> constructpath(x), dtgmenu.selection )
#$bgfilename = lift(x-> constructpath(x-fcint), dtgmenu.selection)
#end



# fig

ands = @lift(NCDataset(joinpath(archive,$anfilename)))
andf = @lift($ands[$var][:,:,$(levslider.value),1+$(fcslider.value)])

bgds = @lift(NCDataset(joinpath(archive,$bgfilename)));
bgdf = @lift($bgds[$var][:,:,$(levslider.value),4+$(fcslider.value)])
inc = @lift($andf - $bgdf)

# title = @lift($field)
maxabsc = @lift(maximum(abs.($inc)))
crange = lift( m -> (-m,m),  maxabsc) 
title = @lift($var * " level " * string($(levslider.value))  * " " * Dates.format($(dtg),"yyyymmddHH+") * string($(fcslider.value))) 

ax = Axis(fig[1,2], title=title) 
# ax = Axis3(fig[1,2], title=title, viewmode  = :stretch)  # elevation = pi/2, azimuth=-pi/2 

# on(x->reset_limits!(ax), surfp) 
#tightlimits!.(ax)
hidedecorations!(ax)
hidespines!(ax)
# plt = surface!(ax,inc,color=inc, colormap=Reverse(:RdBu), colorrange=crange)
plt = heatmap!(ax,inc, colormap=Reverse(:RdBu), colorrange=(-3,3))

Colorbar(fig[1,3],plt)
Makie.inline!(false)
fig

hotkey = Keyboard.a
on(events(fig).keyboardbutton) do event
    if ispressed(fig, hotkey)
        println("hotkey pressed")
    end
end
fig

#ft = FileTree("$archive/2023/01/")

#ncds = FileTrees.load(ft) do file
#    NCDataset(FileTrees.path(file))
#end


# ftf = mv(ft,r".*meps_det_2_5km_(\d{8})T(\d{2}).*", s"\1\2")

# ft = mapsubtreefilter("x->r"meps_det_2_k*"  FileTree("$archive/2023/01")

