using GLMakie, NCDatasets

an = "/lustre/storeB/immutable/archive/projects/metproduction/MEPS/2022/08/18/meps_det_2_5km_20220818T03Z.nc"


ands = NCDataset(an)

lev=65; hour=1
@time ands["air_temperature_ml"][:,:,lev,hour]