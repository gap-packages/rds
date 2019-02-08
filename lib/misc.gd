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
##
DeclareGlobalFunction("IsComputableFilter");

#############################################################################
##
#F  OnSubgroups(<subgroup>,<aut>)  Action on subgroups
##
##  For a group $G$ and an automorphism <aut> of $G$, 
##  `OnSubgroups(<subgroup>,<aut>)' is the image of <subgroup> under <aut>
##
DeclareGlobalFunction("OnSubgroups");

#############################################################################
##
#F  OnSubgroupsSet(<subgroupset>,<aut>)  Action on subgroups
##
##  For a group $G$ and an automorphism <aut> of $G$, 
##  `OnSubgroupsSet(<subgroupset>,<aut>)' is the image of the set 
##  <subgroupset>  of subgroups under <aut>. The returned object is again a 
##  set (it ist not tested if  <subgroupset> is a set. Lists are also accepted)
##
DeclareGlobalFunction("OnSubgroupsSet");


#############################################################################
##
#O  CartesianIterator( <tuplelist> )     returns an iterator for the cartesian product of <tuplelist>
##
##  Returns an iterator for `Cartesian(<tuplelist>)'
##
DeclareOperation("CartesianIterator",[IsList]);


#############################################################################
##
#F  ConcatenationOfIterators(<iterlist>)   returns an iterator which is the concatenation of all iterators in <iterlist>.
##
##  `ConcatenationOfIterators(<iterlist>)' returns an iterator which runs 
##  through all iterators in <iterlist>. Note that the returned iterator loops 
##  over the iterators in <iterlist> *sequentially* beginning with the first 
##  one.
##  
##
DeclareGlobalFunction("ConcatenationOfIterators");


DeclareGlobalFunction("Pointwiseleq");
DeclareOperation("RemovedSublist",[IsList,IsList]);
#############################################################################
##
#O PartitionByFunctionNF( <list>,<f> )   partitions a list according to a function.
##
##  `PartitionByFunctionNF( <list>, <f> )' partitions the list <list> 
##  according to the values of the function <f> defined on <list>. 
##  If <f> returns `fail' for some element of <list>, 
##  `PartitionByFunctionNF( <list>, <f> )' enters a break loop. 
##  Leaving the break loop with 'return;' is safe because 
##  `PartitionByFunctionNF' treats `fail' as all other results of <f>.
##
DeclareOperation("PartitionByFunctionNF",[IsList,IsFunction]);

#############################################################################
##
#O PartitionByFunction( <list>,<f> )   partitions a list according to a function.
##
##  `PartitionByFunction( <list>, <f> )' partitions the list <list> 
##  according to the values of the function <f> defined on <list>. 
##  All elements, for which <f> returns `fail' are omitted, so 
##  `PartitionByFunction' does not necessarily return a partition.
##  If `InfoLevel(InfoRDS)'\index{InfoRDS@{\tt InfoRDS}} is at least 2, the number of 
##  elements for which <f> returns `fail' is shown 
##  (if `fail' is returned at all).
##
DeclareOperation("PartitionByFunction",[IsDenseList,IsFunction]);

#############################################################################
##
#O RepsCClassesGivenOrder( <group>, <order> ) find all elements of given order up to conjugacy.
##
##  `RepsCClassesGivenOrder( <group>, <order> )' returns all elements of 
##  order <order> up to conjugacy. Note that the representatives are *not*
##  always the smallest elements of each conjugacy class.
##
DeclareOperation("RepsCClassesGivenOrder",[IsMagmaWithInverses,IsInt]);

#############################################################################
##
#O MatTimesTransMat(<mat>)
##
##  does the same as `<mat>*TransposedMat( <mat> )' but uses slightly less 
##  space and time for large matrices.
##
DeclareOperation("MatTimesTransMat",[IsMatrix]);


#############################################################################
##
#E  END
##