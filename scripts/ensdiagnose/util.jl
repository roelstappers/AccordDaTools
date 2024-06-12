
"""
Given an abitray matrix splits into ensemble mean, std and Perturbation matrix
ensind  is the index for the ensemble dimension

    X, m, stdd = splitstdmean(fld,ensind=3)
"""
function splitstdmean(fld,ensind=3)    
    nmbrs = size(fld)[ensind]
    m = mean(fld,dims=ensind)
    stdd = std(fld,dims=ensind)
    X = (fld .- m)./(stdd*(sqrt(nmbrs-1)))
    return X,m[:,:,1],stdd[:,:,1]
end 