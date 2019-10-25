"""
This file contains all the functions that required to extract region information
from a given textfile repository, and from there extraction of relevant regional
data from given datasets.

There are three major types of functions contained in this .jl module:
1)  extraction of region information and attributes
2)  extraction of data from a given dataset based upon the given region
    information and list of attributes
3)  transformation of longitude coordinate systems [-180,180] <=> [0,360]

"""

# Region Information and Attributes

function regionload()
    @debug "$(Dates.now()) - Loading information on possible regions ..."
    return readdlm(joinpath(@__DIR__,"regions.txt"),',',comments=true);
end

function regioninfodisplay(regioninfo)
    @info "$(Dates.now()) - The following regions are offered in the ClimateTools.jl"
    for ii = 1 : size(regioninfo,1); @info "$(Dates.now()) - $(ii)) $(regioninfo[ii,6])" end
end

# Find Regions Bounds

function regionbounds(reg::AbstractString)
    reginfo = regionload(); regions = reginfo[:,1]; regid = (regions .== reg);
    N,S,E,W = reginfo[regid,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

function regionbounds(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg);
    N,S,E,W = reginfo[regid,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

function regionbounds(regID::Int64)
    reginfo = regionload();
    N,S,E,W = reginfo[regID,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

function regionbounds(regID::Int64,reginfo::AbstractArray)
    N,S,E,W = reginfo[regID,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

# Find Short Region Name

function regionshortname(regID::Int64)
    reginfo = regionload(); return reginfo[regID,1][1];
end

function regionshortname(regID::Int64,reginfo::AbstractArray)
    return reginfo[regID,1][1];
end

# Find Full Region Name

function regionfullname(reg::AbstractString)
    reginfo = regionload(); regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,7][1];
end

function regionfullname(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,7][1];
end

function regionfullname(regID::Int64)
    reginfo = regionload(); return reginfo[regID,7][1];
end

function regionfullname(regID::Int64,reginfo::AbstractArray)
    return reginfo[regID,7][1];
end

# Find Region Parent

function regionparent(reg::AbstractString)
    reginfo = regionload(); regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,2][1];
end

function regionparent(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,2][1];
end

function regionparent(regID::Int64)
    reginfo = regionload(); return reginfo[regID,2][1];
end

function regionparent(regID::Int64,reginfo::AbstractArray)
    return reginfo[regID,2][1];
end

# Find if the Region is Global

function regionisglobe(reg::AbstractString)
    reginfo = regionload(); regions = reginfo[:,1]; regid = (regions .== reg)[1];
    if regid == 1; return true; else; return false end
end

function regionisglobe(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg)[1];
    if regid == 1; return true; else; return false end
end

function regionisglobe(regID::Int64)
    if regID == 1; return true; else; return false end
end

# Find Index of given position in Region

function regionpoint(plon,plat,lon::Array,lat::Array)

    minlon = lon(argmin(lon)); maxlon = lon(argmax(lon));
    if     plon > maxlon; plon = from0360to180(plon);
    elseif plon < minlon; plon = from180to0360(plon);
    end

    @info "$(Dates.now()) - Finding grid points in data closest to requested location ..."
    ilon = argmin(abs.(lon.-plon)); ilat = argmin(abs.(lat.-plat));
    return [ilon,ilat]

end

function regiongrid(bounds,lon::Array,lat::Array)

    N,S,E,W = bounds;

    minlon = lon[argmin(lon)]; maxlon = lon[argmax(lon)];
    if     E > maxlon; E = from0360to180(E);
    elseif E < minlon; E = from180to0360(E);
    end
    if     W > maxlon; W = from0360to180(W);
    elseif W < minlon; W = from180to0360(W);
    end

    @info "$(Dates.now()) - Finding indices of data matching given boundaries ..."
    iE = argmin(abs.(lon.-E)); iW = argmin(abs.(lon.-W));
    iN = argmin(abs.(lat.-N)); iS = argmin(abs.(lat.-S));
    return [iN,iS,iE,iW]

end

# Tranformation of Coordinates

function from180to0360(lon)

    @info "$(Dates.now()) - Longitude of point given in [-180,180] but data range is [0,360].  Adjusting coordinates of point to match."
    lon = lon + 360;

end

function from0360to180(lon)

    @info "$(Dates.now()) - Longitude of point given in [0,360] but data range is [-180,180].  Adjusting coordinates of point to match."
    lon = lon - 360;

end

# Data Extraction

function regionpermute(data)
    irow = size(data,1); icol = size(data,2); nd = ndims(data)
    if irow < icol
        @info "$(Dates.now()) - Number of rows smaller than number of columns, indicating that data is in (lat,lon) rather than (lon,lat) format.  Permuting to (lon,lat) formatting."
        if     nd == 2; data = transpose(data)
        elseif nd > 2;  data = permutedims(data,vcat(2,1,convert(Array,3:nd)))
        end
    end
    return data
end

function regionextract(data,coord,ndim)

    if     ndim == 2; data = data[coord[1],coord[2]];
    elseif ndim == 3; data = data[coord[1],coord[2],:];
    elseif ndim == 4; data = data[coord[1],coord[2],:,:];
    end

end

function regionextractpoint(data,plon,plat,lon::Array,lat::Array)

    icoord = regionpoint(plon,plat,lon,lat); ndim = ndims(data)

    @info "$(Dates.now()) - Extracting data from coordinates (lon=$(plon),lat=$(plat)) from global datasets ..."
    pdata = regionextract(data,icoord,ndim)

    return pdata

end

function regionextractgrid(data,reg,lon::Array,lat::Array)

    data = regionpermute(data);

    @info "$(Dates.now()) - Determining indices of longitude and latitude boundaries in parent dataset ..."
    bounds = regionbounds(reg); nlon = length(lon); ndim = ndims(data);
    igrid  = regiongrid(bounds,lon,lat);
    iN = igrid[1]; iS = igrid[2]; iE = igrid[3]; iW = igrid[4];

    @debug "$(Dates.now()) - Creating vector of latitude indices to extract ..."
    if     iN < iS; iNS = iN : iS
    elseif iS < iN; iNS = iS : iN
    end

    @debug "$(Dates.now()) - Creating vector of longitude indices to extract ..."
    if     iW < iE; iWE = iW : iE
    elseif iW > iE; iWE = 1 : (iE + nlon - iW); ilon = vcat(iW:nlon,1:(iW-1));

        @info "$(Dates.now()) - West indice larger than East indice.  Reshaping of longitude vector required."
        lon[1:(iW-1)] = lon[1:(iW-1)] .+ 360; lon = lon[ilon];

        @info "$(Dates.now()) - Reshaping data matrix to match longitude vector ..."
        if     ndim == 2; data = data[ilon,:];
        elseif ndim == 3; data = data[ilon,:,:];
        elseif ndim == 4; data = data[ilon,:,:,:];
        end
    end

    @info "$(Dates.now()) - Extracting data for the $(regionfullname(reg)) region from global datasets ..."
    rdata = regionextract(data,[iWE,iNS],ndim)
    rgrid = [lon[iWE],lat[iNS]]

    return rdata,rgrid

end
