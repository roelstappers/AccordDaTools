using GLMakie, NCDatasets, Statistics, Dates
Makie.inline!(false)


archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
const fcint = Hour(3)
dtg = Dates.DateTime(2023,09,01,00)
filename = Dates.format(dtg,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(dtg,"yyyymmddTHHZ.nc")
ds = NCDataset(joinpath(archive,filename))


vars = ds["air_temperature_ml"]

geop = ds["surface_geopotential"][:,:,1,1]

dims = dimnames(vars)
xval = ds[dims[1]][:]
yval = ds[dims[2]][:]
levs = ds[dims[3]][:]
times = getfield.(Hour.(ds[dims[4]][:]-ds[dims[4]][1]),:value)

xlabel = ds[dims[1]].attrib["standard_name"]
ylabel = ds[dims[2]].attrib["standard_name"]
levslabel = ds[dims[3]].attrib["standard_name"]
timeslabel = ds[dims[4]].attrib["standard_name"]

title = vars.attrib["standard_name"]

lev=Observable(65)
fig = Figure()
display(fig)

#figprof = Figure();     display(GLMakie.Screen(),figprof)
#axprof = Axis(figprof[1,1],title="Profile",xlabel=title,ylabel=levslabel)
# axprof2 = Axis(figprof[1,1],yaxisposition=:right)
#ylims!(axprof2,65,1)


#figtime = Figure();     display(GLMakie.Screen(),figtime)
#axtime = Axis(figtime[1,1],title="Time series",xlabel=timeslabel,ylabel=title)

vara = @lift(vars[:,:,$lev,1] .- 273.15)

# heatmap!(ax,xval,yval,vars[:,:,1,1])
#ax = Axis(fig[1,1],xlabel=xlabel,ylabel=ylabel,title=title)
#deregister_interaction!(ax, :scrollzoom)
#deregister_interaction!(ax, :dragpan)
#heatmap!(ax,vara)




ax = Axis3(fig[1,1],
   #   xlabel=xlabel,
   #   ylabel=ylabel,title="$title lev $lev",
      aspect=:data,
      protrusions=0, # aspect=(1,1,0.05)
      azimuth=-pi/2, elevation=pi/4
)
surface!(ax,xval,yval,5*geop,color=vara)
xlims!(ax,minimum(xval),maximum(xval))
ylims!(ax,minimum(yval),maximum(yval))
hidedecorations!(ax)
hidespines!(ax)
return 


# on(events(ax).mousebutton) do event 
#    if event.button == Mouse.left && event.action == Mouse.press
   
#        xi, yi = Int.(events(ax).mouseposition.val)
#        println("Profile for $(xi) $(yi)")
#        varp = vars[xi,yi,:,1]::Array{Union{Missing,Float32},1}
#        lines!(axprof,varp,levs)       
#    end 
# end


# on(events(ax).mousebutton) do event 
#     if event.button == Mouse.right && event.action == Mouse.press
#         xi, yi = Int.(events(ax).mouseposition.val)
#         println("Times series for $(xi) $(yi)")
#         vart = vars[xi,yi,lev,:]::Array{Union{Missing,Float32},1}
#         lines!(axtime,times,vart,label="$xi $yi")  
#         axislegend(axtime,unique=true)   

       
#     end 
# end
 

fig
