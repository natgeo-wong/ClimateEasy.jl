"""
This file contains all the functions that are required to do basic mapping of
contour and contourf maps for climate data.

"""

function mollweide(clon::Float16)
    fig,ax = plt.subplot(projection=ccrs.Mollweide(central_longitude=clon));
    return fig,ax
end

function mollweide(gridbounds::Array)
    fig,ax = plt.subplot(projection=ccrs.Mollweide()); ax.set_extent(gridbounds);
    return fig,ax
end

function robinson(clon::Float16)
    fig,ax = plt.subplot(projection=ccrs.Robinson(central_longitude=clon));
    return fig,ax
end

function robinson(gridbounds::Array)
    fig,ax = plt.subplot(projection=ccrs.Robinson()); ax.set_extent(gridbounds);
    return fig,ax
end

function coastlines(ax)
    ax.coastlines()
end
