
using Contextual
using Contextual: @contextualized#, @with

@contextualized function f(r) @with {dev::CuDevice}
    x = r + 5
    return x
end
