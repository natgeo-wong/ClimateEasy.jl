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

# Single-Unit Functions
function yr2str(dnt::Date)
    return @sprintf("%04d",Dates.year(dnt));
end

function mo2str(dnt::Date)
    return @sprintf("%02d",Dates.month(dnt));
end

function dy2str(dnt::Date)
    return @sprintf("%02d",Dates.day(dnt));
end

function hr2str(dnt::Date)
    return @sprintf("%02d",Dates.hour(dnt));
end

function mi2str(dnt::Date)
    return @sprintf("%02d",Dates.minute(dnt));
end

# Multi-Unit Functions
function yrmo2str(dnt::Date)
    yr = Dates.year(dnt); mo = Dates.month(dnt);
    return @sprintf("%04d%02d",yr,mo);
end

function ymd2str(dnt::Date)
    yr = Dates.year(dnt); mo = Dates.month(dnt); dy = Dates.day(dnt);
    return @sprintf("%04d%02d%02d",yr,mo,dy);
end

function ymdhm2str(dnt::Date)
    yr = Dates.year(dnt); mo = Dates.month(dnt); dy = Dates.day(dnt);
    hr = Dates.hour(dnt); mi = Dates.minute(dnt);
    return @sprintf("%04d%02d%02d%02d%02d00",yr,mo,dy,hr,mi);
end

# Directory Functions
function yrmo2dir(dnt::Date)
    yr = Dates.year(dnt); mo = Dates.month(dnt);
    return @sprintf("%04d/%02d",yr,mo);
end

function ymd2dir(dnt::Date)
    yr = Dates.year(dnt); mo = Dates.month(dnt); dy = Dates.day(dnt);
    return @sprintf("%04d/%02d/%02d",yr,mo,dy);
end

function yrdy2dir(dnt::Date)
    yr = Dates.year(dnt); dy = Dates.dayofyear(dnt);
    return @sprintf("%04d/%02d",yr,dy);
end
