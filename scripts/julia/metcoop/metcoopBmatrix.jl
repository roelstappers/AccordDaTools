using Dates, Statistics, NCDatasets, CSV
using GLMakie
archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
fcint  = Hour(3) 
vars = ["air_temperature_pl"]
var  = vars[1]
xrange = 1:949 
yrange = 1:1069
Nmbrs=30
mbrs=1:Nmbrs
levs=1:6

dspath(dtg) = joinpath(archive,Dates.format(dtg,"yyyy/mm/dd"), "meps_lagged_6_h_subset_2_5km_$(Dates.format(dtg,"yyyymmddTHHZ.nc"))") 

getens(dtg) = NCDataset(dspath(dtg))[var][xrange,yrange,mbrs,levs,1+fcint.value]
    

xm = (949+1)÷2
ym = (1069+1)÷2
xm = 200
ym = 800

lev = 6

dtg = Dates.DateTime(2023,01,01,00)



ens = getens(dtg)
pert = ens .- mean(ens,dims=3)

inc = zeros(xrange,yrange,levs)
for mbr in mbrs 
    inc .+= pert[:,:,mbr,:]*pert[xm,ym,mbr,lev]  
end 
inc = inc/(Nmbrs-1)


##
fig = Figure()
ax = Axis3(fig[1,1])
plt= surface!(ax,inc[:,:,6],colorrange=(-1,1),colormap=Reverse(:RdBu)) 
scatter!(ax,xm,ym,color=:black,markersize=20)
Colorbar(fig[1,2],plt)
fig