SetPackageInfo( rec(

PackageName := "RDS",
Subtitle := "A package for searching relative difference sets",
Version := "1.6",
Date := "16/02/2012",

ArchiveURL := "http://csserver.evansville.edu/~mroeder/rds/gap4_5/rds1_6",
ArchiveFormats := ".tar.gz,.tar.bz2,-win.zip", # the others are generated automatically

Persons := [
  rec(
    LastName      := "Roeder",
    FirstNames    := "Marc",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "roeder.marc@gmail.com",
    WWWHome       := "http://csserver.evansville.edu/~mroeder",
  ),

],

Status := "accepted",
CommunicatedBy := "Leonard Soicher (Queen Mary, London)",
AcceptDate := "02/2008",

README_URL := "http://csserver.evansville.edu/~mroeder/rds/gap4_5/README.rds",
PackageInfoURL := "http://csserver.evansville.edu/~mroeder/rds/gap4_5/PackageInfo.g",

AbstractHTML := "This package provides functions for the complete enumeration of relative difference sets.",

PackageWWWHome := "http://csserver.evansville.edu/~mroeder",

PackageDoc := rec(
  BookName  := "RDS",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Relative Difference Sets",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.5",
  NeededOtherPackages := [["DESIGN", ">=1.3"]],
  SuggestedOtherPackages := [["AutPGrp",">=1.0"]],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,
BannerString := Concatenation(
  "----------------------------------------------------------------\n",
  "Loading  RDS ", ~.Version, "\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName," (",
  ~.Persons[1].Email,")",
        "\n",
  "----------------------------------------------------------------\n" ),

Autoload := false,
#TestFile := "tst/testall.g",
Keywords := ["relative difference sets","finite geometries","projective planes"]

));
