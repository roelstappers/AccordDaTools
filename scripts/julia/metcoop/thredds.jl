using GLMakie, NCDatasets, Dates

fcint = Hour(3); nlat=1069; nlon=949; nlev=65  # METCOOP25D
#fcint = Hour(3); nlat=300; nlon=300; nlev=65  # METCOOP25D

mepsurl="https://thredds.met.no/thredds/dodsC/meps25epsarchive"

url(dtg) = joinpath(mepsurl,Dates.format(dtg,"yyyy/mm/dd"), "meps_det_2_5km_$(Dates.format(dtg,"yyyymmddTHHZ")).nc")
querystr(ll,lev,var) = "?$var[$ll][$(lev-1)][0:1:$(nlat-1)][0:1:$(nlon-1)]"

bg(dtg,lev,var,ll) = NCDataset(url(dtg-fcint) * querystr(ll+fcint.value,lev,var))
an(dtg,lev,var,ll) = NCDataset(url(dtg) * querystr(ll,lev,var))


dtg = Observable(Dates.DateTime(2023,01,01,00))
var = Observable("air_temperature_ml")   
varq = "specific_humidity_ml" # ,"x_wind_ml","y_wind_ml"]
lev = Observable(65)
ll = Observable(0)

incq = @lift(an($dtg,$lev,$varq,$ll)[$varq][:,:,1,1] - bg($dtg,$lev,$varq,$ll)[$varq][:,:,1,1])


fig = Figure()

maxabsc = @lift(maximum(abs.($inc)))
crange = lift( m -> (-m,m),  maxabsc) 
title = @lift(" $($var) level $($lev) $($dtg)+$(lpad($ll,3,"0"))") 

ax = Axis(fig[1,1],title=title) 
#hidedecorations!(ax)
#hidespines!(ax)

#plt = surface!(ax,inc,color=inc, colormap=Reverse(:RdBu), colorrange=crange)
 plt = heatmap!(ax,incT, colormap=Reverse(:RdBu), colorrange=crange)
 plt = heatmap!(ax,incq, colormap=Reverse(:RdBu), colorrange=crange)

Colorbar(fig[1,2],plt)
fig

