using Cassette
using Contextual

struct MyMetadata end

Contextual.@context GPUctx

dump(Contextual.metadata())
dump(Cassette.overdub(GPUctx, Contextual.metadata, metadata=MyMetadata())())
