using Dates, Statistics, NCDatasets, CSV

archive="/lustre/storeB/immutable/archive/projects/metproduction/MEPS/"
fcint  = Hour(3) 
nlev=65
# SURFPRESSION
vars = ["air_temperature_ml", "specific_humidity_ml","x_wind_ml","y_wind_ml"]
var  = vars[1]


dspath(dtg) = joinpath(archive,Dates.format(dtg,"yyyy/mm/dd"), "meps_det_2_5km_$(Dates.format(dtg,"yyyymmddTHHZ.nc"))") 

function getinc(dtg)
    ands = NCDataset(dspath(dtg))[var][:,:,:,1]
    bgds = NCDataset(dspath(dtg-fcint))[var][:,:,:,1+fcint.value]
    return ands - bgds    
end


# month=10
dtgbeg = Dates.DateTime(2022,01,01,00)
dtgbeg = Dates.DateTime(2023,01,01,00)- fcint(3)

#dtgend = dtgbeg + Month(1) - Hour(3)
dtrange = dtgbeg:fcint:dtgend


rmsio = open("Nrms$var$(Dates.format(dtgbeg,"yyyymm")).txt","a")
meanio = open("Nmean$var$(Dates.format(dtgbeg,"yyyymm")).txt","a")



for dtg in dtrange 
    println(dtg)
    inc = try getinc(dtg); catch e; fill(NaN,1,1,65) end 
    rmsinc = sqrt.(Statistics.mean(inc.^2,dims=[1,2]))
    meaninc = Statistics.mean(inc,dims=[1,2])
    write(rmsio, "$dtg, $(join(rmsinc,','))\n")
    write(meanio, "$dtg, $(join(meaninc,','))\n")
    close(rmsio)
    close(meanio)
end 

close(rmsio)
close(meanio)

