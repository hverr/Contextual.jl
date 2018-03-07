struct ContextSpecifier
    varName::Symbol
    ctxType::Symbol
end

macro contextualized(expr::Expr)
    @assert expr.head == :function "argument must be a function definition"
    @assert expr.args[1].head == :call "argument must be a function definition"
    @assert expr.args[2].head == :block "argument must be a function definition"

    fcall = expr.args[1]
    fbody = expr.args[2]

    withmacro = fbody.args[2]
    @assert withmacro.head == :macrocall "function defintion must have a @with specifier"
    @assert withmacro.args[1] == Symbol("@with") "funciton defintion must have a @with specifier"

    braces = withmacro.args[3]
    contextSpec = parseContextSpecifier(braces)

    dump(contextSpec)
end

function parseContextSpecifier(braces)
    @assert braces.head == :braces "context specification should be in braces"

    spec = braces.args[1]
    @assert spec.head == :(::) "context specification should start with ctx::Ctx"
    varName = spec.args[1]
    ctxType = spec.args[2]

    return ContextSpecifier(varName, ctxType)
end

macro with(expr)
    return expr
end

