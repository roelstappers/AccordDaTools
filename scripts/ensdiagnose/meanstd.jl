
using GLMakie, NCDatasets, Statistics

include("util.jl")


url="https://thredds.met.no/thredds/dodsC/meps25epsarchive/2024/06/01/meps_lagged_6_h_subset_2_5km_20240601T00Z.nc"

ds = Dataset(url)

pressure_levels = ds["pressure"][:]  # 300,500,700,850,925,1000
varname = "air_temperature_pl" 

var = ds[varname]


fctime=0  
pres_lev = 6   

fld = nomissing(var[:,:,:,pres_lev,1+fctime])

X,meanfld,stdfld = splitstdmean(fld)
 
#mbr = Observable(1)
#out = @lift scale*fld[:,:,$mbr]

# colorrange=(minimum(stdd),maximum(stdd))

fig = Figure()
title = "Ensemble mean $varname $(pressure_levels[pres_lev]) hPa"
ax = Axis3(fig[1,1],title=title)
plt = surface!(ax,meanfld,color=stdfld, colormap=:jet,colorscale=log10) #   ,colorrange=colorrange)
Colorbar(fig[1,2],plt,label="std")
tightlimits!(ax)
fig

