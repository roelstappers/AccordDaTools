

# Read netcdf file
import netCDF4 as nc

nc = Dataset('singleobs.nc', 'r')

# Print the variables
print(nc.variables.keys())
