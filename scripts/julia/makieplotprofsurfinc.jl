using GLMakie, NCDatasets, Statistics, Dates
Makie.inline!(false)
set_theme!(theme_light())
GLMakie.set_window_config!(;float=true)

dt = Dates.DateTime(2019,08,18,03)
fcint = Hour(3)
dtf = Dates.format(dt,"yyyymmddHH")
dtp = Dates.format(dt-fcint,"yyyymmddHH")
archive="/home/roels/plots/"

fields = ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]
an_filename="MXMIN1999+0000.nc"   # Needs /YYYY/MN/DD/HH
bg_filename="ICMSHHARM+0003.nc"

expenvar = "envar"
bgds1 = NCDataset(joinpath(archive,expenvar,dtp,bg_filename));
ands1 = NCDataset(joinpath(archive,expenvar,dtf,an_filename));

exp3dvar = "3dvar"
bgds2 = NCDataset(joinpath(archive,exp3dvar,dtp,bg_filename));
ands2 = NCDataset(joinpath(archive,exp3dvar,dtf,an_filename));


#bgds = NCDataset(ARGS[1])
#ands = NCDataset(ARGS[2])

function makesurfplot(fig,bgds,ands,var,lev::Observable; surfbg=false,xrange=:,yrange=:,colormap=Reverse(:RdBu))

    field = lift( lev -> "S$(lpad(lev,3,"0"))$var", lev)  # lev  = s1.value
    title = lift( f  -> "$f" , field) 
   # pl = PointLight(Point3f(0), RGBf(20,20,20)) 
   # al = AmbientLight(RGBf(0.2,0.2,0.2))
    ax = Axis3(fig, 
         # show_axis = false,
         # scenekw = (lights=[pl,al],)
          # aspect = :data,

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
    ax        
end

function makeprofplot(ax,bgds,ands,var,lev::Observable;label,color)
    nlev = 65
 #   ax = Axis(fig, 
 #           yreversed=true,
     #       xticklabelsvisible=false,
     #       yticklabelsvisible=false,
     #       width=100,
  #          yaxisposition = :right
  #       )
    rms = zeros(nlev)
    means = zeros(nlev)
    
    for lev in 1:nlev
        field = "S$(lpad(lev,3,"0"))$var"
        inc = ands[field][:,:] - bgds[field][:,:]
        rms[lev]= sqrt(mean(inc.^2))
        means[lev]= mean(inc)
    end
#    lines!(ax, rms, 1:65, label=label,linestyle=:dash,color=color)
    lines!(ax, means, 1:65, label=label,color=color)
    
    pval = lift( lev -> rms[lev], lev)
 #   scatter!(ax, pval, lev, color=color, markersize=20)
    mval = lift( lev -> means[lev], lev)
    scatter!(ax, mval, lev, color=color, markersize=20)
    
    # scatter!(plt, pval, lev)
    # scatter!(ax, val[lev.val], lev.val, color=:blue, markersize=10)
    ax         
end




 xrange=1:637; yrange=1:637   # All
#xrange=100:350; yrange=350:600 # Norway coast 
#xrange=200:350; yrange=450:600 # Norway mountains 
#xrange=250:550; yrange=200:500 #  Gothenborg 

# xrange=200:400; yrange=1:250 # Germany


fig = Figure() 
s1 = Slider(fig[1:1,1], range = 65:-1:1, startvalue = 65,horizontal=false)


field = fields[1]
lev = Observable(65)
surfbg=false
a1 = makesurfplot(fig[1,2],bgds1,ands1,field,s1.value,surfbg=surfbg, xrange=xrange, yrange=yrange)
fig
a2 = makesurfplot(fig[1,3],bgds2,ands2,field,s1.value,surfbg=surfbg, xrange=xrange, yrange=yrange)


ax = Axis(fig[1,4], yreversed=true,title="Mean", width=200, yaxisposition = :right,yticks=65:-5:0)
px1 = makeprofplot(ax,bgds1,ands1,field,s1.value,label="envar",color=:blue)
px2 = makeprofplot(ax,bgds2,ands2,field,s1.value,label="3dvar",color=:red)
tightlimits!(ax)

Legend(fig[2, :],ax, orientation=:horizontal, tellheight=true ) 
Makie.inline!(false)
fig





levels=65:-1:1

a1.elevation[] =  a2.elevation[] = pi/2-0.4
a1.azimuth[] = a2.azimuth[] = -1.7
xlims!(a1,1,637); xlims!(a2,1,637)
ylims!(a1,1,637); ylims!(a2,1,637)
# zlims!(a1,-1.5,1.5); zlims!(a2,-1.5,1.5)


function f(levs) 
    lev[] = levs
  #  a1.elevation[] = a1.elevation[]+0.01
    a1.azimuth[] = a1.azimuth[]+0.01
   # a2.elevation[] = a2.elevation[]+0.01
    a2.azimuth[] = a2.azimuth[]+0.01
    autolimits!(a1)
    autolimits!(a2)

end
Makie.inline!(false)
fig

#record(f,fig, "envar_3dvar_huminc.mp4", levels; framerate = 3) 
    # lev[] = levs
    

