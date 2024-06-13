
using GLMakie, Dates 
using NCDatasets, Statistics, LinearAlgebra 
using TensorOperations
include("events.jl")
include("util.jl")

var = "S085HUMI.SPECIFI"; scale=20000
# var = "S085TEMPERATURE"


ds = Dataset("/home/roels/data/beni_ens/lam_ens/$var.nc")


fld = nomissing(ds[var][:,:,:])

X, meanfld, stdfld =  splitstdmean(fld) 

# Observables
lat  = Observable(500)  
lon  = Observable(500) 

Yp = @lift X[$lon,$lat,:]   

out(X,Y) = @tensor  out[x,y] :=  X[x,y,m]*Y[m]

out1 = @lift out(X,$Yp) 


fig = Figure() 
colormap = Reverse(:RdBu) #   ["blue", "white", "white", "red"] 
ax = Axis(fig[1,1])
plt = surface!(ax,scale*meanfld,color=out1,colormap=colormap ,colorrange=(-1,1)) # (-1,1))
scatter!(ax,lon,lat,color=:green,markersize=20,overdraw=true)
cb = Colorbar(fig[2,1], plt, flipaxis=false,vertical=false)

deactivate_interaction!(ax, :scrollzoom)
deactivate_interaction!(ax, :rectanglezoom)
deactivate_interaction!(ax, :dragpan)

events_pointpicker(ax, lon,lat)
events_scatterplot(ax,X,lon,lat)

hidedecorations!(ax)
tightlimits!(ax)

fig


##############################################################################
# USe code below to make animation and videos 
#####################33

# # animation 
# for l in 1:1:700
#     lon[]=l
#     sleep(0.00001)
# end

#lat0 = 739 ÷ 2
#lon0 = 949 ÷ 2
#r = 100
#for i=0:0.1:2*pi 
#    lat[] = 1; # round(Int,lat0 + r*sin(i))
#    lon[] = 1; # round(Int,lon0 + r*cos(i))
#    sleep(0.01)
#end


#record(fig, "animation.mp4", lats; framerate = 24) do t
#    lat[] = t
#end


