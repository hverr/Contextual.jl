__precompile__(false)

module Contextual

using TinyCassette
using MacroTools

export @contextualized, @contextual

include("shared.jl")
include("inline_contextual.jl")
include("outline_contextual.jl")

end # module
