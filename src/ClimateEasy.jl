module ClimateEasy

using Pkg, Logging
@warn "ClimateEasy.jl has been deprecated in favour of GeoRegions.jl, installing GeoRegions.jl now ..."

Pkg.add("GeoRegions")

end # module
