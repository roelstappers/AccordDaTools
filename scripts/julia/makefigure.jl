function makefigure(levs,dtrange,bgds,ands)


    fig = Figure()
    sdt = Slider(fig[2,2], range = dtrange, startvalue = dtrange[1],horizontal=true)
    slev = Slider(fig[1,1], range = reverse(levs), startvalue = maximum(levs),horizontal=false)
#     menu = Menu(fig[2,1], options = ["inc","bg"], default= "inc",tellwidth=true)
  #   fig
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
    

end 



