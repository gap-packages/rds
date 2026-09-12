LoadPackage("rds");
# GAP wraps long output differently across versions, so compare up to
# whitespace, as TestPackage does
TestDirectory(DirectoriesPackageLibrary("rds", "tst"),
              rec(exitGAP := true,
                  testOptions := rec(compareFunction := "uptowhitespace")));
FORCE_QUIT_GAP(1);
