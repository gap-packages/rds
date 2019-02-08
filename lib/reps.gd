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
##  Some methods of the RDS package print additional information if `InfoRDS'
##  is set to a level of 1 or higher. At level 0, no information is output. 
##  The default value is 1.
##
DeclareInfoClass("InfoRDS");

#############################################################################
##
#V DebugRDS  info class of the RDS package
## 
##  Some methods of the RDS package print additional information if `DebugRDS'
##  is set to a level of 1 or higher. At level 0, no information is output. 
##  The default level is 0. Expect a lot of output at level 2.
##
DeclareInfoClass("DebugRDS");

#############################################################################
##
#P IsListOfIntegers( <list> )	test if a collection contains only integers.
##
##  `IsListOfIntegers( <list> )' returns `IsSubset(Integers, <list> )' if <list>
##  is a dense list and `false' otherwise.
##
DeclareProperty("IsListOfIntegers",IsList);

#############################################################################
##
#P IsRootOfUnity( <cyc> )     test if a cyclotomic is a root of unity.
##
##  `IsRootOfUnity' tests if a given cyclotomic is actually a root of unity.
##
DeclareProperty("IsRootOfUnity",IsCyclotomic);


#############################################################################
##
#O  CoeffList2CyclotomicList( <list>,<root> ) takes a list of integers and returns a list of integral cyclotomics.
##
##  `CoeffList2CyclogomicList( <list>, <root> )' takes a list of integers 
##  <list> and a root of unity <root> and returns a list <list2>, where 
##  <list2[i]=list[i]\* root^(i-1)>.
##
DeclareOperation("CoeffList2CyclotomicList",[IsSmallList,IsCyc]);

#############################################################################
##
#O  AbssquareInCyclotomics( <list>,<root> ) returns the modulus of an algebraic integer given by <list> and <root>.
##
##  For a list of integers and a root of unity, 
##  `AbssquareInCyclotomics( <list>, <root> )' returns 
##  the modulus of `Sum(CoeffList2CyclotomicList( <list>, <root> ))'.
##
DeclareOperation("AbssquareInCyclotomics",[IsSmallList,IsCyc]);

#############################################################################
##
#O  List2Tuples( <list>,<int> ) splits <list> into <int> parts
##
##  If `Size( <list> )' is divisible by <int>, `List2Tuples( <list>,<int>)'
##  returns a list <list2> of size <int> such that 
## `Concatenation( <list2> )= <list>' and every element of <list2> has the 
##  same size.
##
DeclareOperation("List2Tuples",[IsList,IsPosInt]);

#############################################################################
##
#O  CycsGivenCoeffSum( <sum>, <root> ) returns all cyclotomic integers with given coefficient sum.
##
##  `CycsGivenCoeffSum( <sum>, <root> )' returns all elements of $\Z[ root ]$
##  such that the coefficient sum is <sum> and all coefficients are 
##  non-negative.
##  The returned list has the following form:
##  The cyclotomic numbers are represented by coefficients. 
##  "CoeffList2CyclotomicList" can be used to get the 
##  algebraic number represented by <list>.
##  The list is partitioned into equivalence classes of elements having the 
##  same modulus.
##  For each class the modulus is returned.
##  This means that `CycsGivenCoeffSum' returns a list of pairs where the first
##  entry of each pair is the square of the modulus of an element of the 
##  second entry. And the second entry is a list of coefficient lists of 
##  cyclotomics in $\Z[ <root> ]$ having the coefficient sum <sum>. 
##
DeclareOperation("CycsGivenCoeffSum",[IsCyc,IsCyc]);

#############################################################################
##
#O NormalSubgroupsForRep( <groupdata>,<divisor> ) calculates normal subgroups to use with `OrderedSigs'
##
##  Let <groupdata> be the output of "PermutationRepForDiffsetCalculations" and 
##  <divisor> an integer. Then `NormalSubgroupsForRep' calculates all  normal 
##  subgroups of <groupdata.G> such that the size of the factor group is divisible 
##  by <divisor> and the factor group is a semidirect product of cyclic groups.
##
##  The output is a record consisting of 
##  \beginlist
##   \item{1.} a normal subgroup <.Nsg> of <G>
##   \item{2.} the factor group <.fgrp>:=<G>/<Nsg> 
##   \item{3.} the epimorphism <.epi> from <G> to <.fgrp>
##   \item{4.} a root of unity <.root>
##   \item{5.} a galois automorphism <.alpha>
##   \item{6.+7.} generators of the factor group <G>/<.Nsg> named <.a> and <.b> 
##             such that <.a> is normalized by <.b>.
##   \item{8}  a list <.int2pairtable> such that the $i^{th}$ entry is the pair 
##             <[m,n]> with that <Glist[i]^epi=a^(m-1)\*b^(n-1)>
##  \endlist
##
##  <.alpha> and <.root> may be used as input for "OrderedSigs"
##  
DeclareOperation("NormalSubgroupsForRep",[IsRecord,IsInt]);

#############################################################################
##
#O  OrderedSigs(<coeffSums>,<absSum>,<alpha>,<root>)
##
##  Let $G$ be group which contains a normal subgroup of index $s$ such that 
##  the coset signature for a difference set for this normal subgroup is 
##  <coeffSums>. Let $N$ be a normal subgroup of $G$ such that $G/N$ is a 
##  semidirect product of cyclic group of orders $s,q$  and 
##  $i$ divides the order of $G/N$. 
##
##  Then `OrderedSigs(<coeffSums>,<absSum>,<alpha>,<root>)' calculates 
##  all ordered signatures for $N$. Here <root> is a primitive $q$-th root 
##  of unity and <alpha> is a Galois- automorphism of $CS(q)$ with order 
##  dividing $s$. <absSum> is the order of the difference set.
##  (i.e. $order=k-\lambda$).
##  
##  `OrderedSigs' is based on calculations using an $s$-dimensional unitary 
##  representation of $G/N$. 
##  In this representation a subset of $G$ induces a semi-circular matrix.
##  The returned value is a list of lists $s$-tuples
##  The entries of the $s$-tuples are coefficients of  numbers in 
##  $\Z[<root>]$ such that the semi-circular matrix defined by these numbers
##  together with <alpha> meets necessary conditions for matrices induced
##  by difference sets.
##  To gain the algebraic numbers from the $s$-tuple <tup>, use 
##  `List(<tup>,i->CoeffList2CyclotomicList(i,<root>))'
##
##  Each $|<coeffSums>|$-tuple returned defines an ordered signature. The ordering
##  of $G/N$ is chosen to fit to the data returned by "NormalSubgroupsForRep":
##
##  $[a^0,a^1,\dots,a^{q-1}],[a^0b,a^1b,\dots,a^{q-1}b],\dots,[a^0b^{s-1},\dots,a^{q-1}b^{s-1}]$
##
DeclareOperation("OrderedSigs",[IsSmallList,IsPosInt,IsGeneralMapping,IsCyc]);

#############################################################################
##
#O OrderedSignatureOfSet(set,normal_data)
##
##  takes a set <set> of integers (meant to be a partial difference set) and
##  a list of records as returned by "NormalSubgroupsForRep".
##  The returned value is a list of lists which is the ordered signature of the
##  partial difference set <set> and can be compared to the output of "OrderedSigs"
##
DeclareOperation("OrderedSignatureOfSet",[IsDenseList,IsRecord]);
  
#############################################################################
##
#E  END
##

