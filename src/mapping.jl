"""
This file contains all the functions that are required to do basic mapping of
contour and contourf maps for climate data.

"""

function mollweide(clon::Float16)
    ccrs = pyimport("cartopy.crs");
    return subplot(projection=ccrs.Mollweide(central_longitude=clon));
end

function mollweide(gridbounds::Array)
    ccrs = pyimport("cartopy.crs");
    ax = subplot(projection=ccrs.Mollweide()); ax.set_extent(gridbounds);
    return ax
end

function robinson(clon::Float16)
    ccrs = pyimport("cartopy.crs");
    return subplot(projection=ccrs.Robinson(central_longitude=clon));
end

function robinson(gridbounds::Array)
    ccrs = pyimport("cartopy.crs");
    ax = subplot(projection=ccrs.Robinson()); ax.set_extent(gridbounds);
    return ax
end

function coastlines(ax)
    ax.coastlines()
end
