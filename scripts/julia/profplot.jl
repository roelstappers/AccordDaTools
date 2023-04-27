using GLMakie, NCDatasets, Statistics

archive="/home/roels/plots/"

an_filename="MXMIN1999+0000.nc"   # Needs /YYYY/MN/DD/HH
bg_filename="ICMSHHARM+0003.nc"

expenvar = "3dvar"

bgds1 = NCDataset(joinpath(archive,expenvar,"2019081800",bg_filename));
ands1 = NCDataset(joinpath(archive,expenvar,"2019081803",an_filename));

exp3dvar = "3dvar"
bgds2 = NCDataset(joinpath(archive,expenvar,"2019081812",bg_filename));
ands2 = NCDataset(joinpath(archive,expenvar,"2019081815",an_filename));



function profile(bgds,ands,var)
    nlev = 65                
    val = zeros(nlev)
    for lev in 1:nlev
        field = "S$(lpad(lev,3,"0"))$var"
        inc = ands[field][:,:] - bgds[field][:,:]
        val[lev]= sqrt(mean(inc.^2))
    end
    return val          
end

fields= ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]
 
set_theme!(theme_light())
fig = Figure() 

ax = Axis(fig[1,1], yreversed=true, title=fields[1])
lines!(ax,profile(bgds1,ands1, fields[1]),1:65,color=:blue)
lines!(ax,profile(bgds2,ands2, fields[1]),1:65,color=:red)

ax = Axis(fig[1,2], yreversed=true, title=fields[2])
lines!(ax,profile(bgds1,ands1, fields[2]),1:65,color=:blue)
lines!(ax,profile(bgds2,ands2, fields[2]),1:65,color=:red)

ax = Axis(fig[2,1], yreversed=true, title=fields[3])
lines!(ax,profile(bgds1,ands1, fields[3]),1:65,color=:blue)
lines!(ax,profile(bgds2,ands2, fields[3]),1:65,color=:red)

ax = Axis(fig[2,2], yreversed=true, title=fields[4])
lines!(ax,profile(bgds1,ands1, fields[4]),1:65,color=:blue)
lines!(ax,profile(bgds2,ands2, fields[4]),1:65,color=:red)

fig