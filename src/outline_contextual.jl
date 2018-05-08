struct ContextSpecifier
    varName::Symbol
    ctxType::Any
    subtype::Bool
end

macro contextualized(expr::Expr)
    if Meta.isexpr(expr, :function)
        return contextualizedFunction(expr, false)
    elseif Meta.isexpr(expr, :(=))
        return contextualizedFunction(expr, true)
    else
        @error "expected a function definition"
    end
end

function contextualizedFunction(expr::Expr, isshort)
    # Parse complete function
    f = splitdef(expr)
    b = f[:body]

    isinline = (b.args[1] == Expr(:meta,:inline))
    if isshort
        b = b.args[isinline ? 2 : 1 ]
    end


    # Extract context specification
    ctxIdx = isshort ? 1 : 2
    if isinline && !isshort
        ctxIdx += 1
    end
    contextSpec = parseContextSpecifier(b.args[ctxIdx])

    # Remove context specification, i.e. @with macro
    deleteat!(b.args, ctxIdx)

    # Push context and function
    if contextSpec.varName == :(_)
        insert!(f[:args], 1, :(::$(contextSpec.ctxType)))
    else
        insert!(f[:args], 1, :($(contextSpec.varName)::$(contextSpec.ctxType)))
    end
    insert!(f[:args], 2, :(::typeof($(f[:name]))))

    # Change function name
    f[:name] = :($TinyCassette.execute)

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
