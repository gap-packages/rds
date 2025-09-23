#############################################################################
##
#W sigs.gd 			 RDS Package		 Marc Roeder
##
##  Invariants for partial difference sets
##
##
#Y	 Copyright (C) 2006-2011 Marc Roeder 
#Y 
#Y This program is free software; you can redistribute it and/or 
#Y modify it under the terms of the GNU General Public License 
#Y as published by the Free Software Foundation; either version 2 
#Y of the License, or (at your option) any later version. 
#Y 
#Y This program is distributed in the hope that it will be useful, 
#Y but WITHOUT ANY WARRANTY; without even the implied warranty of 
#Y MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
#Y GNU General Public License for more details. 
#Y 
#Y You should have received a copy of the GNU General Public License 
#Y along with this program; if not, write to the Free Software 
#Y Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
##
#############################################################################
## 
#V RDS_MaxAutsizeForOrbitCalculation
## 
##  In "ReducedStartsets", a bound is needed to decide if `Orbit' or 
##  `RepresentativeAction' should be used. If the group is larger than 
##  <RDS_MaxAutsizeForOrbitCalculation>, `RepresentativeAction' is used.
##  The default value for `RDS_MaxAutsizeForOrbitCalculation' is $5*10^6$.
##  You can change it by simply setting it to a different value.
##
RDS_MaxAutsizeForOrbitCalculation := 5*10^6;

#############################################################################
##
#O  RDSFactorGroupData(<U>,<N>,<lambda>,<Gdata>)
##  
##  takes the subgroup <U> of <G>, the forbidden set <N> as a subgroup or 
##  subset of <G> and the record of data <Gdata> as returned by 
##  `PermutationRepForDiffsetCalculations(<G>)' and returns a record containing
##  \beginlist
##   \item{.fg} the factor group modulo <U>
##   \item{.fglist} the factor group as a strictly ordered list
##   \item{.cosets} the cosets modulo <U> as lists of integers
##   \item{.lambda} the parameter <lambda> as passed to the function
##   \item{.Usize} the size of <U>    
##   \item{.fgaut} the automorphism group of <.fg>
##   \item{.Nfg} the image of <N> in <.fg>
##   \item{.fgintersect} a list of pairs such that the $i^{th}$ entry is the 
##    pair consisting of <.fg[i]> and the size of the intersection of <.fg> with 
##   <.Nfg> as cosets modulo <U>.
##   \item{.intersectshort} ist just the second component of <.fgintersect>.
##  \endlist
##
DeclareOperation("RDSFactorGroupData",[IsGroup,IsObject,IsInt,IsRecord]);

#############################################################################
##
#O MatchingFGDataNonGrp(<fgdatalist>,<fgmatchdata>)  
##
##  Let <fgdatalist> be a list of records and <fgmatchdata> a record with components
##  <.fg>, <.Nfg> and <.fgintersect>  as returned by "RDSFactorGroupData".
##  Then `MatchingFGDataNonGrp' returns the entry of <fgdatalist> that defines
##  the same admissible signatures as <fgmatchdata>. If no such entry exists,
##  `fail' is returned.
##
##  The forbidden set $N$ is not assumed to be a group.
##
DeclareOperation("MatchingFGDataNonGrp",[IsList,IsRecord]);

#############################################################################
##
#O MatchingFGData(<fgdatalist>,<fgmatchdata>)  
##
##  Let <fgdatalist> be a list of records and <fgmatchdata> a record with components
##  <.fg>, <.Nfg>, <.fgintersect> and <.fgaut> as returned by "RDSFactorGroupData".
##  Then `MatchingFGDataNonGrp' returns the entry of <fgdatalist> that defines
##  the same admissible signatures as <fgmatchdata>. If no such entry exists,
##  `fail' is returned.
##
##  Here the forbidden set $N$ has to be a group.
##
DeclareOperation("MatchingFGData",[IsList,IsRecord]);


#############################################################################
##
#O  CosetSignatures( <Gsize>,<Usize>,<diffsetorder> )    calculates possible signatures for difference sets.
#O  CosetSignatures( <Gsize>,<Nsize>,<Usize>,<Intersectsizes>,<k>,<lambda>)    calculates possible signatures for relative difference sets with forbidden groups.
##
##  `CosetSignatures( <Gsize>,<Usize>,<diffsetorder>)' returns all 
##  $<Gsize>/<Usize>$ tuples such that the sum of the squares of each tuple 
##  equals  <Usize>+<diffsetorder>. And the sum of each tuple equals 
##  <diffsetorder>+1.
##  
##  These are necessary conditions for signatures of difference sets and 
##  normal subgroups of order <Usize> in groups of order <Gsize> (see "The 
##  Coset Signature").
##  
##  `CosetSignatures( <Gsize>,<Nsize>,<Usize>,<Intersectsizes>,<k>,<lambda>)'
##  Calculates all multiset meeting some  conditions for signatures of relative 
##  difference sets and normal subgroups of order <Usize> in groups of 
##  order <Gsize> (see "The Coset Signature").
##  Here <Nsize> is the size of the forbidden group,
##  <Intersectsizes> is a list of integers determining the size of the 
##  intersection of the forbidden set and the normal Subgroup of order <Usize>.
##  The pararmeters <k> and <lambda> are the usual ones for designs.
##  `CosetSignatures' returns a list containing one pair for each entry <i> of 
##  <Intersectsizes>. The first entry of this pair is 
##  $[<Gsize>,<Nsize>,<Usize>,<i>,<k>,<lambda>]$ and the second one is a list
##  of admissible signatures with these parameters.
##
DeclareOperation("CosetSignatures",[IsInt,IsInt,IsInt]);
DeclareOperation("CosetSignatures",[IsInt,IsInt,IsInt,IsInt,IsInt,IsInt]);
DeclareOperation("CosetSignatures",[IsInt,IsInt,IsInt,IsDenseList,IsInt,IsInt]);

#############################################################################
##
#O  TestedSignatures(<sigs>,<group>,<Normalsg>[,<maxtest>][,<moretest>])   returns a subset of <sigs> satisfying necessary conditions for signatures of difference sets.
##
##  *this does only work for ordinary difference sets, not for 
##  relative difference sets in general*
##
##  Let <sigs> be a list of possible signatures as returned by 
##  "CosetSignatures". Let <Normalsg> be a subgroup of <group>. 
##  For each signature in <sigs>, the necessary conditions described in 
##  "The Coset Signature" are tested to decide
##  if the signature can be a signature of a  difference set in <group> for
##  for the normal subgroup <Normalsg>. 
##
##  As this involves computation for all permutations of the signature, this
##  can be very costly. The argument <maxtest> determines how many 
##  permutations are admissible. If <maxtest>=0, all signatures are tested,
##  regardless of how much work is necessary for this. If a signature has 
##  too many permutations, it is returned without test. Even though it is 
##  not wise, `<maxtest>=0' is the default option. 
##  If `InfoLevel(InfoRDS)'\index{InfoRDS@{\tt InfoRDS}} is at least $2$, 
##  information about skipped signatures is echoed.
##
##  If the boolean value <moretest> is <false> and all signatures in <sigs> but 
##  the last one are found to be not admissible, the last one is returned
##  without test. This saves the time to test the last signature, but if 
##  chances are that there is no difference set in <group>, this may also 
##  give away a chance to find out early (every difference set has 
##  signatures, so no admissible signature means that no difference set can
##  exist). Default is <true>.
##
##
##  `TestedSignatures' calls "TestSignatureCyclicFactorGroup" or
##  "TestSignatureLargeIndex" and returns a sublist of <sigs>. 
##
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup]);
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup,IsInt]);
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup,IsBool]);
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup,IsInt,IsBool]);


#############################################################################
##
#O  TestedSignaturesRelative(<sigs>,<fgdata>,[,<maxtest>][,<moretest>])  returns subset of <sigs> which might be a set of signatures of relative difference sets with forbidden group.
##
##  `TestedSignaturesRelative' takes a list <sigs> of lists of integers and 
##  returns a those which may be signatures of relative difference sets with 
##  forbidden set.
##
##  <fgdata> is a record as returned by 
##  `RDSFactorGroupData(<U>,<N>,<lambda>,<Gdata>)'
##  If <maxtest> is set, a signature $s$ is only tested if 
##  `NrPermutationsList(s)'
##  is less than <maxtest> if <maxtest> is set to 0, all signatures are tested 
##  this is the default.
##  If <moretest> is tue, a signature is tested even if it is the only one left.
##  This means we do not assume that there must be an admissible signature at all.
##  The default for <moretest> is <true>.
##
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord,IsInt,IsBool]);
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord,IsInt]);
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord,IsBool]);
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord]);
DeclareOperation("TestSignatureRelative",[IsList,IsRecord]);


#############################################################################
##
#O  TestSignatureLargeIndex(<sig>,<group>,<Normalsg>[,<factorgrp>])  tests if a list can be signature for a difference set
##
##  *this does only work for ordinary difference sets, not for 
##  relative difference sets in general*
##
##  `TestSignatureLargeIndex(<sig>,<group>,<Normalsg>[,<factorgrp>])' tests 
##  if <sig> meets some necessary conditions of "The Coset Signature" to be 
##  a signature for a difference set in  <group> for the normal subgroup 
##  <Normalsg>. <factorgrp> is the factorgroup <group>/<Normalsg>.
##  The returned value is <true> or <false> resp.
##
DeclareOperation("TestSignatureLargeIndex",[IsList,IsGroup,IsGroup]);
DeclareOperation("TestSignatureLargeIndex",[IsList,IsGroup,IsGroup,IsGroup]);

#############################################################################
##
#O  TestSignatureCyclicFactorGroup(<sig>,<Nsize>)  tests if a list can be signature for a difference set
##
##  *This does only work for ordinary difference sets, not for relative 
##  difference sets in general*
##
##  `TestSignatureCyclicFactorGroup(<sig>,<Nsize>)' test if <sig> meets 
##  meets some necessary conditions of "The Coset Signature" to be a signature 
##  for a difference set in some group, which has a normal subgroup of 
##  size <Nsize> such that  the factor group is cyclic.
##  The returned value is <true> or <false> resp.
##
DeclareOperation("TestSignatureCyclicFactorGroup",[IsList,IsInt]);


#############################################################################
##
#F  CosetSignatureOfSet( <set>,<cosets>)        calculate the signature of a partial RDS.
##
##  `CosetSignatureOfSet( <set>,<cosets>)' returns the *ordered list* of 
##  intersection numbers of <set>. That is, the size of the intersection
##  of <set> with each Element of <cosets>.
##
##  Note that it is not tested, if <cosets> is really a list of cosets.
##  `CosetSignatureOfSet( <set>,<cosets>)' works for any List <set> and any 
##  list of lists <cosets>. So be careful!
##
DeclareGlobalFunction("CosetSignatureOfSet");

#############################################################################
##
#F  OrderedCosetSignatureOfSet( <set>,<cosets>)        calculate the signature of a partial RDS.
##
##  `CosetSignatureOfSet( <set>,<cosets>)' returns the list of 
##  intersection numbers of <set>. That is, the size of the intersection
##  of <set> with each Element of <cosets>.
##
##  Note that it is not tested, if <cosets> is really a list of cosets.
##  `CosetSignatureOfSet( <set>,<cosets>)' works for any List <set> and any 
##  list of lists <cosets>. So be careful!
##
DeclareGlobalFunction("OrderedCosetSignatureOfSet");


#############################################################################
##
#O SigInvariant( < diffset >,<data>)      calculates the signature of a partial relative difference set.
##
##  Given a partial relative difference set <diffset> and a list of 
##  records with entries <cosets> and <sigs>.
##  Here <cosets> is a full list of cosets and <sigs> is a list of 
##  signatures that may occur for relative difference sets.
##
##  For each record <rec> in <data>, the intersection numbers of 
##  <diffset> with  the cosets of <rec.cosets> are computed stored in 
##  a set <sig>. If none of the signatures in <rec.sigs> is pointwise
##  greater or equal <sig>, `SigInvariant( <diffset>,<data>) returns `fail'.
##  Otherwise <sig> is added to a list of signatures that is returned.
##
##  Note the returned invariant is that of $diffset\cup \{1\}$. 
##  The output from `SignatureDataForNormalSubgroups' can be used as <data>.
##
DeclareOperation("SigInvariant",[IsDenseList,IsDenseList]);

#############################################################################
##
#O ReducedStartsets(<startsets>,<autlist>,<csdata>,<Gdata>) returns a reduced set of startsets
#O ReducedStartsets(<startsets>,<autlist>,<func>,<Gdata>) returns a reduced set of startsets
##
##  Let  <startsets> be a set of partial relative difference sets, <autlist> a 
##  list of permutation groups and <Gdata> record returned by 
##  `PermutationRepForDiffsetCalculations'.
##  Then `ReducedStartsets' partitions the list <startsets> according to the 
##  values of the function <func> and performs a test for equivalence on the 
##  elements of the partition. The list returned is a sublist
##  of <startsets> of pairwise non-equivalent partial relative difference sets
##  if <func> is an invariant for partial relative difference sets. All elements 
##  for which <func> returns `fail' are discarded.
##
##  If a list <csdata> of records as used for "SigInvariant" (i.e. containing
##  <.cosets> and <.signatures>) is passed, then `ReducedStartsets'
##  uses "SigInvariant" for <func>.
##
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsFunction,IsMatrix]);
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsFunction,IsRecord]);
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord]);
DeclareSynonym("MoreReduction",ReducedStartsets);

#############################################################################
##
#O SignatureDataForNormalSubgroups(<Normals>,<globalSigData>,<forbiddenSet>,<Gdata>,<parameters>)
##
##  Let <Gdata> be a record as returned by "PermutationRepForDiffsetCalculations".
##  Let <Normals> be a list of normal subgroups of <Gdata.G>, and <forbiddenSet> the forbidden set 
##  (as set of group elements or group).
##
##  <parameters> must be a list of length 4 of the form <[k,lambda,maxtest,moretest]>
##  with <k> the length of the relative difference set to be constructed and <lambda> the parameter 
##  as always. <maxtest> and <moretest> are passed to `TestedSignaturesRelative' and must be set. 
##
##  `SignatureDataForNormalSubgroups' returns a list containing one record for each group $U$ in
##  <Normals>. This record contains: 
##  \beginlist
##   \item{1.} the subgroup <U> named <.subgroup>
##   \item{2.} the signatures <.sigs> for <U>
##   \item{3.} the cosets <.cosets> modulo <U> as lists of integers 
##  \endlist
##
##  Moreover, the list <globalSigData> is used to store global information which can be
##  reused with other groups. The $i^{th}$ entry of <globalSigData> is a list of records 
##  that contains all known information about subgroups of order $i$.
##  Each of these records has the following components:
##  \beginlist
##   \item{1.} <.cspara> the parameters for "CosetSignatures"
##   \item{2.} <.sigs> the output of "CosetSignatures" when the input is <.cspara>
##   \item{3.} <.fgsigs> a list of records containing data about factor groups with parameters <.cspara>:
##   \beginlist
##    \item{3.1.} <.fg> the factor group
##    \item{3.2.} <.fgaut> the automorphism group of <.fg>
##    \item{3.3.} <.Nfg> the image of the forbidden set $N$ under the natural epimorphism to <.fg>
##    \item{3.4.} <.fgintersect> the pairs $[g,|g\cap N| ]$ for all $g$ in <.fg>. Here $N$ is the forbidden set.
##    \item{3.5.} <.sigs> the known admissible signatures (this is a subset of the set in number 2. 
##               of course)
##  \endlist
##  \endlist
##
##  The list <globalSigData> can be used if different groups are studied. If a group has a normal 
##  subgroup with parameters (in the sense of <.cspara>) listed in <globalSigData>, the signatures
##  from a previous calculation may be used. Of course, the factor groups have to be checked first.
##  This check is done with "MatchingFGData" or "MatchingFGDataNonGrp". 
##
##  So the second run of `SignatureDataForNormalSubgroups' with the same parameters and different 
##  <Gdata> and <Normals> will normally be much faster, as the signatures are already stored in 
##  <globalSigData>. Note that <maxtest> and <moretest> are not stored. So a second run with 
##  larger <maxtest> will not result in a recalculation of signatures.
##  
##
DeclareOperation("SignatureDataForNormalSubgroups",
        [IsDenseList,IsList,IsObject,IsRecord,IsDenseList]);


#############################################################################
##
#O MultiplicityInvariantLargeLambda( <set>,<Gdata>)
## 
##  Let <set> be a partial relative difference set with $\lambda>1$. 
##  Set `<P>:=AllPresentables(<set>,<Gdata>)' then the set of multiplicities
##  of <P> is an invariant for partial relative difference sets.
##
##  `MultiplicityInvariantLargeLambda' returns a list in a form as `Collected'
##  does.
##
DeclareOperation("MultiplicityInvariantLargeLambda",[IsDenseList,IsRecord]);


#############################################################################
##
#O NormalSgsForQuotientImages(<forbidden>,<Gdata>)
##
##  calculates all normal subgroups of <Gdata.G> which lie in <forbidden>.
##  The returned value is a list of normal subgroups which define pairwise
##  non-isomorphic factor groups.
##
DeclareOperation("NormalSgsForQuotientImages",
        [IsMagmaWithInverses,IsRecord]);
DeclareOperation("NormalSgsForQuotientImages",
        [IsDenseList,IsRecord]);


#############################################################################
##
#O DataForQuotientImage(<normal>,<forbidden>,<k>,<lambda>,<Gdata>);
##
##  Let <Gdata> be the usual record for a group $G$. And let <k> and <lambda>
##  be the parameters of the relative difference set we want to find. 
##  Let then <forbidden> be the forbidden set (as a group or a list of group 
##  elements or integers) and <normal> a normal subgroup of $G$ which is
##  contained in <forbidden>.
##
##  Then `DataForQuotientImage' returns a record containing the record 
##  <.Gdata> of the factor group $G/U$ where the automorphism group is the one
##  induced by the stabiliser of <normal> in the automorphism group of $G$.
##  Furthermore the returned record contains the forbidden set <.forbidden> in
##  $G/U$ and the new parameter <.lambda> for the difference set in $G/U$.
##
DeclareOperation("DataForQuotientImage",
        [IsMagmaWithInverses,IsMagmaWithInverses,IsPosInt,IsPosInt,IsRecord]);

DeclareOperation("DataForQuotientImage",
        [IsMagmaWithInverses,IsDenseList,IsPosInt,IsPosInt,IsRecord]);


#############################################################################
##
#O OrderedSigsFromQuotientImages(<fGroupData>,<qimages>,<forbidden>,<normal>,<Gdata>)
##
##  Let <Gdata> be the usual record for a group $G$ and <normal> a normal 
##  subgroup of $G$ which lies in the forbidden set <forbidden>.
##  Let then <fGroupData> be the record <.Gdata> describing $G/<normal>$ as 
##  returned by "DataForQuotientImage" and <qimages> a set of difference sets 
##  in $G/<normal>$.
##
##  Then `OrderedSigsFromQuotientImages' returns a record containing a list of 
##  ordered signatures <.orderedSigs> and a list of cosets <.cosets> as well as
##  the factor group <.fg> defined by <fGroupData> and its full automorphism
##  group <fgaut> and the image of <forbidden> in <.fg> is returned as <.Nfg>.
##
DeclareOperation("OrderedSigsFromQuotientImages",
        [IsRecord,IsDenseList,IsObject,IsMagmaWithInverses,IsRecord]);

#############################################################################
##
#O OrderedSigInvariant(<set>,<data>)  calculate ordered signatures
## 
##  does the same as "SigInvariant", but for ordered signatures. Here <data> 
##  has to be a list of records containing ordered signatures called 
##  <.orderedSigs> and cosets <.cosets> just as returned by
##  "OrderedSigsFromQuotientImages". 
##
DeclareOperation("OrderedSigInvariant",[IsDenseList,IsDenseList]);



#############################################################################
##
#O MatchingFGDataForOrderedSigs(<forbidden>,<Gdata>,<Normalsgs>,<fgdata>)
## 
##  Let <fgdata> be a list of records of the form returned by 
##  "OrderedSigsFromQuotientImages" and <Normalsgs> a list of normal subgroups
##  of the group <Gdata.G>. Furthermore let <forbidden> be the forbidden set
##  as a list of group elements or integers or a subgroup of <Gdata.G>.
##  
##  Then `MatchingFGDataForOrderedSigs' retruns all elements of <fgdata> which
##  match a normal subgroup of <Normalsgs>. The returned value is a record 
##  containing the normal subgroup <.normal> from <Normalsgs>, the record 
##  <.sigdata> from <fgdata> and a homomorphism <.hom> which maps <Gdata.G> 
##  onto <.sigdata.Gdata.G> and takes <forbidden> to <.sigdata.Nfg>.
##
DeclareOperation("MatchingFGDataForOrderedSigs",
        [IsObject,IsRecord,IsDenseList,IsDenseList]);
        
        
#############################################################################
##
#E   ........ ENDE
##
