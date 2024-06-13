
using GLMakie, NCDatasets, Statistics

include("util.jl")


HH = Observable(00)
url= @lift "/home/roels/data/ensemble_aa/S065TEMPERATURE/20240415$(lpad($HH,2,"0"))+0000.nc"

ds = @lift Dataset($url)

fld = @lift nomissing($ds["S065TEMPERATURE"][:,:,:]) # ,pres_lev,1+fctime])

Xmeanfldstdfld = @lift splitstdmean($fld)

meanfld = @lift $Xmeanfldstdfld[2]
stdfld = @lift $Xmeanfldstdfld[3]

mbr = Observable(1)
out = @lift 20*$fld[:,:,$mbr]

colorrange=(0.01,1)

fig = Figure()
title = @lift "Ensemble mean $($(HH)) $varname $(pressure_levels[pres_lev]) hPa"
ax = Axis(fig[1,1],title=title)
plt = surface!(ax,out,color=stdfld, colormap=:jet,colorscale=log10,colorrange=colorrange)
Colorbar(fig[1,2],plt,label="std")
tightlimits!(ax)
fig

for HHi = 0:3:21
    HH[] = HHi
    sleep(0.03)
end 
