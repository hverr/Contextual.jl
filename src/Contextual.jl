__precompile__(false)

module Contextual

using TinyCassette
using MacroTools

export @context, @contextualized, @contextual, @withctx

include("shared.jl")
include("inline_contextual.jl")
include("outline_contextual.jl")

end # module
