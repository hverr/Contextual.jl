
macro contextualized(MetadataType::Symbol)
    esc(quote
        $Contextual.contextualized($MetadataType)
    end)
end

macro contextual(MetadataType::Symbol)
    esc(quote
        m = $Contextual.context()
        # this crashes
        #dump(m)
        #@assert (typeof(m) <: $MetadataType) "no context of requested type"
        m
    end)
end
