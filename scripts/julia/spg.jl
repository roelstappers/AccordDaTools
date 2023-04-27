
using GaussianRandomFields
using GLMakie
fig=Figure()
sl1 = Slider(fig[2,1], range = 1:2:10, startvalue=4 )
sl2= Slider(fig[3,1], range = 1:2, startvalue=2 )

pts = range(0, stop=60, step=0.1)
# cov = @lift(CovarianceFunction(2, Matern($(sl1.value), $(sl2.value))))
cov = @lift(CovarianceFunction(2, Gaussian($(sl1.value)))) 

grf = @lift(GaussianRandomField($cov, CirculantEmbedding(), pts, pts, minpadding=113))


data = @lift(sample($grf))

ax = Axis3(fig[1,1],viewmode=:stretch)
# title = @lift("Length scale $(sl1.value)" Smoothness  " * $(sl2.value))
surface!(ax, data)  
fig



# time depdendence
timerange = 1:1:100
fig = Figure()
sl3 = Slider(fig[2,1], range = timerange, startvalue=1 )

sl4 = Slider(fig[3,1], range = 1:1:10, startvalue=8 )

pts = range(0, stop=100, step=1)
# cov = @lift(CovarianceFunction(2, Matern($(sl1.value), $(sl2.value))))
cov = @lift(CovarianceFunction(3, Gaussian($(sl4.value)))) 
grf = @lift(GaussianRandomField($cov, CirculantEmbedding(), timerange, pts, pts))# , minpadding=300))

data = @lift(sample($grf))
slice = @lift(data.val[$(sl3.value),:,:])

ax = Axis3(fig[1,1],viewmode=:stretch)
# title = @lift("Length scale $(sl1.value)" Smoothness  " * $(sl2.value))
surface!(ax, slice)  
fig

