using VfldFiles
using Dates, DataFrames
using GLMakie
archive="/home/roels/plots"


dtg = Dates.DateTime(2019,08,18,03)

dts(dt) = Dates.format(dt,"yyyymmddHH") 
fcint = Hour(3)
vars = [:ID, :TT]

exp1= "oops_3denvarmbr000"
exp2= "oops_3dvar"

vobs = read_v("$archive/obs/vobs$(dts(dtg))",select=vars)

bgenvar = read_v("$archive/envar/vfld$(exp1)$(dts(dtg-fcint))03",select=vars)
venvar00 = read_v("$archive/envar/vfld$(exp1)$(dts(dtg))00",select=vars)
venvar = read_v("$archive/envar/vfld$(exp1)$(dts(dtg))",select=vars)

bg3dvar = read_v("$archive/3dvar/vfld$(exp2)$(dts(dtg-fcint))03",select=vars)

v3dvar00 = read_v("$archive/3dvar/vfld$(exp2)$(dts(dtg))00",select=vars)
v3dvar = read_v("$archive/3dvar/vfld$(exp2)$(dts(dtg))",select=vars)


#df = innerjoin(vobs,venvar00,v3dvar00,on=[:ID,:validtime],makeunique=true)
# df = innerjoin(vobs,venvar,v3dvar,on=[:ID,:validtime],makeunique=true)
df1 = innerjoin(vobs,bgenvar,venvar00,on=[:ID,:validtime],makeunique=true)
df2 = innerjoin(vobs,bg3dvar,v3dvar00,on=[:ID,:validtime],makeunique=true)


fig = Figure()
ax1 = Axis(fig[1,1],title="", xlabel="O-B",ylabel="O-A")
scatter!(ax1, df1[:,:TT]-df1[:,:TT_1], df1[:,:TT]-df1[:,:TT_2],color=:blue,label="envar")
scatter!(ax1, df2[:,:TT]-df2[:,:TT_1], df2[:,:TT]-df2[:,:TT_2],color=:red,label="3dvar")
lines!(ax1,[-6,6],[-6,6],color=:black)

axislegend()

fig



scatter!(ax1,df[!,:TT],df[!,:TT_1])
ax2 = Axis(fig[1,2],title="3dvar",xlabel="obs",ylabel="H(x)")
scatter!(ax2,df[!,:TT],df[!,:TT_2])
ax3 = Axis(fig[2,1],title="Departures",xlabel="envar",ylabel="3dvar")
scatter!(ax3,df[!,:TT_1]-df[!,:TT],df[!,:TT_2]-df[!,:TT])
ax4 = Axis(fig[2,2],title="3dvar vs envar",xlabel="H(x)",ylabel="H(x)")
scatter!(ax4,1:nrow(df), df[!,:TT_1]-df[!,:TT_2])

fig