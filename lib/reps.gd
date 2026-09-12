#############################################################################
##
#W reps.gd 			 RDS Package		 Marc Roeder
##
##  Representation theoretic methods for a special class of groups and difference sets
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
#V InfoRDS  info class of the RDS package
##
##  <#GAPDoc Label="InfoRDS">
##  <ManSection>
##  <InfoClass Name="InfoRDS"/>
##  <Description>
##  Some methods of the RDS package print additional information if <C>InfoRDS</C>
##  is set to a level of 1 or higher. At level 0, no information is output.
##  The default value is 1.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareInfoClass("InfoRDS");

#############################################################################
##
#V DebugRDS  info class of the RDS package
##
##  <#GAPDoc Label="DebugRDS">
##  <ManSection>
##  <InfoClass Name="DebugRDS"/>
##  <Description>
##  Some methods of the RDS package print additional information if <C>DebugRDS</C>
##  is set to a level of 1 or higher. At level 0, no information is output.
##  The default level is 0. Expect a lot of output at level 2.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareInfoClass("DebugRDS");

#############################################################################
##
#P IsListOfIntegers( <list> )	test if a collection contains only integers.
##
##  <#GAPDoc Label="IsListOfIntegers">
##  <ManSection>
##  <Prop Name="IsListOfIntegers" Arg="list"/>
##  <Description>
##  <C>IsListOfIntegers( <A>list</A> )</C> returns <C>IsSubset(Integers, <A>list</A> )</C> if <A>list</A>
##  is a dense list and <K>false</K> otherwise.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsListOfIntegers",IsList);

#############################################################################
##
#P IsRootOfUnity( <cyc> )     test if a cyclotomic is a root of unity.
##
##  <#GAPDoc Label="IsRootOfUnity">
##  <ManSection>
##  <Prop Name="IsRootOfUnity" Arg="cyc"/>
##  <Description>
##  <C>IsRootOfUnity</C> tests if a given cyclotomic is actually a root of unity.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty("IsRootOfUnity",IsCyclotomic);


#############################################################################
##
#O  CoeffList2CyclotomicList( <list>,<root> ) takes a list of integers and returns a list of integral cyclotomics.
##
##  <#GAPDoc Label="CoeffList2CyclotomicList">
##  <ManSection>
##  <Oper Name="CoeffList2CyclotomicList" Arg="list,root"/>
##  <Description>
##  <C>CoeffList2CyclotomicList( <A>list</A>, <A>root</A> )</C> takes a list of integers
##  <A>list</A> and a root of unity <A>root</A> and returns a list <A>list2</A>, where
##  &lt;list2[i]=list[i]* root^(i-1)&gt;.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("CoeffList2CyclotomicList",[IsSmallList,IsCyc]);

#############################################################################
##
#O  AbssquareInCyclotomics( <list>,<root> ) returns the modulus of an algebraic integer given by <list> and <root>.
##
##  <#GAPDoc Label="AbssquareInCyclotomics">
##  <ManSection>
##  <Oper Name="AbssquareInCyclotomics" Arg="list,root"/>
##  <Description>
##  For a list of integers and a root of unity,
##  <C>AbssquareInCyclotomics( <A>list</A>, <A>root</A> )</C> returns
##  the modulus of <C>Sum(CoeffList2CyclotomicList( <A>list</A>, <A>root</A> ))</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AbssquareInCyclotomics",[IsSmallList,IsCyc]);

#############################################################################
##
#O  List2Tuples( <list>,<int> ) splits <list> into <int> parts
##
##  <#GAPDoc Label="List2Tuples">
##  <ManSection>
##  <Oper Name="List2Tuples" Arg="list,int"/>
##  <Description>
##  If <C>Size( <A>list</A> )</C> is divisible by <A>int</A>, <C>List2Tuples( <A>list</A>,<A>int</A>)</C>
##   returns a list <A>list2</A> of size <A>int</A> such that
##  <C>Concatenation( <A>list2</A> )= <A>list</A></C> and every element of <A>list2</A> has the
##   same size.
##  <Example><![CDATA[
##  gap> List2Tuples([1..6],2);
##  [ [ 1 .. 3 ], [ 4 .. 6 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("List2Tuples",[IsList,IsPosInt]);

#############################################################################
##
#O  CycsGivenCoeffSum( <sum>, <root> ) returns all cyclotomic integers with given coefficient sum.
##
##  <#GAPDoc Label="CycsGivenCoeffSum">
##  <ManSection>
##  <Oper Name="CycsGivenCoeffSum" Arg="sum, root"/>
##  <Description>
##  <C>CycsGivenCoeffSum( <A>sum</A>, <A>root</A> )</C> returns all elements of <M>&ZZ;[ root ]</M>
##  such that the coefficient sum is <A>sum</A> and all coefficients are
##  non-negative.
##  The returned list has the following form:
##  The cyclotomic numbers are represented by coefficients.
##  <Ref Func="CoeffList2CyclotomicList"/> can be used to get the
##  algebraic number represented by <A>list</A>.
##  The list is partitioned into equivalence classes of elements having the
##  same modulus.
##  For each class the modulus is returned.
##  This means that <C>CycsGivenCoeffSum</C> returns a list of pairs where the first
##  entry of each pair is the square of the modulus of an element of the
##  second entry. And the second entry is a list of coefficient lists of
##  cyclotomics in <M>&ZZ;[ &lt;root&gt; ]</M> having the coefficient sum <A>sum</A>.
##  <Example><![CDATA[
##  gap> CycsGivenCoeffSum(3,E(3));
##  [ [ 0, [ [ 1, 1, 1 ] ] ], 
##    [ 3, [ [ 0, 1, 2 ], [ 0, 2, 1 ], [ 1, 0, 2 ], [ 1, 2, 0 ], [ 2, 0, 1 ], 
##            [ 2, 1, 0 ] ] ], [ 9, [ [ 0, 0, 3 ], [ 0, 3, 0 ], [ 3, 0, 0 ] ] ] ]
##  gap> CycsGivenCoeffSum(2,E(2));
##  [ [ 0, [ [ 1, 1 ] ] ], [ 4, [ [ 0, 2 ], [ 2, 0 ] ] ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("CycsGivenCoeffSum",[IsCyc,IsCyc]);

#############################################################################
##
#O NormalSubgroupsForRep( <groupdata>,<divisor> ) calculates normal subgroups to use with `OrderedSigs'
##
##  <#GAPDoc Label="NormalSubgroupsForRep">
##  <ManSection>
##  <Oper Name="NormalSubgroupsForRep" Arg="groupdata,divisor"/>
##  <Description>
##  Let <A>groupdata</A> be the output of <Ref Func="PermutationRepForDiffsetCalculations"/> and
##  <A>divisor</A> an integer. Then <C>NormalSubgroupsForRep</C> calculates all  normal
##  subgroups of <A>groupdata.G</A> such that the size of the factor group is divisible
##  by <A>divisor</A> and the factor group is a semidirect product of cyclic groups.
##  <P/>
##  The output is a record consisting of
##  <List>
##  <Mark>1.</Mark>
##  <Item> a normal subgroup &lt;.Nsg&gt; of <A>G</A>
##   </Item>
##  <Mark>2.</Mark>
##  <Item> the factor group &lt;.fgrp&gt;:=<A>G</A>/<A>Nsg</A>
##   </Item>
##  <Mark>3.</Mark>
##  <Item> the epimorphism &lt;.epi&gt; from <A>G</A> to &lt;.fgrp&gt;
##   </Item>
##  <Mark>4.</Mark>
##  <Item> a root of unity &lt;.root&gt;
##   </Item>
##  <Mark>5.</Mark>
##  <Item> a galois automorphism &lt;.alpha&gt;
##   </Item>
##  <Mark>6.+7.</Mark>
##  <Item> generators of the factor group <A>G</A>/&lt;.Nsg&gt; named &lt;.a&gt; and &lt;.b&gt;
##             such that &lt;.a&gt; is normalized by &lt;.b&gt;.
##   </Item>
##  <Mark>8</Mark>
##  <Item>  a list &lt;.int2pairtable&gt; such that the <M>i^{th}</M> entry is the pair
##             &lt;[m,n]&gt; with that &lt;Glist[i]^epi=a^(m-1)*b^(n-1)&gt;</Item>
##  </List>
##  &lt;.alpha&gt; and &lt;.root&gt; may be used as input for <Ref Func="OrderedSigs"/>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("NormalSubgroupsForRep",[IsRecord,IsInt]);

#############################################################################
##
#O  OrderedSigs(<coeffSums>,<absSum>,<alpha>,<root>)
##
##  <#GAPDoc Label="OrderedSigs">
##  <ManSection>
##  <Oper Name="OrderedSigs" Arg="coeffSums,absSum,alpha,root"/>
##  <Description>
##  Let <M>G</M> be group which contains a normal subgroup of index <M>s</M> such that
##  the coset signature for a difference set for this normal subgroup is
##  <A>coeffSums</A>. Let <M>N</M> be a normal subgroup of <M>G</M> such that <M>G/N</M> is a
##  semidirect product of cyclic group of orders <M>s,q</M>  and
##  <M>i</M> divides the order of <M>G/N</M>.
##  <P/>
##  Then <C>OrderedSigs(<A>coeffSums</A>,<A>absSum</A>,<A>alpha</A>,<A>root</A>)</C> calculates
##  all ordered signatures for <M>N</M>. Here <A>root</A> is a primitive <M>q</M>-th root
##  of unity and <A>alpha</A> is a Galois- automorphism of <M>CS(q)</M> with order
##  dividing <M>s</M>. <A>absSum</A> is the order of the difference set.
##  (i.e. <M>order=k-\lambda</M>).
##  <P/>
##  <C>OrderedSigs</C> is based on calculations using an <M>s</M>-dimensional unitary
##  representation of <M>G/N</M>.
##  In this representation a subset of <M>G</M> induces a semi-circular matrix.
##  The returned value is a list of lists <M>s</M>-tuples
##  The entries of the <M>s</M>-tuples are coefficients of  numbers in
##  <M>&ZZ;[&lt;root&gt;]</M> such that the semi-circular matrix defined by these numbers
##  together with <A>alpha</A> meets necessary conditions for matrices induced
##  by difference sets.
##  To gain the algebraic numbers from the <M>s</M>-tuple <A>tup</A>, use
##  <C>List(<A>tup</A>,i-&gt;CoeffList2CyclotomicList(i,<A>root</A>))</C>
##  <P/>
##  Each <M>|&lt;coeffSums&gt;|</M>-tuple returned defines an ordered signature. The ordering
##  of <M>G/N</M> is chosen to fit to the data returned by <Ref Func="NormalSubgroupsForRep"/>:
##  <P/>
##  <M>[a^0,a^1,\dots,a^{q-1}],[a^0b,a^1b,\dots,a^{q-1}b],\dots,[a^0b^{s-1},\dots,a^{q-1}b^{s-1}]</M>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("OrderedSigs",[IsSmallList,IsPosInt,IsGeneralMapping,IsCyc]);

#############################################################################
##
#O OrderedSignatureOfSet(set,normal_data)
##
##  <#GAPDoc Label="OrderedSignatureOfSet">
##  <ManSection>
##  <Oper Name="OrderedSignatureOfSet" Arg="set,normal_data"/>
##  <Description>
##  takes a set <A>set</A> of integers (meant to be a partial difference set) and
##  a list of records as returned by <Ref Func="NormalSubgroupsForRep"/>.
##  The returned value is a list of lists which is the ordered signature of the
##  partial difference set <A>set</A> and can be compared to the output of <Ref Func="OrderedSigs"/>
##  <Log><![CDATA[
##  gap> OrderedSignatureOfSet([2,3,4,5],nsgs[2]);  
##  [ [ 1, 1, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0 ] ]
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("OrderedSignatureOfSet",[IsDenseList,IsRecord]);
  
#############################################################################
##
#E  END
##

