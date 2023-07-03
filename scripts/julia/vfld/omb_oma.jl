using VfldFiles, CairoMakie, DataFrames, Glob


select = [:ID,:LAT,:LON, :validtime,:TT,:leadtime,:basetime,:mbr]
files = glob("vfld*",MEPS_prod)
dfs = read_v.(files,select=select)
mepsdf = reduce(vcat,dfs)

files = glob("vobs*",obs)
dfs = read_v.(files,select=select)
obsdf = reduce(vcat,dfs)


df  = innerjoin(obsdf,mepsdf,on=[:ID,:validtime],makeunique=true)

dropmissing!(df,disallowmissing=true)



fig = Figure()
ax = Axis(fig[1,1])
plt= scatter!(ax,df[:,:validtime],df[:,:TT],color=getfield.(Hour.(df[:,:validtime]),:value))
Colorbar(fig[1,2],plt)
fig

gdf = groupby(df,:mbr)


f = Figure()
ax = Axis(f[1, 1])
density!(ax, collect(skipmissing(obsdf[:,:TT])),color= (:red,0.3) , strokewidth=3, strokecolor=:red, label="obs")
density!(ax, collect(skipmissing(df[:,:TT])),color= (:blue,0.3) , strokewidth=3, strokecolor=:blue, label="meps")
axislegend()
xlims!(ax,210,350)
f 

f = Figure()
ax = Axis(f[1, 1])
scatter(ax, collect(skipmissing(obsdf[:,:TT])),color= (:red,0.3) , strokewidth=3, strokecolor=:red, label="obs")
density!(ax, collect(skipmissing(df[:,:TT])),color= (:blue,0.3) , strokewidth=3, strokecolor=:blue, label="meps")
axislegend()
xlims!(ax,210,350)
f 






for (i,d) in enumerate(gdf) 
    density!(ax, collect(skipmissing(d[:,:TT]  - d[:,:TT_1])), offset= -i/4,
        color= (:red,0.3) , strokewidth=3, strokecolor=:red)
        # color = :y, clormap = [:darkblue, :gray95])
end
xlims!(ax,-3,3) 
f