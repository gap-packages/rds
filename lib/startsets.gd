#############################################################################
##
#W startsets.gd 			 RDS Package		 Marc Roeder
##
##  Basic methods for startset generation
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
#O  PermutationRepForDiffsetCalculations(<group>) generate some initial objects for the RDS package
#O  PermutationRepForDiffsetCalculations(<group>,<autgrp>) generate some initial objects for the RDS package
##
##  For a group <group>, `PermutationRepForDiffsetCalculations(<group>)'
##  returns a record containing:
##  \beginlist
##   \item{1.} the group <.G>=<group>.
##   \item{2.} the sorted list <.Glist>=`Set(<group>)',
##   \item{3.} the automorphism group <.A> of <group>,
##   \item{4.} the group <.Aac>, which is the permutation action of <A> on the indices of <.Glist>,
##   \item{5.} <.Ahom>=`ActionHomomorphism(<.A>,<.Glist>)',
##   \item{6.} the group <.Ai> of anti-automorphisms of <.group> acting on the indices of <Glist>,
##   \item{7.} the multiplication table <.diffTable> of <.group> in a special form.
##  \endlist
##  
##  <.diffTable> is a matrix of integers defined such that 
##  `<.difftable>[i][j]' is the position of `<Glist>[i](<Glist>[j])^{-1})'
##  in <Glist> with `<Glist>[1]=One(<group>)'.
##
##  `PermutationRepForDiffsetCalculations' runs into an error if 
##  `Set(<group>)[1]' is not equal to `One(<group>)'.
##
##  If <autgrp> is given, `PermutationRepForDiffsetCalculations' will not calculate the
##  automorphism group of <group> but will take <autgrp> instead without any test.
##
DeclareOperation("PermutationRepForDiffsetCalculations",[IsGroup]);
DeclareOperation("PermutationRepForDiffsetCalculations",[IsGroup,IsGroup]);

#############################################################################
##
#O PermList2GroupList(<list>,<Gdata>) 
##
##  converts a list of integers into group elements according to the 
##  enumeration given in Gdata.Glist.
##  Here <Gdata> is a record containing .diffTable as returned by 
##  "PermutationRepForDiffsetCalculations".
##
##
DeclareOperation("PermList2GroupList",[IsDenseList,IsRecord]);


#############################################################################
##
#O GroupList2PermList(<list>,<Gdata>) 
##
##  converts a list of group elements to integers according to the 
##  enumeration given in Gdata.Glist.
##  Here <Gdata> is a record containing .diffTable as returned by 
##  "PermutationRepForDiffsetCalculations".
##
##
DeclareOperation("GroupList2PermList",[IsDenseList,IsRecord]);

#############################################################################
##
#O  NewPresentables( <list>,<newel>,<table> ) calculates quotients of a list and a given element.
#O  NewPresentables( <list>,<newel>,<Gdata> ) calculates quotients of a list and a given element.
#O  NewPresentables( <list>,<newlist>,<Gdata> ) calculates quotients of two lists
#O  NewPresentables( <list>,<newlist>,<table> ) calculates quotients of two lists
##
##  `NewPresentables( <list>,<newel>,<Gdata> )' takes a record <Gdata> as 
##  returned by `PermutationRepForDiffsetCalculations(<group>)'.
##  For `NewPresentables( <list>,<newel>,<table> )', <table> has to be the
##  multiplication table in the form of  
##  `NewPresentables( <list>,<newel>,<Gdata.diffTable>)'
##
##  The method returns the unordered list of quotients $d_1<newel>^{-1}$ with 
##  $d_1\in <list>\cup\{1\}$ (in permutation representation).
##
##  When used with a list <newlist>, a list of quotients $d_1d_2^{-1}$ with 
##  $d_1\in <list>\cup\{1\}$ and $d_2\in <newlist>$ is returned.
##
DeclareOperation("NewPresentables",[IsDenseList,IsInt,IsMatrix]);
DeclareOperation("NewPresentables",[IsDenseList,IsInt,IsRecord]);
DeclareOperation("NewPresentables",[IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("NewPresentables",[IsDenseList,IsDenseList,IsRecord]);



#############################################################################
##
#O  AllPresentables( <list>,<table> ) calculates quotients of elements in <list>.
#O  AllPresentables( <list>,<Gdata> ) calculates quotients of elements in <list>.
##
##  Let <list> be a list of integers representing elements of a group defined 
##  by <Gdata> (or <table>).
##  `AllPresentables( <list>,<table>)' returns an unordered list of 
##  quotients $ab^{-1}$ for all group elements $a,b$  represented by integers 
##  in <list>. If $1\in <list>$, an error is issued.
##  The multiplication table <table> has to be of the form as returned by 
##  "PermutationRepForDiffsetCalculations". And <Gdata> is a record as 
##  calculated by "PermutationRepForDiffsetCalculations".
##
DeclareOperation("AllPresentables",[IsDenseList,IsMatrix]);
DeclareOperation("AllPresentables",[IsDenseList,IsRecord]);

#############################################################################
##
#O  RemainingCompletions( <diffset>,<completions>[,<forbidden>],<Gdata>[,<lambda>] ) calculates all elements of <completions> which may be added to the partial difference set <diffset>.
#O  RemainingCompletionsNoSort( <diffset>,<completions>[,<forbidden>],<table>[,<lambda>] ) calculates all elements of <completions> which may be added to the partial difference set <diffset>.
##
##  For a partial difference set <diffset>, 
##  `RemainingCompletions(<diffset>,<completions>,<Gdata>)' returns a 
##  subset of the *set* <completions>, such that each of its elements may be 
##  added to <diffset> without it loosing the property to be a partial 
##  difference set. 
##  Only elements greater than the last element of <diffset> are returned.
##
##  For partial *relative* difference sets, <forbidden> is the forbidden set.
##  
##  `RemainingCompletionsNoSort' does also return elements from <completions> which
##  are smaller than `<diffset>[Size(<diffset>)]'. 
##
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsMatrix,IsPosInt]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsDenseList,IsMatrix,IsPosInt]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("RemainingCompletionsNoSort",[IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsMatrix,IsPosInt]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsDenseList,IsMatrix,IsPosInt]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("RemainingCompletions",[IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt]);



#############################################################################
##
#O  ExtendedStartsets(<startsets>,<completions>,[<forbiddenset>][,<aim>],<Gdata>[,<lambda>]) generates start sets of length $n+1$ from those of length $n$.
#O  ExtendedStartsetsNoSort(<startsets>,<completions>,[<forbiddenset>][,<aim>],<Gdata>[,<lambda>]) generates start sets of length $n+1$ from those of length $n$.
##
##  For a set of partial (relative) difference sets <startsets>, the set of 
##  all extensions by one element from <completions> is returned.
##  Here an ``extension'' of a partial difference set $S$ is a list which has 
##  one element more than $S$ and contains $S$.
##
##  Here <completions> is a set of elements wich may be appended to the lists in 
##  <startsets> to generate new partial difference sets. For relative difference
##  sets, the forbidden set <forbiddenset> must be given. 
##  And the integer <aim> gives the desired total length, i.e. the number 
##  of elements of <completions> that have to be added to each startset 
##  plus its length. Note that the elements of <startset> are always extended
##  by *one* element (if they can be extended). <aim> does only tell how 
##  many elements from <completions> you want to add. A partial difference
##  set is only be extended, if there are enough admissible elements in 
##  <completions>, so if for some $S\in<startsets>$, we have less than 
##  $<aim>-`Size'(S)$ elements in <completions> which can be added to $S$,
##  no extension of $S$ is returned. 
##
##  If <lambda> is not passed as a parameter, it is assumed to be $1$.
##
##  Note that `ExtendedStartsets' does use "RemainingCompletions" while 
##  `ExtendedStartsetsNoSort' uses "RemainingCompletionsNoSort". 
##  Note that the partial difference sets generated with `ExtendedStartsetsNoSort'
##  are *not* sets (i.e. not sorted). This may result in doing work
##  twice. But it can also be useful, especially when generating difference sets 
## ``coset by coset''.
##
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsInt,IsRecord]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("ExtendedStartsetsNoSort",
        [IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsInt,IsRecord]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("ExtendedStartsets",
        [IsDenseList,IsDenseList,IsRecord,IsPosInt]);


#############################################################################
##
#E  END startsets.gd
##
