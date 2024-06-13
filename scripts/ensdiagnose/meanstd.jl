
using GLMakie, NCDatasets, Statistics

include("util.jl")


# Use this to download data from MEPS 
# url="https://thredds.met.no/thredds/dodsC/meps25epsarchive/2024/06/01/meps_lagged_6_h_subset_2_5km_20240601T00Z.nc"


var="S085HUMI.SPECIFI"
url="/home/roels/data/beni_ens/lam_ens/$var.nc"


ds = Dataset(url)

fld = nomissing(ds[var][:,:,:])

X,meanfld,stdfld = splitstdmean(fld)
 
#mbr = Observable(1)
#out = @lift scale*fld[:,:,$mbr]

# colorrange=(minimum(stdd),maximum(stdd))

fig = Figure()
title = "Ensemble mean $var"
ax = Axis3(fig[1,1],title=title)
plt = surface!(ax,meanfld,color=stdfld, colormap=:jet,colorscale=log10) #   ,colorrange=colorrange)
Colorbar(fig[1,2],plt,label="std")
tightlimits!(ax)
fig

