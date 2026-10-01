#############################################################################
##
#W misc.gd 			 RDS Package		 Marc Roeder
##
##  Some methods for general use
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
#F  IsComputableFilter( <filter> )     test if a filter is computable
##
##  <#GAPDoc Label="IsComputableFilter">
##  <ManSection>
##  <Func Name="IsComputableFilter" Arg="filter"/>
##  <Description>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("IsComputableFilter");

#############################################################################
##
#F  OnSubgroups(<subgroup>,<aut>)  Action on subgroups
##
##  <#GAPDoc Label="OnSubgroups">
##  <ManSection>
##  <Func Name="OnSubgroups" Arg="subgroup,aut"/>
##  <Description>
##  For a group <M>G</M> and an automorphism <A>aut</A> of <M>G</M>,
##  <C>OnSubgroups(<A>subgroup</A>,<A>aut</A>)</C> is the image of <A>subgroup</A> under <A>aut</A>
##  <Example><![CDATA[
##  gap> G:=Group((1,2,3),(2,3));
##  Group([ (1,2,3), (2,3) ])
##  gap> alpha:=InnerAutomorphism(G,(1,2,3));
##  ^(1,2,3)
##  gap> OnSubgroups(Subgroup(G,[(2,3)]),alpha);
##  Group([ (1,3) ])
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("OnSubgroups");

#############################################################################
##
#F  OnSubgroupsSet(<subgroupset>,<aut>)  Action on subgroups
##
##  <#GAPDoc Label="OnSubgroupsSet">
##  <ManSection>
##  <Func Name="OnSubgroupsSet" Arg="subgroupset,aut"/>
##  <Description>
##  For a group <M>G</M> and an automorphism <A>aut</A> of <M>G</M>,
##  <C>OnSubgroupsSet(<A>subgroupset</A>,<A>aut</A>)</C> is the image of the set
##  <A>subgroupset</A>  of subgroups under <A>aut</A>. The returned object is again a
##  set (it ist not tested if  <A>subgroupset</A> is a set. Lists are also accepted)
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("OnSubgroupsSet");


#############################################################################
##
#O  CartesianIterator( <tuplelist> )     returns an iterator for the cartesian product of <tuplelist>
##
##  <#GAPDoc Label="CartesianIterator">
##  <ManSection>
##  <Oper Name="CartesianIterator" Arg="tuplelist"/>
##  <Description>
##  Returns an iterator for <C>Cartesian(<A>tuplelist</A>)</C>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("CartesianIterator",[IsList]);


#############################################################################
##
#F  ConcatenationOfIterators(<iterlist>)   returns an iterator which is the concatenation of all iterators in <iterlist>.
##
##  <#GAPDoc Label="ConcatenationOfIterators">
##  <ManSection>
##  <Func Name="ConcatenationOfIterators" Arg="iterlist"/>
##  <Description>
##  <C>ConcatenationOfIterators(<A>iterlist</A>)</C> returns an iterator which runs
##  through all iterators in <A>iterlist</A>. Note that the returned iterator loops
##  over the iterators in <A>iterlist</A> <E>sequentially</E> beginning with the first
##  one.
##  <Log><![CDATA[
##  gap> it:=Iterator([1,2,3]);;
##  gap> it2:=CartesianIterator([[9,10],[11]]);;
##  gap> cit:=ConcatenationOfIterators([it,it2]);;
##  gap> repeat
##  > Print(NextIterator(cit),",\c");
##  > until IsDoneIterator(cit);
##  1,2,3,[ 9, 11 ],[ 10, 11 ],
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("ConcatenationOfIterators");


DeclareGlobalFunction("Pointwiseleq");
DeclareOperation("RemovedSublist",[IsList,IsList]);
#############################################################################
##
#O PartitionByFunctionNF( <list>,<f> )   partitions a list according to a function.
##
##  <#GAPDoc Label="PartitionByFunctionNF">
##  <ManSection>
##  <Oper Name="PartitionByFunctionNF" Arg="list,f"/>
##  <Description>
##  <C>PartitionByFunctionNF( <A>list</A>, <A>f</A> )</C> partitions the list <A>list</A>
##  according to the values of the function <A>f</A> defined on <A>list</A>.
##  If <A>f</A> returns <K>fail</K> for some element of <A>list</A>,
##  <C>PartitionByFunctionNF( <A>list</A>, <A>f</A> )</C> enters a break loop.
##  Leaving the break loop with 'return;' is safe because
##  <C>PartitionByFunctionNF</C> treats <K>fail</K> as all other results of <A>f</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PartitionByFunctionNF",[IsList,IsFunction]);

#############################################################################
##
#O PartitionByFunction( <list>,<f> )   partitions a list according to a function.
##
##  <#GAPDoc Label="PartitionByFunction">
##  <ManSection>
##  <Oper Name="PartitionByFunction" Arg="list,f"/>
##  <Description>
##  <C>PartitionByFunction( <A>list</A>, <A>f</A> )</C> partitions the list <A>list</A>
##  according to the values of the function <A>f</A> defined on <A>list</A>.
##  All elements, for which <A>f</A> returns <K>fail</K> are omitted, so
##  <C>PartitionByFunction</C> does not necessarily return a partition.
##  If <C>InfoLevel(InfoRDS)</C><Index>InfoRDS@ InfoRDS</Index> is at least 2, the number of
##  elements for which <A>f</A> returns <K>fail</K> is shown
##  (if <K>fail</K> is returned at all).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PartitionByFunction",[IsDenseList,IsFunction]);

#############################################################################
##
#O RepsCClassesGivenOrder( <group>, <order> ) find all elements of given order up to conjugacy.
##
##  <#GAPDoc Label="RepsCClassesGivenOrder">
##  <ManSection>
##  <Oper Name="RepsCClassesGivenOrder" Arg="group, order"/>
##  <Description>
##  <C>RepsCClassesGivenOrder( <A>group</A>, <A>order</A> )</C> returns all elements of
##  order <A>order</A> up to conjugacy. Note that the representatives are <E>not</E>
##  always the smallest elements of each conjugacy class.
##  <Example><![CDATA[
##  gap> RepsCClassesGivenOrder(SymmetricGroup(5),2);
##  [ (4,5), (2,3)(4,5) ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("RepsCClassesGivenOrder",[IsMagmaWithInverses,IsInt]);

#############################################################################
##
#O MatTimesTransMat(<mat>)
##
##  <#GAPDoc Label="MatTimesTransMat">
##  <ManSection>
##  <Oper Name="MatTimesTransMat" Arg="mat"/>
##  <Description>
##  does the same as <C><A>mat</A>*TransposedMat( <A>mat</A> )</C> but uses slightly less
##  space and time for large matrices.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("MatTimesTransMat",[IsMatrix]);


#############################################################################
##
#E  END
##