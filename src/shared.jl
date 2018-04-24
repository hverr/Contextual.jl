@inline context() = nothing
@inline contextualized(::Type{T}) where {T} = false

macro context(Ctx)
    esc(quote
        @inline $TinyCassette.execute(ctx::$Ctx, ::typeof($context)) = ctx
        @inline $TinyCassette.execute(ctx::$Ctx, ::typeof($contextualized), ::Type{T}) where {T} = $Ctx <: T
    end)
end

macro withctx(Ctx, Fn::Expr)
    @assert isexpr(Fn, :call) "second argument must be a function call"

    fnName = Fn.args[1]
    fnArgs = Fn.args[2:end]

    esc(Expr(:call, :($TinyCassette.execute), Ctx, fnName, fnArgs...))
end
