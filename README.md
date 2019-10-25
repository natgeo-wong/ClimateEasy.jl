# ClimateEasy

ClimateEasy contains scripts and functions that aim to automate the basic parts
of coding in climate research.  It currently has the following functionalities:
* Conversion of dates to formatted strings
* Extraction of regional data from a given dataset
* Extraction of data from HDF4 legacy format
* Mapping of gridded data using Julia's inbuilt Python functionalities

I will be adding Documentation to this later.

Currently, the ClimateEasy.jl package requires the following Julia dependencies:
* Dates, DelimitedFiles, Printf
* Conda, PyCall, PyPlot

The ClimateEasy.jl package requires the following Python dependencies:
* Cartopy
* pyhdf

These Python dependencies can be installed using Conda.add("pkg_name")

Author(s):
* Nathanael Zhixin Wong: nathanaelwong@fas.harvard.edu
