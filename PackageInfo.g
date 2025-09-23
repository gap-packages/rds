SetPackageInfo( rec(

PackageName := "RDS",
Subtitle := "A package for searching relative difference sets",
Version := "1.9",
Date := "24/09/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    LastName      := "Roeder",
    FirstNames    := "Marc",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "roeder.marc@gmail.com",
    WWWHome       := "http://csserver.evansville.edu/~mroeder",
  ),
  rec(
    LastName      := "GAP Team",
    FirstNames    := "The",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "support@gap-system.org",
  ),

],

Status := "accepted",
CommunicatedBy := "Leonard Soicher (Queen Mary, London)",
AcceptDate := "02/2008",

PackageWWWHome  := "https://gap-packages.github.io/rds/",
README_URL      := Concatenation( ~.PackageWWWHome, "README.rds" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/rds",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/rds-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := "This package provides functions for the complete enumeration of relative difference sets.",

PackageDoc := rec(
  BookName  := "RDS",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Relative Difference Sets",
),

Dependencies := rec(
  GAP := ">=4.8",
  NeededOtherPackages := [["DESIGN", ">=1.3"]],
  SuggestedOtherPackages := [["AutPGrp",">=1.0"]],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",
Keywords := ["relative difference sets","finite geometries","projective planes"],

));
