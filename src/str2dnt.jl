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
function str2yrmo(datestring::AbstractString)
    yr = parse(Int64,datestring[1:4]);
    mo = parse(Int64,datestring[5:6]);
    return Date(yr,mo)
end

function str2ymd(datestring::AbstractString)
    yr = parse(Int64,datestring[1:4]);
    mo = parse(Int64,datestring[5:6]);
    dy = parse(Int64,datestring[7:8]);
    return Date(yr,mo,dy)
end

function str2ymdhms(datestring::AbstractString)
    yr = parse(Int64,datestring[1:4]);
    mo = parse(Int64,datestring[5:6]);
    dy = parse(Int64,datestring[7:8]);
    hr = parse(Int64,datestring[9:10]);
    mi = parse(Int64,datestring[11:12]);
    sc = parse(Int64,datestring[13:14]);
    return DateTime(yr,mo,dy,hr,mi,sc)
end
