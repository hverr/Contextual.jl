
using Contextual
using Contextual: @contextualized

@contextualized function f(r) @with {dev::CuDevice}
    x = r + 5
    return x
end
