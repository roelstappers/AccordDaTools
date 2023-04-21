using GLMakie, NCDatasets


archive="/home/roel/envar/"
an_filename="MXMIN1999+0000.nc"
bg_filename="ICMSHHARM+0003.nc"

bgds = NCDataset("$archive/$bg_filename");
ands = NCDataset("$archive/$an_filename")

#bgds = NCDataset(ARGS[1])
#ands = NCDataset(ARGS[2])



fields= ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]

fig = Figure() 


s1 = Slider(fig[1,2], range = 65:-1:1, startvalue = 65,horizontal=false)
m1 = Menu(fig[2,1], options=fields, default = fields[1])

name = Observable(fields[1])
on(m1.selection) do x 
    name[] = x
    display(fig)
end 
field = lift( (lev,m)-> "S$(lpad(lev,3,"0"))$(m)", s1.value,name)
bgf = lift( f -> bgds[f][:,:] , field) 
anf = lift( f -> ands[f][:,:] , field) 
inc = lift( (an,bg) -> an-bg, anf, bgf)
maxabsc = lift( x -> maximum(abs.(x)),inc)
title = lift( (f,mac)  -> "Hi $(f) colormax $mac" , field, maxabsc)  
crange = lift( m -> (-m,m),  maxabsc) 
      
ax = Axis3(
        fig[1,1],
      #  	#   protrusions=1,
       #   aspect = DataAspect(),
          title=title,
          xlabel = "$(crange.val[1])",
          elevation = pi/2, azimuth=-pi/2  ,                       
     ) 
# ax = Axis(fig[1,1])


fields= ["TEMPERATURE", "HUMI.SPECIFI","WIND.U.PHYS","WIND.V.PHYS"]

fig = Figure() 


s1 = Slider(fig[1,1], range = 65:-1:1, startvalue = 65,horizontal=false)
m1 = Menu(fig[2,1:3], options=fields, default = fields[1])

name = Observable(fields[1])
on(m1.selection) do x 
    name[] = x
    display(fig)
end 
field = lift( (lev,m)-> "S$(lpad(lev,3,"0"))$(m)", s1.value,name)
bgf = lift( f -> bgds[f][:,:] , field) 
anf = lift( f -> ands[f][:,:] , field) 
inc = lift( (an,bg) -> an-bg, anf, bgf)
maxabsc = lift( x -> maximum(abs.(x)),inc)
title = lift( (f,mac)  -> "Hi $(f) colormax $mac" , field, maxabsc)  
crange = lift( m -> (-m,m),  maxabsc) 
      
ax = Axis3(
        fig[1,2],
      #  	#   protrusions=1,
       #   aspect = DataAspect(),
          viewmode  = :stretch,
          title=title,
          xlabel = "$(crange.val[1])",
          elevation = pi/2, azimuth=-pi/2  ,                       
     ) 
# ax = Axis(fig[1,1])
hidedecorations!(ax)
hidespines!(ax)
surf = surface!(ax,bgf,
    color=inc,
    colormap=Reverse(:RdBu),
    colorrange=crange,
    shading=true
)
Colorbar(fig[1,3],surf,ticklabelspace=30)

fig
