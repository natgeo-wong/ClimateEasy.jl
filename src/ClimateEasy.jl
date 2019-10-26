module ClimateEasy

# Main file for the ClimateEasy module that provides a range of useful
# commands written in Julia that allows one to easily perform commonly-needed
# tasks such as:
#   - Converting dates and times to string format (e.g. YYYYMMDD)
#   - Generating vectors of dates
#   - Decomposing datestrings into their relevant components
#   - Plotting on maps (requires CartoPy in conda package manager)

## Modules Used
using Pkg, Dates, DelimitedFiles, Printf
using Conda, PyCall, PyPlot

## Adding relevant Python Functions
Conda.add("matplotlib");
Conda.add("cartopy");
Conda.add("pyhdf",channel="conda-forge")

## Exporting functions
export
       yr2str, mo2str, dy2str, hr2str, mi2str, yrmo2str, ymd2str, ymdhm2str,
       yrmo2dir, ymd2dir, yrdy2dir,
       regionload, regioninfodisplay, regionshortname, regionfullname, regionparent,
       regionbounds, regionpoint, regiongrid,
       regionextract, regionextractpoint, regionextractgrid,
       from0360to180, from180to0360,
       convert2hourly, convert23hourly, convert2daily,
       convert2regionmean, convert2zonalmean, convert2meridionalmean,
       mollweide, robinson, coastlines,
       h4read, clearclustermem

include("dnt2str.jl")
include("regions.jl")
include("processing.jl")
include("hdf4.jl")
include("mapping.jl")
include("misc.jl")

end # module
