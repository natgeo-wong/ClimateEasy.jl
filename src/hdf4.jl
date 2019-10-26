"""
    This file specifically is meant for the reading of HDF4 files using Julia's
    Conda wrapper, because Julia does not have inbuilt support for HDF4 files.
    It was found necessary to create this file for accessing older datasets when
    HDF5 had not yet been released.

    The following datasets are in HDF4:
        - Tropical Rainfall Measuring Mission (TRMM)
        - MODerate resolution Imaging Spectroradiometer (MODIS)
"""

function h4read(file::AbstractString,variable::AbstractString)
    fhdf = pyhdf.SD(file,pyhdf.SDC.READ); dataob = fhdf.select(variable);
end
