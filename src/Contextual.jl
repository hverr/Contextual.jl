__precompile__(false)

module Contextual

using Cassette
using MacroTools

include("shared.jl")
include("inline_contextual.jl")
include("outline_contextual.jl")

end # module
