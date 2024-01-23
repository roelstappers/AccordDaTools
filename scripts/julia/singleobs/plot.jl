using GLMakie, NCDatasets, Statistics, Dates
Makie.inline!(false)
set_theme!(theme_light())
GLMakie.set_window_config!(;float=true)


fields = ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]
var2 = fields[1]

anenvards   = NCDataset("/home/roels/emy/envar/MXMIN1999.nc");
an3dvards   = NCDataset("/home/roels/emy/3dvar/MXMIN1999+0000.nc");
bgds    = NCDataset("/home/roels/emy/3dvar/ICMSHHARM+0003.nc");


an1 = Array{Float64,3}(undef,637,637,65)
an2 = Array{Float64,3}(undef,637,637,65)
bg = Array{Float64,3}(undef,637,637,65)


for lev = 1:65
    an1[:,:,lev] = anenvards["S$(lpad(lev,3,"0"))$var2"][:,:]
    an2[:,:,lev] = an3dvards["S$(lpad(lev,3,"0"))$var2"][:,:]
    bg[:,:,lev] = bgds["S$(lpad(lev,3,"0"))$var2"][:,:]
end 



fig = Figure()
ax = Axis3(fig[1, 1],aspect=(1,1,1)) #, show_axis=false)

x = 200:400
y = 200:400
z = 40:65 

sgrid = SliderGrid(
    fig[2, 1],
    (label = "yz plane - x axis", range = 1:length(x)),
    (label = "xz plane - y axis", range = 1:length(y)),
    (label = "xy plane - z axis", range = 1:length(z)),
)

lo = sgrid.layout
nc = ncols(lo)

vol = an1-bg 
plt = volumeslices!(ax, x, y, z, vol[x,y,z],colormap=:RdBu,colorrange=(-0.1,0.1))

# connect sliders to `volumeslices` update methods
sl_yz, sl_xz, sl_xy = sgrid.sliders

on(sl_yz.value) do v; plt[:update_yz][](v) end
on(sl_xz.value) do v; plt[:update_xz][](v) end
on(sl_xy.value) do v; plt[:update_xy][](v) end

set_close_to!(sl_yz, .5length(x))
set_close_to!(sl_xz, .5length(y))
set_close_to!(sl_xy, .5length(z))

# add toggles to show/hide heatmaps
hmaps = [plt[Symbol(:heatmap_, s)][] for s ∈ (:yz, :xz, :xy)]
toggles = [Toggle(lo[i, nc + 1], active = true) for i ∈ 1:length(hmaps)]

map(zip(hmaps, toggles)) do (h, t)
    connect!(h.visible, t.active)
end

# cam3d!(ax.scene, projectiontype=Makie.Orthographic)

fig

#fig = Figure()
#ax = Axis3(fig[1,1]) 
#volumeslices!(ax,1:637,1:637,1:65,an1)



 