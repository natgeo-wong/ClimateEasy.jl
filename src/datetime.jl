"""
This file contains all the functions that could be commonly used to convert
dates to strings.  This is a very important and necessary tool in climate
observation and reanalysis data, because files are often saved in certain
formats that include the date and time of the observation.

There following types of functions are contained in this .jl module:
1)  single-unit conversion functions (e.g. yr2str) that extracts only a single
    time-unit and converts it to a string
2)  multi-unit conversion functions (e.g. ymd2str) that extracts and combines
    various different time units into a string
3)  conversion of dates into folder directories

"""

# Single-Unit String Functions
yr2str(dnt::TimeType) = @sprintf("%04d",Dates.year(dnt))
mo2str(dnt::TimeType) = @sprintf("%02d",Dates.month(dnt))
dy2str(dnt::TimeType) = @sprintf("%02d",Dates.day(dnt))
hr2str(dnt::TimeType) = @sprintf("%02d",Dates.hour(dnt))
mi2str(dnt::TimeType) = @sprintf("%02d",Dates.minute(dnt))

mo2str(mo::Integer) = @sprintf("%02d",mo)
dy2str(dy::Integer) = @sprintf("%02d",dy)
hr2str(hr::Integer) = @sprintf("%02d",hr)
mi2str(mi::Integer) = @sprintf("%02d",mi)

# Multi-Unit String Functions
function yrmo2str(dnt::TimeType)
    yr = Dates.year(dnt); mo = Dates.month(dnt);
    return @sprintf("%04d%02d",yr,mo);
end

function ymd2str(dnt::TimeType)
    yr = Dates.year(dnt); mo = Dates.month(dnt); dy = Dates.day(dnt);
    return @sprintf("%04d%02d%02d",yr,mo,dy);
end

function ymdhm2str(dnt::TimeType)
    yr = Dates.year(dnt); mo = Dates.month(dnt); dy = Dates.day(dnt);
    hr = Dates.hour(dnt); mi = Dates.minute(dnt);
    return @sprintf("%04d%02d%02d%02d%02d00",yr,mo,dy,hr,mi);
end

yrmo2str(yr::Integer,mo::Integer) = @sprintf("%04d%02d",yr,mo)
ymd2str(yr::Integer,mo::Integer,dy::Integer) = @sprintf("%04d%02d%02d",yr,mo,dy)

function ymdhm2str(yr::Integer,mo::Integer,dy::Integer,hr::Integer,mi::Integer)
    return @sprintf("%04d%02d%02d%02d%02d",yr,mo,dy,hr,mi)
end

# Directory String Functions
function yrmo2dir(dnt::TimeType)
    yr = Dates.year(dnt); mo = Dates.month(dnt);
    return @sprintf("%04d/%02d",yr,mo);
end

function ymd2dir(dnt::TimeType)
    yr = Dates.year(dnt); mo = Dates.month(dnt); dy = Dates.day(dnt);
    return @sprintf("%04d/%02d/%02d",yr,mo,dy);
end

function yrdy2dir(dnt::TimeType)
    yr = Dates.year(dnt); dy = Dates.dayofyear(dnt);
    return @sprintf("%04d/%03d",yr,dy);
end

yrmo2dir(yr::Integer,mo::Integer) = @sprintf("%04d/%02d",yr,mo)
ymd2dir(yr::Integer,mo::Integer,dy::Integer) = @sprintf("%04d/%02d/%02d",yr,mo,dy)
yrdy2dir(yr::Integer,ndy::Integer) = @sprintf("%04d/%03d",yr,ndy);

# Convert Season to Months

function dntsea2mon(season::Int)

    if     season == 0; return ':';
    elseif season == 1; return [12,1,2]; elseif season == 2; return [3,4,5];
    elseif season == 3; return [6,7,8];  elseif season == 4; return [9,10,11];
    end

end

function dntsea2mon(season::AbstractString)

    if     season == "all"; return ':';
    elseif season == "DJF"; return [12,1,2]; elseif season == "MAM"; return [3,4,5];
    elseif season == "JJA"; return [6,7,8];  elseif season == "SON"; return [9,10,11];
    end

end
