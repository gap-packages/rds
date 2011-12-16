#############################################################################
##
#W lazy.gd 			 RDS Package		 Marc Roeder
##
##  Some black-box functions for quick-and-dirty claculations
##
#H @(#)$Id: lazy.gd, v 0.9beta21 15/11/2006 19:33:30 gap Exp $
##
#Y	 Copyright (C) 2006 Marc Roeder 
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
Revision.("rds/lib/lazy_gd"):=
	"@(#)$Id: lazy.gd, v 0.9beta21 15/11/2006   19:33:30  gap Exp $";
#############################################################################
##
#F StartsetsInCoset(<ssets>,<coset>,<forbiddenSet>,<aim>,<autlist>,<sigdat>,<data>,<lambda>)  generic generator for partial relative difference sets
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
##  And <data> and sigdat are the records as returned by 
##  `PermutationRepForDiffsetCalculations' and 
##  `SignatureDataForNormalSubgroups' (or `SignatureData', alternatively). The
##  parameter <lambda> is the usual one for difference sets (the number of ways
##  of expressing elements outside the forbidden set as quotients).
##
##  Then `StartsetsInCoset' returns a list of partial difference sets (a list of 
##  lists of integers) of length <aim>.
##
DeclareGlobalFunction("StartsetsInCoset");

#############################################################################
##
#O SignatureData(<Gdata>,<forbiddenSet>,<k>,<lambda>,<maxtest>)  quick-and-dirty signature calculation
##
##  Let <Gdata> be a record as returned by `PermutationRepForDiffsetCalculations'.
##  Let <forbiddenSet> the forbidden set (as set or group).
##
##  <k> is the length of the relative difference set to be constructed and 
##  <lambda> the usual parameter. <maxtest> is the
##  Then `SignatureData' calls `SignatureDataForNormalSubgroups' for  
##  normal subgroups of order at least `RootInt(Gdata.G)'. Here <maxtest> 
##  is an integer which determines how many permutations of a possible 
##  signature are checked to be a sorted signature. Choose a value of at
##  least $10^5$. Larger numbers here normaly result in better results 
##  when generating difference sets (making reduction more effective).
##
DeclareGlobalFunction("SignatureData");


#############################################################################
##
#F NormalSgsHavingAtMostNSigs(<sigdata>,<n>,<lengthlist>)  find normal subgroups with few signatures
##
##  Let <sigdata> be a list as returned by 'SignatureDataForNormalSubgroups', an
##  integer <n> and a list of integers <lengthlist>.
##  `NormalSgsHavingAtMostKSigs' filters <sigdata> and returns
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
##  The returned list can be used with `StartsetsInCoset'.
##
DeclareGlobalFunction("SuitableAutomorphismsForReduction");