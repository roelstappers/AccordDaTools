
using GLMakie, NCDatasets, Statistics

include("util.jl")


var = "S090TEMPERATURE"; scale=10
# var = "S085HUMI.SPECIFI"; scale= 10000

ds = Dataset("/home/roels/data/beni_ens/lam_ens/$var.nc")


fld = nomissing(ds[var][:,:,:])

X,m,stdd = splitstdmean(fld)
 
mbr = Observable(1)
out = @lift scale*fld[:,:,$mbr]

colorrange=(minimum(stdd),maximum(stdd))

fig = Figure()
ax = Axis(fig[1,1],title="Ensemble mean $var lam, color= std")
plt = surface!(ax,out,color=stdd, colormap=:jet,colorscale=log10  ,colorrange=colorrange)
Colorbar(fig[1,2],plt)
tightlimits!(ax)
fig

