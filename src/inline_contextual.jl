
macro contextualized(MetadataType)
    esc(quote
        typeof(Contextual.metadata()) <: $MetadataType
    end)
end

macro contextual(MetadataType)
    esc(quote
        m = Contextual.metadata()
        # this crashes
        dump(m)
        @assert (typeof(m) <: $MetadataType) "no context of requested type"
        m
    end)
end
