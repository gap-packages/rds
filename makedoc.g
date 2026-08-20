#############################################################################
##
##  makedoc.g
##
##  Builds the package documentation with AutoDoc/GAPDoc.
##
##  The declarations are documented beside the code, in <#GAPDoc> blocks under
##  lib/; the chapters pull them in with <#Include>.
##
#############################################################################

LoadPackage("AutoDoc");

# Run this from the package's root directory: gap makedoc.g
AutoDoc(rec(
    autodoc := true,
    gapdoc := true,
    extract_examples := true,
    scaffold := rec(
        includes := [
            "about.xml",
            "tutorial.xml",
            "jumpstart.xml",
            "startsets.xml",
            "sigs.xml",
            "example.xml",
            "orderedsigs.xml",
            "iso.xml",
            "misc.xml"
        ],
        bib := "rds.bib",
        entities := rec(
            RDS := "<Package>RDS</Package>",
        ),
    ),
));

QuitGap();
