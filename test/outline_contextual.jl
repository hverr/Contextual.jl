
using Contextual
using Contextual: @contextualized

f(r) = x+3

@contextualized function f(r) @with {dev::Int64}
    x = r + 5
    return x
end
