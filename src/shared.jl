metadata() = nothing

macro context(Ctx)
    esc(quote
        $Cassette.@context $Ctx

        $Cassette.@primitive ctx::$Ctx md (::typeof(Contextual.metadata))() = md
    end)
end
