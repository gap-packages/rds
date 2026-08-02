This file describes changes in the RDS package.

## Unreleased

  - Fix missing commas in the `AllDiffsets` methods taking a start set and a
    group, which made these methods error out
  - Declare the SmallGrp package dependency explicitly (it is needed by
    `NormalSgsForQuotientImages` and friends, which use `IdSmallGroup` as a
    fingerprint for isomorphism types)
  - Update the CI setup

## 1.9 (2025-09-24)

  - Stop using GAP's `@`-namespace feature: rename `PRank@RDS` to `RDS_PRank`
    and `MaxAutsizeForOrbitCalculation@RDS` to
    `RDS_MaxAutsizeForOrbitCalculation`
  - Generate the manual `.tex` files from the `.msk` sources via the new
    `doc/buildman.pe` script, and remove the generated files from the
    repository
  - Remove the obsolete `Autoload` entry from `PackageInfo.g`
  - Various janitorial changes, plus documentation typo fixes and CI updates

## 1.8 (2022-02-21)

  - Avoid incorrect pluralizations in output
  - Move the test suite to GitHub Actions
  - Various janitorial changes

## 1.7 (2019-02-23)

  - Move the package to GitHub and update its URLs
  - Raise the required GAP version to 4.8
  - Add GPL-2.0-or-later license metadata
  - Add the GAP Team as maintainer
  - Add a test suite, continuous integration, and code-coverage support
  - Various janitorial changes

## 1.6 (2012-02-16)

  - Fix the documentation paths in `PackageInfo.g`

## 1.5

  - Fix a path in `PackageInfo.g`

## 1.4 (2011-08-25)

  - Change the directory used for `PackageInfo.g` and the archives

## 1.3

  - Raise the required GAP version to 4.5, due to the use of the "namespaces"
    feature
  - Rename `pRank` to `PRank@RDS` and `maxAutsizeForOrbitCalculation` to
    `MaxAutsizeForOrbitCalculation@RDS`, to conform with GAP's naming
    convention for packages
  - Add additional sorting of records in `ReducedDiffsets.gi`, made necessary
    by the new ordering method for records in GAP 4.5

## 1.2 (2010-06-03)

  - Update the package homepage

## 1.1 (2008-12-02)

  - Fix minor issues in the `ShallowCopy` part of `ConcatenationOfIterators`
    and `CartesianIterator`
  - Rewrite `ReducedStartsets`
  - Move the package from Galway back to Kaiserslautern

## 1.0 (2008-01-26)

  - Update the years in the copyright notice (from 2006 to 2006-2008)

## 0.9beta28

  - Marginally speed up the brute force methods for `lambda` = 1
  - Change `ReducedStartsets` slightly, probably improving performance in
    large cases
  - Replace `Intersection(diffset,forbidden)<>[]` with
    `ForAny(diffset,i->i in forbidden)` in `RemainingCompletions` and
    `RemainingCompletionsNoSort`
  - Make `OneDiffset` and `AllDiffsets` check whether the given partial
    difference set really is a partial difference set; if it is not, the empty
    set is returned
  - Replace all `Sqrt` calls in `AllDiffsets` and `OneDiffset` with `RootInt`
    calls, greatly reducing the method-selection overhead
  - Make `DevelopmentOfRDS` more flexible, so that it accepts all sensible
    kinds of input
  - Fix the `blockSizes` bug in `DevelopmentOfRDS` (thanks to Leonard Soicher)
  - Merge `doc/rds.tex` into the `.msk` file, so that its text also appears in
    the HTML and online documentation
  - Surround method names in text paragraphs with double quotes, which
    generates links in the HTML documentation; consequently, references in the
    PDF documentation are no longer given by numbers either (for this, the
    definition of `\printref` in `gapmacro.tex` was changed)
  - Further changes to the manual (thanks to Leonard Soicher)
  - Set the package state to "accepted"

## 0.9beta27

  - Fix a bug in `AllDiffsets` and `OneDiffset`
  - Fix a few errors in the documentation
  - Clean up directories and fix the permissions of the `htm` directory

## 0.9beta26

  - Add `AllDiffsetsNoSort`
  - Add `OneDiffset` and `OneDiffsetNoSort`
  - Add `IsDiffset`
  - Further changes to the documentation, including a new chapter about
    `AllDiffsets` and `OneDiffset`

## 0.9beta25

  - Add the function `DevelopmentOfRDS`
  - Change all functions for projective planes to the new data structures;
    projective planes are now `BlockDesign`s as in the DESIGN package, which
    RDS now depends on
  - Allow `AllDiffsets` to be called in *many* new and simple ways
  - Rewrite the documentation and add many examples

## 0.9beta22

  - Fix a bug in `OrderedSignatureOfSet` which could lead to crashes and wrong
    results
  - Change the date format in the library files to yyyy/mm/dd
  - Remove the variant of `NormalSubgroupsForRep` taking a group as its first
    argument; this function was undocumented and incompatible with the rest of
    the functions anyway

## 0.9beta21 (2006-11-15)

  - Start this changelog
  - Add a license notice and the archive extraction commands to `README.rds`
  - Fix `PackageInfo.g`, move the source files to the `lib/` directory, and
    set the package state to "deposited" (changes proposed by B. Assmann,
    thank you)
