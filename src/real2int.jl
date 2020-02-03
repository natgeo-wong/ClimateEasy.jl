"""
This file contains all the functions that convert and scale Real Numbers to Integer formats
as is often used in NetCDF data for compressibility issues and also helps to save on
computer memory

"""

function real2int16!(
    outarray::Array{Int16}, inarray::Array{<:Real};
    offset::Real, scale::Real
)

    if size(outarray) != size(inarray)
        dout = [i for i in size(outarray)];
        din  = [i for i in size(inarray)];
        if (dout[1:end-1] != din[1:end] && dout[1:end] != din[1:end-1]) ||
            prod(dout) != prod(din)
            error("$(Dates.now()) - output array is not of the same size as the input array")
        end
    end

    for ii = 1 : length(inarray)

        inarray[ii] = (inarray[ii] - offset) / scale

        if inarray[ii] < -32767; inarray[ii] = -32768
        elseif inarray[ii] > 32767; inarray[ii] = -32768
        end

        outarray[ii] = round(Int16,inarray[ii])

    end

    return

end
