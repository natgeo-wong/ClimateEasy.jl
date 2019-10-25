"""
This file contains all the functions that are required to do basic processing of
climate data, such as averaging of data into hourly, 3-hourly and daily bins, or
in the creation of Hovmöller diagrams and frequency bins.

This function assumes that the datasets (for the averaging/summing of data)
follow the following formats:
    - dimensions in the form (longitude,latitude,time)
    - contains data for a single day, for daily and hourly sums

"""

function convert2hourly(data::Array,isavg=false)
    nlon = size(data,1); nlat = size(data,2); nt = size(data,3); dt = nt/24;
    data = reshape(data,(nlon,nlat,dt,:));
    if isavg; data = mean(data,dims=3);
    else;     data = sum(data,dims=3);
    end
end

function convert23hourly(data::Array,isavg=false)
    nlon = size(data,1); nlat = size(data,2); nt = size(data,3); dt = nt/8;
    data = reshape(data,(nlon,nlat,dt,:));
    if isavg; data = mean(data,dims=3);
    else;     data = sum(data,dims=3);
    end
end

function convert2daily(data::Array,isavg=false)
    if isavg; data = mean(data,dims=3);
    else;     data = sum(data,dims=3);
    end
end

function convert2regionmean(data::Array,isavg=true)
    if isavg; data = mean(data,dims=(1,2));
    else;     data = sum(data,dims=(1,2));
    end
end

function convert2zonalmean(data::Array,isavg=true)
    if isavg; data = mean(data,dims=1);
    else;     data = sum(data,dims=1);
    end
end

function convert2meridionalmean(data::Array,isavg=true)
    if isavg; data = mean(data,dims=2);
    else;     data = sum(data,dims=2);
    end
end
