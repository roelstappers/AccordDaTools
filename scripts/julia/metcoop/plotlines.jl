using GLMakie, DataFrames, CSV, Dates, Statistics

archive="/lustre/storeB/users/roels/metcoopprofiles"
Makie.inline!(false)
levels = 1:65

var="air_temperature_ml"
year="2022"
mean = Matrix(CSV.read(joinpath(archive,"mean$(var)$year.txt"),DataFrame,header=false)[:,2:end])
rms = Matrix(CSV.read(joinpath(archive,"rms$(var)$year.txt"),DataFrame,header=false)[:,2:end])

dtg = CSV.read(joinpath(archive,"mean$(var)$year.txt"),DataFrame,header=false)[:,1]
startofmonth = findall(x -> (Day(x) == Day(1) && Hour(x) == Hour(0)),dtg[1:8:end])
xticks  = (startofmonth, ["1 Jan", "1 Feb","1 Mar","1 Apr","1 May","1 Jun","1 Jul","1 Aug","1 Sep","1 Oct","1 Nov","1 Dec"])

#dts = CSV.read("mean202204.txt",DataFrame)[:,1]
#rms  = Matrix(CSV.read("rms$var202206.txt",DataFrame)[:,2:end])
crange=(-0.2,0.2)
##
titles = ["00UTC","03UTC","06UTC","09UTC","12UTC","15UTC","18UTC","21UTC"]
sind = 7
fig = Figure(resolution=(1200,800))
ax= Axis(fig[1,1],yreversed=true,title=titles[sind],yticks=5:5:65,xticks=xticks)  
plt = heatmap!(ax,mean[sind:8:end,levels],colormap=Reverse(:RdBu),colorrange=crange)
Colorbar(fig[:,2],plt) # ,height=Relative(0.5))

# Label(fig[0,:], "Metcoop mean $var increment $month")
# Label(fig[:,0], "Model level",rotation=π/2)

# Label(fig[5,:], "Day of year")

fig


fig = Figure()
ax = Axis(fig[1,1])
ind=18;
#lines!(ax,rms[1:end,ind],label="rms level $ind")
lines!(ax,mean[1:8:end,ind],label="Mean level $ind")
lines!(ax,mean[4:8:end,ind],label="Mean level $ind")

scatter!(ax,1:8:8*365,mean[1:8:end,ind],label="Mean level $ind",color=:red)
axislegend(ax)
fig



ax = Axis(fig[1,2])
ind=18;
#lines!(ax,rms[1:end,ind],label="rms level $ind")
lines!(ax,mean[1:end,ind],label="Mean level $ind")
scatter!(ax,1:8:8*365,mean[1:8:end,ind],label="Mean level $ind",color=:red)
axislegend(ax)
fig

ax = Axis(fig[2,1])
ind=19;
#lines!(ax,rms[1:end,ind],label="rms level $ind")
lines!(ax,mean[1:end,ind],label="Mean level $ind")
scatter!(ax,1:8:8*365,mean[1:8:end,ind],label="Mean level $ind",color=:red)
axislegend(ax)
ax = Axis(fig[2,2])

ind=3;
#lines!(ax,rms[1:end,ind],label="rms level $ind")
lines!(ax,mean[1:end,ind],label="Mean level $ind")
scatter!(ax,1:8:8*365,mean[1:8:end,ind],label="Mean level $ind",color=:red)
axislegend(ax)
fig

#lines!(ax,mean[2:8:end,ind],label="03")
lines!(ax,mean[3:8:end,ind],label="06")
#lines!(ax,mean[4:8:end,ind],label="09")
lines!(ax,mean[5:8:end,ind],label="12")
#lines!(ax,mean[6:8:end,ind],label="15")
lines!(ax,mean[7:8:end,ind],label="18")
#lines!(ax,mean[8:8:end,ind],label="21")
Legend(fig[2,1],ax,"Time UTC", orientation=:horizontal)
fig

# profiles
fig = Figure()
ax = Axis(fig[1,1],yreversed=true)
#lines!(ax,mean[3:8:end,:],1:65)
lines!(ax,mean[3,:],1:65)
lines!(ax,mean[3+8,:],1:65)
lines!(ax,mean[3+5*8,:],1:65)



fig

#### Scatter plot
fig = Figure()
xlev=45; ylev =3 
ax= Axis(fig[1,1],title="Scatter plot",xlabel="level $xlev",ylabel="level $ylev") 
#scatter!(ax,mean[1:8:end,xlev],mean[1:8:end,ylev],label="00")
scatter!(ax,mean[2:8:end,xlev],mean[2:8:end,ylev],label="03")
#scatter!(ax,mean[3:8:end,xlev],mean[3:8:end,ylev],label="06")
scatter!(ax,mean[4:8:end,xlev],mean[4:8:end,ylev],label="09")
#scatter!(ax,mean[5:8:end,xlev],mean[5:8:end,ylev],label="12")
scatter!(ax,mean[6:8:end,xlev],mean[6:8:end,ylev],label="15")
#scatter!(ax,mean[7:8:end,xlev],mean[7:8:end,ylev],label="18")
scatter!(ax,mean[8:8:end,xlev],mean[8:8:end,ylev],label="21")
Legend(fig[2,1],ax, orientation=:horizontal)
fig