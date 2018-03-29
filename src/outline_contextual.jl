struct ContextSpecifier
    varName::Symbol
    ctxType::Symbol
end

macro contextualized(expr::Expr)
    # Parse complete function
    f = splitdef(expr)
    b = f[:body]

    # Extract context specification
    contextSpec = parseContextSpecifier(b.args[2])
    dump(contextSpec)

    # Remove context specification, i.e. @with macro
    deleteat!(b.args, 2)

    # Variable name for overdub struct
    varName = :(contextual_226d200456eb3bfd352f53e040b453787b46cc24) # surely no one will use this variable name? :O

    # Query current context from Overdub struct
    insert!(b.args, 2, :(const $(contextSpec.varName) = $varName.context :: $(contextSpec.ctxType)))

    # Output new function
    f[:name] = :($varName::$TinyCassette.Overdub{typeof($(f[:name])), $(contextSpec.ctxType)})
    esc(MacroTools.combinedef(f))
end

function parseContextSpecifier(macrocall)
    @assert isexpr(macrocall, :macrocall) "expected a @with context specification"
    @assert macrocall.args[1] == Symbol("@with") "expected a @with specification"

    braces = macrocall.args[3]
    @assert isexpr(braces, :braces) "context specification should be in braces"

    spec = braces.args[1]
    @assert isexpr(spec, :(::)) "context specification should start with ctx::Ctx"
    varName = spec.args[1]
    ctxType = spec.args[2]

    return ContextSpecifier(varName, ctxType)
end
