
macro contextualized(MetadataType::Symbol)
    esc(quote
        $Contextual.contextualized($MetadataType)
    end)
end

macro contextual(MetadataType::Symbol)
    esc(quote
        $Contextual.context()
    end)
end
