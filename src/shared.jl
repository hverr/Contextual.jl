context() = nothing

@inline contextualized(::Type{T}) where {T} = false

macro context(Ctx)
    esc(quote
        (o::$TinyCassette.Overdub{typeof($context), $Ctx})() = o.context
        @inline (o::$TinyCassette.Overdub{typeof($contextualized), $Ctx})(::Type{T}) where {T} = $Ctx <: T
    end)
end

#macro overdub(ctxSpec::Expr, def::Expr)
#    # Parse context specification
#    if isexpr(ctxSpec, :(::))
#        isexact = true
#    elseif isexpr(ctxSpec, :(<:))
#        isexact = false
#    else
#        @error "expected context specification as first argument, either dev::Ctx or dev<:Ctx"
#    end
#    ctxVar, ctxType = ctxSpec.args
#
#    
#end
