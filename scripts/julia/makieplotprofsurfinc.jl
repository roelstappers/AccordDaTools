using GLMakie, NCDatasets

archive="/home/roel/envar/"
an_filename="MXMIN1999+0000.nc"
bg_filename="ICMSHHARM+0003.nc"

bgds = NCDataset("$archive/$bg_filename");
ands = NCDataset("$archive/$an_filename")

#bgds = NCDataset(ARGS[1])
#ands = NCDataset(ARGS[2])

function makesurfplot(fig,var,lev::Observable; surfbg=false)

    field = lift( lev -> "S$(lpad(lev,3,"0"))$var", lev)  # lev  = s1.value
    title = lift( f  -> "$f" , field)  
    ax = Axis3(fig, 
             title=title ,
             viewmode  = :stretch,
             elevation = pi/2, azimuth=-pi/2  ,                       

         )
    bgf = lift( f -> bgds[f][:,:] , field) 
    anf = lift( f -> ands[f][:,:] , field) 
    inc = lift( (an,bg) -> an-bg, anf, bgf)
    maxabsc = lift( x -> maximum(abs.(x)),inc)
    crange = lift( m -> (-m,m),  maxabsc) 

    surffield = surfbg ? bgf : inc
    surf = surface!(ax,surffield,        
       color=inc,
       colormap=Reverse(:RdBu),
       colorrange=crange
    )
    hidedecorations!(ax)
    hidespines!(ax)
    ax         
end

function makeprofplot(fig,bgds,ands,var,lev::Observable)
    nlev = 65
    ax = Axis(fig, 
            yreversed=true,
            xticklabelsvisible=false,
            yticklabelsvisible=false,

            yaxisposition = :right
         )
    val = zeros(nlev)
    for lev in 1:nlev
        field = "S$(lpad(lev,3,"0"))$var"
        inc = ands[field][:,:] - bgds[field][:,:]
        val[lev]= sum(inc.^2)
    end
    lines!(ax, val, 1:65, color=:red)
    pval = lift( lev -> val[lev], lev)
    plt = scatter!(ax, pval, lev, color=:blue, markersize=10)
    # scatter!(plt, pval, lev)
    # scatter!(ax, val[lev.val], lev.val, color=:blue, markersize=10)
    ax         
end


fields= ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]

set_theme!(theme_dark())
fig = Figure() 
s1 = Slider(fig[1:2,1], range = 65:-1:1, startvalue = 65,horizontal=false)
a1 = makesurfplot(fig[1,2],fields[1],s1.value,surfbg=true)
a2 = makesurfplot(fig[1,3],fields[2],s1.value,surfbg=true)
a3 = makesurfplot(fig[2,2],fields[3],s1.value,surfbg=true)
a4 = makesurfplot(fig[2,3],fields[4],s1.value,surfbg=true)
fig

makeprofplot(fig[1,2,Right()],bgds,ands,fields[1],s1.value)
makeprofplot(fig[1,3,Right()],bgds,ands,fields[2],s1.value)
makeprofplot(fig[2,2,Right()],bgds,ands,fields[3],s1.value)
ax = makeprofplot(fig[2,3,Right()],bgds,ands,fields[4],s1.value)
fig

