#############################################################################
##
#W lazy.gd 			 RDS Package		 Marc Roeder
##
##  Some black-box functions for quick-and-dirty calculations
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
#O IsDiffset(<diffset>,[<forbidden>],<Gdata>,[<lambda>])
#O IsDiffset(<diffset>,[<forbidden>],<group>,[<lambda>])
##
##  This function tests if <diffset> is a relative difference set with
##  forbidden set <forbidden> and parameter <lambda> in the group <group>.
##  If <Gdata> is the record calculated by "PermutationRepForDiffsetCalculations",
##  <diffset> and <forbidden> have to be lists of integers. If a group
##  <group> is given, <diffset> and <forbidden> must consist of elements
##  of this group.
##
##  If <forbidden> is not given, it is assumed to be trivial. If <lambda>
##  is not given, it is set to $1$. Note that $1$ (`One(<group>)', respectively)
##  *must not* be element of <diffset>.
## 
DeclareOperation("IsDiffset",[IsDenseList,IsRecord]);
DeclareOperation("IsDiffset",[IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("IsDiffset",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("IsDiffset",[IsDenseList,IsDenseList,IsRecord,IsPosInt]);

DeclareOperation("IsDiffset",[IsDenseList,IsGroup]);
DeclareOperation("IsDiffset",[IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("IsDiffset",[IsDenseList,IsDenseList,IsGroup]);
DeclareOperation("IsDiffset",[IsDenseList,IsDenseList,IsGroup,IsPosInt]);

#############################################################################
##
#O IsPartialDiffset(<diffset>,[<forbidden>],<Gdata>,[<lambda>])
#O IsPartialDiffset(<diffset>,[<forbidden>],<group>,[<lambda>])
##
##  This function tests if <diffset> is a partial relative difference set with
##  forbidden set <forbidden> and parameter <lambda> in the group <group>.
##  If <Gdata> is the record calculated by "PermutationRepForDiffsetCalculations",
##  <diffset> and <forbidden> have to be lists of integers. If a group
##  <group> is given, <diffset> and <forbidden> must consist of elements
##  of this group.
##
##  If <forbidden> is not given, it is assumed to be trivial. If <lambda>
##  is not given, it is set to $1$. Note that $1$ (`One(<group>)', respectively)
##  *must not* be element of <diffset>.
## 
DeclareOperation("IsPartialDiffset",[IsDenseList,IsRecord]);
DeclareOperation("IsPartialDiffset",[IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("IsPartialDiffset",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("IsPartialDiffset",[IsDenseList,IsDenseList,IsRecord,IsPosInt]);

DeclareOperation("IsPartialDiffset",[IsDenseList,IsGroup]);
DeclareOperation("IsPartialDiffset",[IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("IsPartialDiffset",[IsDenseList,IsDenseList,IsGroup]);
DeclareOperation("IsPartialDiffset",[IsDenseList,IsDenseList,IsGroup,IsPosInt]);


#############################################################################
##
#F StartsetsInCoset(<ssets>,<coset>,<forbiddenSet>,<aim>,<autlist>,<sigdat>,<Gdata>,<lambda>)  generic generator for partial relative difference sets
##
##  Assume, we want to generate difference sets ``coset by coset'' modulo some
##  normal subgroup.
##  Let <ssets> be a (possibly empty) set of startsets, <coset> the coset from 
##  which to take the elements to append to the startsets from <ssets>. 
##  Furthermore, let <aim> be the size of the generated partial difference sets
##  (that is, the size of the elements from <ssets> plus the number of elements 
##  to be added from <coset>). Let <autlist> be a list of groups of 
##  automorphisms (in permutation representation) to use with the reduction 
##  algorithm. Here the output from `SuitableAutomorphismsForReduction' can be 
##  used. 
##  And <Gdata> and sigdat are the records as returned by 
##  "PermutationRepForDiffsetCalculations" and 
##  "SignatureDataForNormalSubgroups" (or "SignatureData", alternatively). The
##  parameter <lambda> is the usual one for difference sets (the number of ways
##  of expressing elements outside the forbidden set as quotients).
##
##  Then `StartsetsInCoset' returns a list of partial difference sets (a list of 
##  lists of integers) of length <aim>.
##
##  The list of permutation groups <autlist> is used for equivalence testing. 
##  Each equivalence test is performed calculating equivalence with respect 
##  to the first group, one element per equivalence class is retained and the
##  equivalence test is repeated using the second group from <autlist>...
##  Using an ascending list of automorphism groups can speed up the process 
##  of equivalence testing.
##
DeclareGlobalFunction("StartsetsInCoset");

#############################################################################
##
#F SignatureData(<Gdata>,<forbiddenSet>,<k>,<lambda>,<maxtest>)  quick-and-dirty signature calculation
##
##  Let <Gdata> be a record as returned by "PermutationRepForDiffsetCalculations".
##  Let <forbiddenSet> the forbidden set (as set or group).
##
##  <k> is the length of the relative difference set to be constructed and 
##  <lambda> the usual parameter. <maxtest> is the
##  Then `SignatureData' calls "SignatureDataForNormalSubgroups" for  
##  normal subgroups of order at least `RootInt(Gdata.G)'. Here <maxtest> 
##  is an integer which determines how many permutations of a possible 
##  signature are checked to be a sorted signature. Choose a value of at
##  least $10^5$. Larger numbers here normaly result in better results 
##  when generating difference sets (making reduction more effective).
##
##  `SigntureData' chooses normal subgroups of <Gdata.G> and uses 
##  "SignatureDataForNormalSubgroups" to calculate signature data. The global
##  data generated by "SignatureDataForNormalSubgroups" is just discarded.
##
DeclareGlobalFunction("SignatureData");


#############################################################################
##
#F NormalSgsHavingAtMostNSigs(<sigdata>,<n>,<lengthlist>)  find normal subgroups with few signatures
##
##  Let <sigdata> be a list as returned by "SignatureDataForNormalSubgroups", an
##  integer <n> and a list of integers <lengthlist>.
##  `NormalSgsHavingAtMostNSigs' filters <sigdata> and returns
##  a list of records with components .subgroup and .sigs
##  is returned, such that for every entry
##  .subgroup is a normal subgroup of index in <lengthlist> having at most <n>
##  signatures.
##
DeclareGlobalFunction("NormalSgsHavingAtMostNSigs");
          

#############################################################################
##
#F SuitableAutomorphismsForReduction(<Gdata>,<normalsg>)  quick-and-dirty calculation of automorphism groups for startset reduction
##
##  Given a normal subgroup <normalsg> of <Gdata.G>, the function returns
##  a list containing the group of automorphisms of <Gdata.G> which 
##  stabilizes all cosets modulo <normalsg>. This group is returned as a
##  group of permutations on <Gdata.Glist> (which is actually the right
##  regular representation).
##  The returned list can be used with "StartsetsInCoset".
##
DeclareGlobalFunction("SuitableAutomorphismsForReduction");


#############################################################################
##
#E  END
##