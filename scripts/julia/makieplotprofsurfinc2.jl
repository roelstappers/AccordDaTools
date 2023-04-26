using GLMakie, NCDatasets, Statistics, Dates

const archive="/home/roels/plots/"
const an_filename="MXMIN1999+0000.nc"   
const bg_filename="ICMSHHARM+0003.nc"
const fcint = Hour(3)
const dtgbeg = Dates.DateTime(2019,08,18,03)
const dtgend = Dates.DateTime(2019,08,18,15)
const dtrange = [dtgbeg,dtgend]


# helper functions
dt2str(dt) = Dates.format(dt,"yyyymmddHH")


fig = Figure()
sdt = Slider(fig[2,2], range = dtrange, startvalue = dtrange[1],horizontal=true)
slev = Slider(fig[1,1], range = 65:-1:1, startvalue = 65,horizontal=false)
var = Observable("TEMPERATURE")

ands = @lift begin 
     println("change ds")
     NCDataset(joinpath(archive,"envar",dt2str($(sdt.value)),an_filename))
end

andf = @lift($ands["S$(lpad($(slev.value),3,"0"))$(var.val)"][:,:])

ax = Axis3(fig[1,2])
surface!(ax,andf)
fig
#ands(exp,dt::Observable) = lift(dt-> expdt2ands(exp,dt) ,dt)

#bgds_envar = lift(dt-> NCDataset(joinpath(archive,"envar",dt2str(dt-fcint),bg_filename)),dt)

ds = lift()
on(lev)

getf(ds) = lift((lev,var)-> ds["S$(lpad(lev,3,"0"))$var"],lev,var)
#function getbg(exp,lev::Observable,dt::Observable,var::Observable)
#    return lift((lev,dt,var)-> NCDataset(joinpath(archive,exp,dt2str(dt-fcint),bg_filename))["S$(lpad(lev,3,"0"))$var"],lev,dt,var)
#end 

# fields = ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]
ands = getands("envar",sdt.value)


bgf = getbg("envar",slev.value,sdt.value,field)


ax = Axis3(fig[1,2])
surface!(ax,bgf)

field[]=fields[1]
zlims!(ax,minimum(bgf.val), maximum(bgf.val))
fig



function makesurfplot(fig,bgds,ands,var,lev::Observable; surfbg=false,xrange=:,yrange=:,colormap=Reverse(:RdBu))


    field = lift( lev -> "S$(lpad(lev,3,"0"))$var", lev)  # lev  = s1.value
    title = lift( f  -> "$f" , field) 
   # pl = PointLight(Point3f(0), RGBf(20,20,20)) 
   # al = AmbientLight(RGBf(0.2,0.2,0.2))
    ax = Axis3(fig, 
         # show_axis = false,
         # scenekw = (lights=[pl,al],)
         #  aspect = :data,

           title=title ,
           viewmode  = :stretch,
          elevation = pi/2, azimuth=-pi/2  ,                       

         )
    bgf = lift( f -> bgds[f][xrange,yrange] , field) 
    anf = lift( f -> ands[f][xrange,yrange] , field) 
    
    inc = lift( (an,bg) -> an-bg, anf, bgf)
    maxabsc = lift( x -> maximum(abs.(x)),inc)
    crange = lift( m -> (-m,m),  maxabsc) 

    surffield = surfbg ? bgf : inc
    surf = surface!(ax,surffield,        
       color=inc,
       colormap=colormap,
       colorrange=crange
    )
    # zlims!(minimum(bgf.val), maximum(bgf.val))
   hidedecorations!(ax)
    hidespines!(ax)
    ax ,surf       
end





function makeprofplot(fig,bgds,ands,var,lev::Observable)
    nlev = 65
    ax = Axis(fig, 
            yreversed=true,
            xticklabelsvisible=false,
            yticklabelsvisible=false,
        #    width=100,
            yaxisposition = :right
         )
    val = zeros(nlev)
    for lev in 1:nlev
        field = "S$(lpad(lev,3,"0"))$var"
        inc = ands[field][:,:] - bgds[field][:,:]
        val[lev]= sqrt(mean(inc.^2))
    end
    lines!(ax, val, 1:65, color=:red)
    pval = lift( lev -> val[lev], lev)
    plt = scatter!(ax, pval, lev, color=:blue, markersize=20)
    # scatter!(plt, pval, lev)
    # scatter!(ax, val[lev.val], lev.val, color=:blue, markersize=10)
    ax         
end



 xrange=1:637; yrange=1:637   # All
#xrange=100:350; yrange=350:600 # Norway coast 
#xrange=200:350; yrange=450:600 # Norway mountains 
#xrange=250:550; yrange=200:500 #  Gothenborg 

# xrange=200:400; yrange=1:250 # Germany

set_theme!(theme_dark())


field = fields[1]
a1 = makesurfplot(fig[1,2],bgds1,ands1,field,slev.value,surfbg=false ,xrange=xrange, yrange=yrange)
 fig
a2 = makesurfplot(fig[1,3],bgds2,ands2,field,slev.value,surfbg=false,xrange=xrange, yrange=yrange)

fig
px1 = makeprofplot(fig[1,2,Right()],bgds1,ands1,field,s1.value)
px2 = makeprofplot(fig[1,3,Right()],bgds2,ands2,field,s1.value)
fig

# Profile plots 
