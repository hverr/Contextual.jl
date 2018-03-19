context() = nothing

is_contextualized(::Type{T}) where {T} = false

macro context(Ctx)
    esc(quote
        (o::$TinyCassette.Overdub{typeof($context), $Ctx})(args...) = o.context
        (o::$TinyCassette.Overdub{typeof($is_contextualized), $Ctx})(::Type{T}) where {T} = (dump(Ctx); dump(T); $Ctx <: T)
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
