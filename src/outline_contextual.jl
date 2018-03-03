macro contextual(expr::Expr)
    @assert expr.head == :function "argument must be a function definition"
    @assert expr.args[1].head == :call "argument must be a function definition"
    @assert expr.args[2].head == :block "argument must be a function definition"

    fcall = expr.args[1]
    fbody = expr.args[2]

    withmacro = fbdoy.args[2]
    @assert withmacro.head == :macrocall "function defintion must have a @with specifier"
    @assert withmacro.args[1] == Symbol("@with") "funciton defintion must have a @with specifier"

    braces = fbody.args[3]
    @assert braces.head == :braces "context specification should be in braces"
    @assert braces.
end
