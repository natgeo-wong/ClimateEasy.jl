"""
This file contains all the functions that are required to do basic mapping of
contour and contourf maps for climate data.

"""

function mollweide(clon::Float16)
    return subplot(projection=ccrs.Mollweide(central_longitude=clon));
end

function mollweide(gridbounds::Array)
    ax = plt.subplot(projection=ccrs.Mollweide()); ax.set_extent(gridbounds);
    return ax
end

function robinson(clon::Float16)
    ax = subplot(projection=ccrs.Robinson(central_longitude=clon));
    return ax
end

function robinson(gridbounds::Array)
    ax = subplot(projection=ccrs.Robinson()); ax.set_extent(gridbounds);
    return ax
end

function coastlines(ax)
    ax.coastlines()
end
