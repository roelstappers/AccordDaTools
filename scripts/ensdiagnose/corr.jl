
using GLMakie, Dates 
using NCDatasets, Statistics, LinearAlgebra, TensorOperations
include("events.jl")
include("util.jl")

var = "S085HUMI.SPECIFI"
# var = "S085TEMPERATURE"


ds = Dataset("/home/roels/data/beni_ens/lam_ens/$var.nc")

fld1 = nomissing(ds[var][:,:,:])


X1, meanfld1, stdfld1 =  splitstdmean(fld1) 

# Observables
lat  = Observable(500)  
lon  = Observable(500) 

Y1p = @lift X1[$lon,$lat,:]   

out(X,Y) = @tensor  out[x,y] :=  X[x,y,m]*Y[m]

out1 = @lift 10*out(X1,$Y1p) 


fig = Figure() 
colormap = Reverse(:RdBu) #   ["blue", "white", "white", "red"] 
ax1 = Axis(fig[1,1])
plt1 = surface!(ax1,meanfld1,color=out1,colormap=colormap ,colorrange=(-10,10)) # (-1,1))
scatter!(ax1,lon,lat,color=:green,markersize=20,overdraw=true)
cb1 = Colorbar(fig[2,1], plt1, flipaxis=false,vertical=false)

deactivate_interaction!(ax1, :scrollzoom)
deactivate_interaction!(ax1, :rectanglezoom)
deactivate_interaction!(ax1, :dragpan)

events_pointpicker(ax1, lon,lat)
events_scatterplot(ax1,X1,lon,lat)

hidedecorations!(ax1)
tightlimits!(ax1)

fig

# # animation 
# for l in 1:1:700
#     lon[]=l
#     sleep(0.00001)
# end

lat0 = 739 ÷ 2
lon0 = 949 ÷ 2
r = 100
for i=0:0.1:2*pi 
    lat[] = 1; # round(Int,lat0 + r*sin(i))
    lon[] = 1; # round(Int,lon0 + r*cos(i))
    sleep(0.01)
end


record(fig, "animation.mp4", lats; framerate = 24) do t
    lat[] = t
end


