## representation methods:
ReadPackage( "RDS", "lib/reps.gi" );

## invariants (signatures)
ReadPackage( "RDS", "lib/sigs.gi" );

## tools for startset generation
ReadPackage( "RDS", "lib/startsets.gi");

## reduction methods:
ReadPackage("RDS", "lib/ReducedStartsets.gi");
        
## some development tools:
ReadPackage( "RDS", "lib/misc.gi" );

## brute force methods:
ReadPackage( "RDS", "lib/AllDiffsets.gi");
ReadPackage( "RDS", "lib/OneDiffset.gi");

##Generating projective planes as BlockDesigns
ReadPackage( "RDS", "lib/designs.gi");

## methods to determine isomophism class of projective plane
ReadPackage( "RDS", "lib/plane_isomorphisms.gi");

ReadPackage( "RDS", "lib/lazy.gi");

#############################################################################
##
#E  END
##