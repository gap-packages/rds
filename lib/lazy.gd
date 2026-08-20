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
##  <#GAPDoc Label="IsDiffset">
##  <ManSection>
##  <Oper Name="IsDiffset" Arg="diffset,[forbidden],Gdata,[lambda]"/>
##  <Oper Name="IsDiffset" Label="for diffset,[forbidden],group,[lambda]" Arg="diffset,[forbidden],group,[lambda]"/>
##  <Description>
##  This function tests if <A>diffset</A> is a relative difference set with
##  forbidden set <A>forbidden</A> and parameter <A>lambda</A> in the group <A>group</A>.
##  If <A>Gdata</A> is the record calculated by <Ref Func="PermutationRepForDiffsetCalculations"/>,
##  <A>diffset</A> and <A>forbidden</A> have to be lists of integers. If a group
##  <A>group</A> is given, <A>diffset</A> and <A>forbidden</A> must consist of elements
##  of this group.
##  <P/>
##  If <A>forbidden</A> is not given, it is assumed to be trivial. If <A>lambda</A>
##  is not given, it is set to <M>1</M>. Note that <M>1</M> (<C>One(<A>group</A>)</C>, respectively)
##  <E>must not</E> be element of <A>diffset</A>.
##  <Example><![CDATA[
##  gap> a:=(1,2,3,4,5,6,7);
##  (1,2,3,4,5,6,7)
##  gap> IsDiffset([a,a^3],Group(a));
##  true
##  gap> IsDiffset([a,a^3],Group(a),2);
##  false
##  gap> IsDiffset([a,a^2,a^4],Group(a),2);
##  true
##  gap> Gdata:=PermutationRepForDiffsetCalculations(Group(a));;
##  gap> IsDiffset([2,4],Gdata);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="IsPartialDiffset">
##  <ManSection>
##  <Oper Name="IsPartialDiffset" Arg="diffset,[forbidden],Gdata,[lambda]"/>
##  <Oper Name="IsPartialDiffset" Label="for diffset,[forbidden],group,[lambda]" Arg="diffset,[forbidden],group,[lambda]"/>
##  <Description>
##  This function tests if <A>diffset</A> is a partial relative difference set with
##  forbidden set <A>forbidden</A> and parameter <A>lambda</A> in the group <A>group</A>.
##  If <A>Gdata</A> is the record calculated by <Ref Func="PermutationRepForDiffsetCalculations"/>,
##  <A>diffset</A> and <A>forbidden</A> have to be lists of integers. If a group
##  <A>group</A> is given, <A>diffset</A> and <A>forbidden</A> must consist of elements
##  of this group.
##  <P/>
##  If <A>forbidden</A> is not given, it is assumed to be trivial. If <A>lambda</A>
##  is not given, it is set to <M>1</M>. Note that <M>1</M> (<C>One(<A>group</A>)</C>, respectively)
##  <E>must not</E> be element of <A>diffset</A>.
##  <Example><![CDATA[
##  gap> a:=(1,2,3,4,5,6,7);
##  (1,2,3,4,5,6,7)
##  gap> IsPartialDiffset([a],Group(a));
##  true
##  gap> IsPartialDiffset([a,a^4],Group(a));
##  false
##  gap> IsPartialDiffset([a,a^4],Group(a),2);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="StartsetsInCoset">
##  <ManSection>
##  <Func Name="StartsetsInCoset" Arg="ssets,coset,forbiddenSet,aim,autlist,sigdat,Gdata,lambda"/>
##  <Description>
##  Assume, we want to generate difference sets <Q>coset by coset</Q> modulo some
##  normal subgroup.
##  Let <A>ssets</A> be a (possibly empty) set of startsets, <A>coset</A> the coset from
##  which to take the elements to append to the startsets from <A>ssets</A>.
##  Furthermore, let <A>aim</A> be the size of the generated partial difference sets
##  (that is, the size of the elements from <A>ssets</A> plus the number of elements
##  to be added from <A>coset</A>). Let <A>autlist</A> be a list of groups of
##  automorphisms (in permutation representation) to use with the reduction
##  algorithm. Here the output from <C>SuitableAutomorphismsForReduction</C> can be
##  used.
##  And <A>Gdata</A> and sigdat are the records as returned by
##  <Ref Func="PermutationRepForDiffsetCalculations"/> and
##  <Ref Func="SignatureDataForNormalSubgroups"/> (or <Ref Func="SignatureData"/>, alternatively). The
##  parameter <A>lambda</A> is the usual one for difference sets (the number of ways
##  of expressing elements outside the forbidden set as quotients).
##  <P/>
##  Then <C>StartsetsInCoset</C> returns a list of partial difference sets (a list of
##  lists of integers) of length <A>aim</A>.
##  <P/>
##  The list of permutation groups <A>autlist</A> is used for equivalence testing.
##  Each equivalence test is performed calculating equivalence with respect
##  to the first group, one element per equivalence class is retained and the
##  equivalence test is repeated using the second group from <A>autlist</A>...
##  Using an ascending list of automorphism groups can speed up the process
##  of equivalence testing.
##  <Log><![CDATA[
##  gap> G:=CyclicGroup(57);;Gdata:=PermutationRepForDiffsetCalculations(G);;
##  gap> sigdat:=SignatureData(Gdata,[One(Gdata.G)],8,1,10^5);;
##  gap> N:=First(NormalSubgroups(G),n->Size(n)=19);
##  gap> auts:=SuitableAutomorphismsForReduction(Gdata,N);
##  [ <permutation group of size 18 with 3 generators> ]
##  gap> g:=One(G);;while g in N do
##  >  g:=Random(G);
##  > od;  
##  gap> coset:=GroupList2PermList(Set(RightCoset(N,g)),Gdata);
##  [ 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50, 53, 56 ]
##  gap> Size(StartsetsInCoset([],coset,[],4,auts,sigdat,Gdata,1));
##  #I  Size 19
##  #I  1/ 0 @ 0:00:00.003
##  #I  Size 26
##  #I  1/ 0 @ 0:00:00.001
##  #I  -->10 @ 0:00:00.004
##  #I  Size 88
##  #I  1/ 0 @ 0:00:00.003
##  #I  -->45 @ 0:00:00.018
##  #I  Size 125
##  #I  1/ 0 @ 0:00:00.006
##  #I  -->64 @ 0:00:00.031
##  64
##  gap> Size(StartsetsInCoset([],coset,[],4,[Group(())],sigdat,Gdata,1));
##  #I  Size 19
##  #I  1/ 0 @ 0:00:00.000
##  #I  Size 136
##  #I  1/ 0 @ 0:00:00.004
##  #I  -->136 @ 0:00:00.024
##  #I  Size 648
##  #I  1/ 0 @ 0:00:00.021
##  #I  -->648 @ 0:00:00.310
##  #I  Size 1140
##  #I  1/ 0 @ 0:00:00.036
##  #I  -->1140 @ 0:00:00.980
##  1140
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("StartsetsInCoset");

#############################################################################
##
#F SignatureData(<Gdata>,<forbiddenSet>,<k>,<lambda>,<maxtest>)  quick-and-dirty signature calculation
##
##  <#GAPDoc Label="SignatureData">
##  <ManSection>
##  <Func Name="SignatureData" Arg="Gdata,forbiddenSet,k,lambda,maxtest"/>
##  <Description>
##  Let <A>Gdata</A> be a record as returned by <Ref Func="PermutationRepForDiffsetCalculations"/>.
##  Let <A>forbiddenSet</A> the forbidden set (as set or group).
##  <P/>
##  <A>k</A> is the length of the relative difference set to be constructed and
##  <A>lambda</A> the usual parameter. <A>maxtest</A> is the
##  Then <C>SignatureData</C> calls <Ref Func="SignatureDataForNormalSubgroups"/> for
##  normal subgroups of order at least <C>RootInt(Gdata.G)</C>. Here <A>maxtest</A>
##  is an integer which determines how many permutations of a possible
##  signature are checked to be a sorted signature. Choose a value of at
##  least <M>10^5</M>. Larger numbers here normaly result in better results
##  when generating difference sets (making reduction more effective).
##  <P/>
##  <C>SigntureData</C> chooses normal subgroups of <A>Gdata.G</A> and uses
##  <Ref Func="SignatureDataForNormalSubgroups"/> to calculate signature data. The global
##  data generated by <Ref Func="SignatureDataForNormalSubgroups"/> is just discarded.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(57);;Gdata:=PermutationRepForDiffsetCalculations(G);;
##  gap> sigdat:=SignatureData(Gdata,[One(Gdata.G)],8,1,10^5);
##  [ rec( 
##        cosets := 
##          [ [ 1, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 
##                51, 54 ], 
##            [ 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50, 
##                53, 56 ], 
##            [ 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, 52, 
##                55, 57 ] ], sigs := [ [ 1, 3, 4 ] ], subgroup := Group([ f2 ]) 
##       ) ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("SignatureData");


#############################################################################
##
#F NormalSgsHavingAtMostNSigs(<sigdata>,<n>,<lengthlist>)  find normal subgroups with few signatures
##
##  <#GAPDoc Label="NormalSgsHavingAtMostNSigs">
##  <ManSection>
##  <Func Name="NormalSgsHavingAtMostNSigs" Arg="sigdata,n,lengthlist"/>
##  <Description>
##  Let <A>sigdata</A> be a list as returned by <Ref Func="SignatureDataForNormalSubgroups"/>, an
##  integer <A>n</A> and a list of integers <A>lengthlist</A>.
##  <C>NormalSgsHavingAtMostNSigs</C> filters <A>sigdata</A> and returns
##  a list of records with components .subgroup and .sigs
##  is returned, such that for every entry
##  .subgroup is a normal subgroup of index in <A>lengthlist</A> having at most <A>n</A>
##  signatures.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("NormalSgsHavingAtMostNSigs");
          

#############################################################################
##
#F SuitableAutomorphismsForReduction(<Gdata>,<normalsg>)  quick-and-dirty calculation of automorphism groups for startset reduction
##
##  <#GAPDoc Label="SuitableAutomorphismsForReduction">
##  <ManSection>
##  <Func Name="SuitableAutomorphismsForReduction" Arg="Gdata,normalsg"/>
##  <Description>
##  Given a normal subgroup <A>normalsg</A> of <A>Gdata.G</A>, the function returns
##  a list containing the group of automorphisms of <A>Gdata.G</A> which
##  stabilizes all cosets modulo <A>normalsg</A>. This group is returned as a
##  group of permutations on <A>Gdata.Glist</A> (which is actually the right
##  regular representation).
##  The returned list can be used with <Ref Func="StartsetsInCoset"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("SuitableAutomorphismsForReduction");


#############################################################################
##
#E  END
##