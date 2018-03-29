@inline context() = nothing
@inline contextualized(::Type{T}) where {T} = false

macro context(Ctx)
    esc(quote
        @inline (o::$TinyCassette.Overdub{typeof($context), $Ctx})() = o.context
        @inline (o::$TinyCassette.Overdub{typeof($contextualized), $Ctx})(::Type{T}) where {T} = $Ctx <: T
    end)
end

macro withctx(Ctx, Fn::Expr)
    @assert isexpr(Fn, :call) "second argument must be a function call"

    fnName = Fn.args[1]
    fnArgs = Fn.args[2:end]

    o = Expr(:call, :($TinyCassette.Overdub), fnName, Ctx)
    esc(Expr(:call, o, fnArgs...))
end
