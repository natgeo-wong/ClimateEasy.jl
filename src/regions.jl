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

function regioncopy()
    ftem = joinpath(@__DIR__,"regionstemplate.txt")
    freg = joinpath(@__DIR__,"regions.txt")
    if !isfile(freg)
        @debug "$(Dates.now()) - Unable to find regions.txt, copying data from regionstemplate.txt ..."
        cp(ftem,freg,force=true);
    end
end

function regioninfoload()
    @debug "$(Dates.now()) - Loading information on possible regions ..."
    regioncopy(); return readdlm(joinpath(@__DIR__,"regions.txt"),',',comments=true);
end

function regioninfodisplay(regioninfo::AbstractArray)
    @info "$(Dates.now()) - The following regions are offered in the ClimateEasy.jl"
    for ii = 1 : size(regioninfo,1); @info "$(Dates.now()) - $(ii)) $(regioninfo[ii,7])" end
end

function regioninfoall()
    @info "$(Dates.now()) - The following regions and their properties are offered in the ClimateEasy.jl"

    rinfo = regioninfoload(); head = ["ID","Parent","N","W","S","E","Full Name"];
    pretty_table(rinfo,head,alignment=:c);
end

function regioninfoadd(;
    ID::AbstractString,parent::AbstractString,
    N::Integer,S::Integer,E::Integer,W::Integer,
    name::AbstractString
)

    freg = joinpath(@__DIR__,"regions.txt"); rinfo = regioninfoload();
    regID = rinfo[:,1]; regparent = rinfo[:,2]; regname = rinfo[:,7];

    if sum(regID.==ID) > 0
        error("$(Dates.now()) - Region ID already exists.  Please choose a new ID.")
    end

    open(freg,"a") do io
        writedlm(io,[ID parent N S E W name],',')
    end

end

# Find Regions Bounds

function regionbounds(reg::AbstractString)
    reginfo = regioninfoload(); regions = reginfo[:,1]; regid = (regions .== reg);
    N,S,E,W = reginfo[regid,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

function regionbounds(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg)[1];
    N,S,E,W = reginfo[regid,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

function regionbounds(regID::Integer)
    reginfo = regioninfoload();
    N,S,E,W = reginfo[regID,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

function regionbounds(regID::Integer,reginfo::AbstractArray)
    N,S,E,W = reginfo[regID,[3,5,6,4]];
    @debug "$(Dates.now()) - The bounds of the region are, in [N,S,E,W] format, [$(N),$(S),$(E),$(W)]."
    return [N,S,E,W]
end

# Find Short Region Name

function regionshortname(regID::Integer)
    reginfo = regioninfoload(); return reginfo[regID,1];
end

function regionshortname(regID::Integer,reginfo::AbstractArray)
    return reginfo[regID,1];
end

# Find Full Region Name

function regionfullname(reg::AbstractString)
    reginfo = regioninfoload(); regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,7][1];
end

function regionfullname(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,7][1];
end

function regionfullname(regID::Integer)
    reginfo = regioninfoload(); return reginfo[regID,7];
end

function regionfullname(regID::Integer,reginfo::AbstractArray)
    return reginfo[regID,7];
end

# Find Region Parent

function regionparent(reg::AbstractString)
    reginfo = regioninfoload(); regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,2][1];
end

function regionparent(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg);
    return reginfo[regid,2][1];
end

function regionparent(regID::Integer)
    reginfo = regioninfoload(); return reginfo[regID,2];
end

function regionparent(regID::Integer,reginfo::AbstractArray)
    return reginfo[regID,2];
end

# Find if the Region is Global

function regionisglobe(reg::AbstractString)
    reginfo = regioninfoload(); regions = reginfo[:,1]; regid = (regions .== reg);
    if regid == 1; return true; else; return false end
end

function regionisglobe(reg::AbstractString,reginfo::AbstractArray)
    regions = reginfo[:,1]; regid = (regions .== reg);
    if regid == 1; return true; else; return false end
end

function regionisglobe(regID::Integer)
    if regID == 1; return true; else; return false end
end

# Find if Point / Grid is in specified Regions

function ispointinregion(
    plon::Real, plat::Real,
    lon::Vector{<:Real}, lat::Vector{<:Real}
)

    minlon = mod(minimum(lon),360);  minlat = minimum(lat);
    maxlon = mod(maximum(lon),360);  maxlat = maximum(lat);
    thrlon = abs((lon[2]-lon[1])/2); thrlat = abs((lat[2]-lat[1])/2);

    if (minlon < maxlon && (plon < (minlon-thrlon) || plon > (maxlon+thrlon))) ||
        (minlon > maxlon && (plon < (maxlon-thrlon) && plon > (minlon+thrlon))) ||
        plat < (minlat-thrlat) || plat > (maxlat+thrlat)

          error("$(Dates.now()) - Requested grid points are not in Region ...")

    end

end

function ispointinregion(plon::Real,plat::Real,reg)

    rN,rS,rE,rW = regionbounds(reg); rW = mod(rW,360); rE = mod(rE,360);

    if (rW < rE && (plon < rW || plon > rE)) || (rW > rE && (plon < rE && plon > rW)) ||
        plat < S || plat > N

          error("$(Dates.now()) - Requested grid points are not in Region ...")
    end

end

function ispointinregion(pcoord::Vector{<:Real},lon::Vector{<:Real},lat::Vector{<:Real})

    plon,plat = pcoord;
    minlon = mod(minimum(lon),360);  minlat = minimum(lat);
    maxlon = mod(maximum(lon),360);  maxlat = maximum(lat);
    thrlon = abs((lon[2]-lon[1])/2); thrlat = abs((lat[2]-lat[1])/2);

    if (minlon < maxlon && (plon < (minlon-thrlon) || plon > (maxlon+thrlon))) ||
        (minlon > maxlon && (plon < (maxlon-thrlon) && plon > (minlon+thrlon))) ||
        plat < (minlat-thrlat) || plat > (maxlat+thrlat)

          error("$(Dates.now()) - Requested grid points are not in Region ...")

    end

end

function ispointinregion(pcoord::Vector{<:Real},reg)

    plon,plat = pcoord; rN,rS,rE,rW = regionbounds(reg);
    rW = mod(rW,360); rE = mod(rE,360);

    if (rW < rE && (plon < rW || plon > rE)) || (rW > rE && (plon < rE && plon > rW)) ||
        plat < S || plat > N

          error("$(Dates.now()) - Requested grid points are not in Region ...")

    end

end

function isgridinregion(bounds::Array,reg)

    N,S,E,W = bounds; rN,rS,rE,rW = regionbounds(reg);
    E = mod(E,360); rE = mod(rE,360); W = mod(W,360); rW = mod(rW,360);

    if (rW < rE && (E < rW || E > rE)) || (rW > rE && (E < rE && E > rW)) ||
        (rW < rE && (W < rW || W > rE)) || (rW > rE && (W < rE && W > rW)) ||
        N < rS || N > rN || S < rS || S > rN

          error("$(Dates.now()) - Requested grid points are not in Region ...")

    end

end

function isgridinregion(bounds::Array,lon::Vector{<:Real},lat::Vector{<:Real})

    N,S,E,W = bounds; E = mod(E,360); W = mod(W,360);
    maxlon = mod(maximum(lon),360);  maxlat = maximum(lat);
    minlon = mod(minimum(lon),360);  minlat = minimum(lat);
    thrlon = abs((lon[2]-lon[1])/2); thrlat = abs((lat[2]-lat[1])/2);

    if (minlon < maxlon && (E < (minlon-thrlon) || E > (maxlon+thrlon))) ||
        (minlon > maxlon && (E < (maxlon-thrlon) && E > (minlon+thrlon))) ||
        (minlon < maxlon && (W < (minlon-thrlon) || W > (maxlon+thrlon))) ||
        (minlon > maxlon && (W < (maxlon-thrlon) && W > (minlon+thrlon))) ||
        N < (minlat-thrlat) || N > (maxlat+thrlat) ||
        S < (minlat-thrlat) || S > (maxlat+thrlat)

          error("$(Dates.now()) - Requested grid points are not in Region ...")

    end

end

# Find Index of given position in Region

function regionpoint(
    plon::Real, plat::Real,
    lon::Vector{<:Real}, lat::Vector{<:Real}
)

    plon = mod(plon,360); ispointinregion(plon,plat,lon,lat)

    @debug "$(Dates.now()) - Finding grid points in data closest to requested location ..."
    lon = mod.(lon,360); ilon = argmin(abs.(lon.-plon)); ilat = argmin(abs.(lat.-plat));

    return [ilon,ilat]

end

function regiongrid(bounds::Array,lon::Vector{<:Real},lat::Vector{<:Real})

    N,S,E,W = bounds; isgridinregion(bounds,lon,lat)

    @debug "$(Dates.now()) - Finding indices of data matching given boundaries ..."

    E = mod(E,360); W = mod(W,360); lon = mod.(lon,360);
    iN = argmin(abs.(lat.-N)); iS = argmin(abs.(lat.-S)); iW = argmin(abs.(lon.-W));
    if E == W;
        if bounds[3] != bounds[4]
              if iW != 1; iE = iW - 1; else; iE = length(lon); end
        else; iE = iW
        end
    else; iE = argmin(abs.(lon.-E)); iW = argmin(abs.(lon.-W));
    end

    return [iN,iS,iE,iW]

end

function regiongridvec(reg,lon::Vector{<:Real},lat::Vector{<:Real})

    @debug "$(Dates.now()) - Determining indices of longitude and latitude boundaries in parent dataset ..."
    bounds = regionbounds(reg); igrid = regiongrid(bounds,lon,lat);
    iN = igrid[1]; iS = igrid[2]; iE = igrid[3]; iW = igrid[4];

    @debug "$(Dates.now()) - Creating vector of latitude indices to extract ..."
    if     iN < iS; iNS = iN : iS
    elseif iS < iN; iNS = iS : iN
    else;           iNS = iN;
    end

    @debug "$(Dates.now()) - Creating vector of longitude indices to extract ..."
    if     iW < iE; iWE = iW : iE
    elseif iW > iE || (iW == iE && bounds[3] != bounds[4])
        iWE = 1 : (iE + length(lon) + 1 - iW);
        lon[1:(iW-1)] = lon[1:(iW-1)] .+ 360; lon = circshift(lon,1-iW);
    else
        iWE = iW;
    end

    reginfo = Dict("boundsID"=>igrid,"IDvec"=>[iWE,iNS],"fullname"=>regionfullname(reg))

    return lon[iWE],lat[iNS],reginfo

end

function regiongridvec(bounds::Array{<:Real,1},lon::Vector{<:Real},lat::Vector{<:Real})

    @debug "$(Dates.now()) - Determining indices of longitude and latitude boundaries in parent dataset ..."
    igrid = regiongrid(bounds,lon,lat); iN,iS,iE,iW = regiongrid(bounds,lon,lat);

    @debug "$(Dates.now()) - Creating vector of latitude indices to extract ..."
    if     iN < iS; iNS = iN : iS
    elseif iS < iN; iNS = iS : iN
    else;           iNS = iN;
    end

    @debug "$(Dates.now()) - Creating vector of longitude indices to extract ..."
    if     iW < iE; iWE = iW : iE
    elseif iW > iE || (iW == iE && bounds[3] != bounds[4])
        iWE = 1 : (iE + length(lon) + 1 - iW);
        lon[1:(iW-1)] = lon[1:(iW-1)] .+ 360; lon = circshift(lon,1-iW);
    else
        iWE = iW;
    end

    reginfo = Dict("boundsID"=>igrid,"IDvec"=>[iWE,iNS]);

    return lon[iWE],lat[iNS],reginfo

end

# Tranformation of Coordinates

function from180to0360(lon::Vector{<:Real})

    @info "$(Dates.now()) - Longitude of point given in [-180,180] but data range is [0,360].  Adjusting coordinates of point to match."
    lon = lon + 360;

end

function from0360to180(lon::Vector{<:Real})

    @info "$(Dates.now()) - Longitude of point given in [0,360] but data range is [-180,180].  Adjusting coordinates of point to match."
    lon = lon - 360;

end

# Data Extraction

# function regionpermute(data)
#     irow = size(data,1); icol = size(data,2); nd = ndims(data)
#     if irow < icol
#         @info "$(Dates.now()) - Number of rows smaller than number of columns, indicating that data is in (lat,lon) rather than (lon,lat) format.  Permuting to (lon,lat) formatting."
#         if     nd == 2; data = transpose(data)
#         elseif nd > 2;  data = permutedims(data,vcat(2,1,convert(Array,3:nd)))
#         end
#     end
#     return data
# end

function regionextract(data::Array{<:Real},coord::Array,ndim::Integer)

    nlon1 = length(coord[1]); nlon2 = size(data,1);
    nlat1 = length(coord[2]); nlat2 = size(data,2);
    nt = size(data)[3:end];

    if ndim == 2; data = data[coord[1],coord[2]];
    elseif ndim >= 3;
        data = reshape(data,nlon2,nlat2,:)
        data = data[coord[1],coord[2],:];
        data = reshape(data,Tuple(vcat(nlon1,nlat1,nt...)));
    end

    return data

end

function regionextract(data::Array{<:Real},coord::Array)

    nlon1 = length(coord[1]); nlon2 = size(data,1);
    nlat1 = length(coord[2]); nlat2 = size(data,2);
    nt = size(data)[3:end]; ndim = ndims(data);

    if ndim == 2; data = data[coord[1],coord[2]];
    elseif ndim >= 3;
        data = reshape(data,nlon2,nlat2,:);
        data = data[coord[1],coord[2],:];
        data = reshape(data,Tuple(vcat(nlon1,nlat1,nt...)));
    end

    return data

end

function regionextractpoint(
    data::Array{<:Real},
    plon::Real, plat::Real,
    lon::Vector{<:Real}, lat::Vector{<:Real}
)

    icoord = regionpoint(plon,plat,lon,lat); ndim = ndims(data)

    @info "$(Dates.now()) - Extracting data from coordinates (lon=$(plon),lat=$(plat)) from global datasets ..."
    pdata = regionextract(data,icoord,ndim)

    return pdata

end

function regionextractgrid(
    data::Array{<:Real},
    reg, lon::Vector{<:Real}, lat::Vector{<:Real},
    tmp::Array{<:Real}
)

    @debug "$(Dates.now()) - Determining indices of longitude and latitude boundaries in parent dataset ..."
    bounds = regionbounds(reg); nlon = length(lon); ndim = ndims(data);
    igrid  = regiongrid(bounds,lon,lat);
    iN = igrid[1]; iS = igrid[2]; iE = igrid[3]; iW = igrid[4];

    @debug "$(Dates.now()) - Creating vector of latitude indices to extract ..."
    if     iN < iS; iNS = iN : iS
    elseif iS < iN; iNS = iS : iN
    end

    @debug "$(Dates.now()) - Creating vector of longitude indices to extract ..."
    if     iW < iE; iWE = iW : iE

        @info "$(Dates.now()) - Extracting data for the $(regionfullname(reg)) region from global datasets ..."
        rdata = regionextract(data,[iWE,iNS],ndim)

    elseif iW > iE; iWE = 1 : (iE + nlon + 1 - iW);

        circshift!(tmp,data,1-iW);
        @info "$(Dates.now()) - Extracting data for the $(regionfullname(reg)) region from global datasets ..."
        rdata = regionextract(tmp,[iWE,iNS],ndim)

    end

    return rdata

end

function regionextractgrid(
    data::Array{<:Real},
    reginfo::Dict, lon::Vector{<:Real}, lat::Vector{<:Real},
    tmp::Array{<:Real}
)

    iW = reginfo["boundsID"][4]; iE = reginfo["boundsID"][3];

    if iW > iE; circshift!(tmp,data,1-iW);
          rdata = regionextract(tmp,reginfo["IDvec"]);
    else; rdata = regionextract(data,reginfo["IDvec"]);
    end

    return rdata

end
