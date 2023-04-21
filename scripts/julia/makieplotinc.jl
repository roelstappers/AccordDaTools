using GLMakie, NCDatasets


archive="/home/roels/plots/envar/"
an_filename="MXMIN1999+0000.nc"
bg_filename="ICMSHHARM+0003.nc"

bgds = NCDataset("$archive/$bg_filename");
ands = NCDataset("$archive/$an_filename")

#bgds = NCDataset(ARGS[1])
#ands = NCDataset(ARGS[2])



fields= ["TEMPERATURE", "HUMI.SPECIFI"]
fields= ["HUMI.SPECIFI","TEMPERATURE"]


fig = Figure() 


s1 = Slider(fig[2,1], range = 1:65, startvalue = 65)
field = lift( lev -> "S$(lpad(lev,3,"0"))$(fields[1])", s1.value)
bgf = lift( f -> bgds[f][:,:] , field) 
anf = lift( f -> ands[f][:,:] , field) 
inc = lift( (an,bg) -> an-bg, anf, bgf)
maxabsc = lift( x -> maximum(abs.(x)),inc)
title = lift( (f,mac)  -> "Hi $(f) colormax $mac" , field, maxabsc)  
crange = lift( m -> (-m,m),  maxabsc) 
      
ax = Axis3(
        fig[1,1],
       	#   protrusions=1,
          title=title,
          xlabel = "$(crange.val[1])",
          elevation = pi/2, azimuth=-pi/2  ,                       
     ) 

hidedecorations!(ax)
hidespines!(ax)
surface!(ax,bgf,
    color=inc,
    colormap=Reverse(:RdBu),
    colorrange=crange
)
