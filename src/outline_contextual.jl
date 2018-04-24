struct ContextSpecifier
    varName::Symbol
    ctxType::Any
    subtype::Bool
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

    # Push context and function
    if contextSpec.varName == :(_)
        insert!(f[:args], 1, :(::$(contextSpec.ctxType)))
    else
        insert!(f[:args], 1, :($(contextSpec.varName)::$(contextSpec.ctxType)))
    end
    insert!(f[:args], 2, :(::typeof($(f[:name]))))

    # Change function name
    f[:name] = :($TinyCassette.execute)

    println(f)
    esc(MacroTools.combinedef(f))
end

function parseContextSpecifier(macrocall)
    @assert isexpr(macrocall, :macrocall) "expected a @with context specification"
    @assert macrocall.args[1] == Symbol("@with") "expected a @with specification"

    braces = macrocall.args[3]
    @assert isexpr(braces, :braces) "context specification should be in braces"

    spec = braces.args[1]
    if isexpr(spec, :(::))
        subtype = false
    elseif isexpr(spec, :(<:))
        subtype = true
    else
        @error "context specification should start with ctx::Ctx or ctx<:Ctx"
    end

    varName = spec.args[1]
    ctxType = spec.args[2]
    return ContextSpecifier(varName, ctxType, subtype)
end
