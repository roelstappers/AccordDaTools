using GLMakie, NCDatasets, Statistics, Dates

const archive="/home/roels/plots/"
const an_filename="MXMIN1999+0000.nc"   
const bg_filename="ICMSHHARM+0003.nc"
const fcint = Hour(3)
const dtgbeg = Dates.DateTime(2019,08,18,03)
const dtgend = Dates.DateTime(2019,08,18,15)
const dtrange = [dtgbeg,dtgend]

vars = ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]
exps = ["3dvar","envar"]
var  = Observable(vars[1])
exp  = Observable(exps[1])


# helper functions
#dt2str(dt) = Dates.format(dt,"yyyymmddHH")


fig = Figure()
sdt = Slider(fig[2,2], range = dtrange, startvalue = dtrange[1],horizontal=true)
slev = Slider(fig[1,1], range = 65:-1:1, startvalue = 65,horizontal=false)
menu = Menu(fig[2,1], options = ["inc","bg"], default= "inc",tellwidth=true)
fig
andt2str = @lift(Dates.format($(sdt.value),"yyyymmddHH"))
bgdt2str = @lift(Dates.format($(sdt.value)-fcint,"yyyymmddHH"))

field = @lift("S$(lpad($(slev.value),3,"0"))$(var.val)")

ands = @lift(NCDataset(joinpath(archive,$exp,$andt2str,an_filename)))
andf = @lift($ands[$field][:,:])

bgds = @lift(NCDataset(joinpath(archive,$exp,$bgdt2str,bg_filename)))
bgdf = @lift($bgds[$field][:,:])
inc = @lift($andf - $bgdf)

# title = @lift($field)
maxabsc = @lift(maximum(abs.($inc)))
crange = lift( m -> (-m,m),  maxabsc) 
surfp = @lift($(menu.selection) == "inc" ? $inc : $bgdf)

title = @lift($field * " " * $exp * " " * $(andt2str))
ax = Axis3(fig[1,2],title=title, viewmode  = :stretch, elevation = pi/2, azimuth=-pi/2     )
on(x->reset_limits!(ax), surfp) 
#tightlimits!.(ax)
hidedecorations!(ax)
hidespines!(ax)

surface!(ax,surfp,color=inc, colormap=Reverse(:RdBu), colorrange=crange)
fig

axp = Axis(fig[1,3],yreversed=true, xticklabelsvisible=false, yticklabelsvisible=false, yaxisposition = :right)

profile = @lift begin
    nlev=65;     
    val = zeros(nlev) 
    for lev in 1:nlev
       field = "S$(lpad(lev,3,"0"))$(var.val)"
       inc = $ands[field][:,:] - $bgds[field][:,:]
       val[lev]= sqrt(mean(inc.^2))
    end
    return val
end 

pval = @lift($profile[$(slev.value)])
lines!(axp, profile, 1:65, color=:red)
scatter!(axp,pval,slev.value)
fig



