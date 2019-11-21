"""
This file contains a set of miscellaneous functions that would be useful not
only in Climate packages but also for other miscellaneous functions such as
trying to lighten colours, or setting the labels of a plot, or making the axis
symmetric in nature, etc.

"""

function nanop(f::Function,data::Array;dim=1)

    ndim = ndims(data); dsize = size(data);
    if ndim==2
        if dim==1; newdim = [2,1]; data = permutedims(data,newdim); nsize = dsize[2]; end
    elseif ndim>2
        if dim==1; newdim = convert(Array,2:ndim); newdim = vcat(newdim,1);
            data = permutedims(data,newdim);
            nsize = dsize[2:end]
        elseif dim<ndim
            newdim1 = convert(Array,1:dim-1);
            newdim2 = convert(Array,dim+1:ndim);
            newdim  = vcat(newdim1,newdim2,dim)
            data    = permutedims(data,newdim);
            nsize   = tuple(dsize[newdim1]...,dsize[newdim2]...)
        else nsize  = dsize[1:end-1]
        end
    else; nsize = dsize[1:end-1]
    end

    data = reshape(data,:,dsize[dim]); l = size(data,1); out = zeros(l);

    for ii = 1 : l; dataii = data[ii,:];
        out[ii] = f(dataii[.!isnan.(dataii)])
    end

    return reshape(out,nsize)

end
