
@kwdef struct PPIInternal 
    archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
    fcint = 3
end 

constructpath(::PPIInternal, x) = Dates.format(x,"yyyy/mm/dd") *"/meps_det_2_5km_" * Dates.format(x,"yyyymmddTHHZ.nc")
NCDataset(a::PPIInternal, dtg) = NCDataset(joinpath(a.archive, constructpath(a,dtg)))

function inc(a::PPIInternal, dtg)
    ands = NCDataset(a.archive,dtg)[var][:,:,:,1]
    bgds = NCDataset(a.archive,dtg-Hour(a.fcint))[var][:,:,:,1+fcint]
    return ands - bgds    
end



#################################################################

@kwdef struct Thredds 
    url="https://thredds.met.no/thredds/dodsC/meps25epsarchive"
end 

url(dtg) = joinpath(mepsurl,Dates.format(dtg,"yyyy/mm/dd"), "meps_det_2_5km_$(Dates.format(dtg,"yyyymmddTHHZ")).nc")
querystr(ll,lev,var) = "?$var[$ll][$(lev-1)][0:1:$(nlat-1)][0:1:$(nlon-1)]"

NCDataset(::Thredds, dtg) = NCDataset(url(dtg-fcint) * querystr(ll+fcint.value,lev,var))
an(dtg,lev,var,ll) = NCDataset(url(dtg) * querystr(ll,lev,var))



