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
##  <#GAPDoc Label="PermutationRepForDiffsetCalculations">
##  <ManSection>
##  <Oper Name="PermutationRepForDiffsetCalculations" Arg="group[, autgrp]"/>
##  <Description>
##  For a group <A>group</A>, <C>PermutationRepForDiffsetCalculations(<A>group</A>)</C>
##  returns a record containing:
##  <Enum>
##  <Item> the group &lt;.G&gt;=<A>group</A>.
##   </Item>
##  <Item> the sorted list &lt;.Glist&gt;=<C>Set(<A>group</A>)</C>,
##   </Item>
##  <Item> the automorphism group &lt;.A&gt; of <A>group</A>,
##   </Item>
##  <Item> the group &lt;.Aac&gt;, which is the permutation action of <A>A</A> on the indices of &lt;.Glist&gt;,
##   </Item>
##  <Item> &lt;.Ahom&gt;=<C>ActionHomomorphism(&lt;.A&gt;,&lt;.Glist&gt;)</C>,
##   </Item>
##  <Item> the group &lt;.Ai&gt; of anti-automorphisms of &lt;.group&gt; acting on the indices of <A>Glist</A>,
##   </Item>
##  <Item> the multiplication table &lt;.diffTable&gt; of &lt;.group&gt; in a special form.</Item>
##  </Enum>
##  &lt;.diffTable&gt; is a matrix of integers defined such that
##  <C>&lt;.difftable&gt;[i][j]</C> is the position of <C><A>Glist</A>[i](<A>Glist</A>[j])^-1)</C>
##  in <A>Glist</A> with <C><A>Glist</A>[1]=One(<A>group</A>)</C>.
##  <P/>
##  <C>PermutationRepForDiffsetCalculations</C> runs into an error if
##  <C>Set(<A>group</A>)[1]</C> is not equal to <C>One(<A>group</A>)</C>.
##  <P/>
##  If <A>autgrp</A> is given, <C>PermutationRepForDiffsetCalculations</C> will not calculate the
##  automorphism group of <A>group</A> but will take <A>autgrp</A> instead without any test.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PermutationRepForDiffsetCalculations",[IsGroup]);
DeclareOperation("PermutationRepForDiffsetCalculations",[IsGroup,IsGroup]);

#############################################################################
##
#O PermList2GroupList(<list>,<Gdata>) 
##
##  <#GAPDoc Label="PermList2GroupList">
##  <ManSection>
##  <Oper Name="PermList2GroupList" Arg="list,Gdata"/>
##  <Description>
##  converts a list of integers into group elements according to the
##  enumeration given in Gdata.Glist.
##  Here <A>Gdata</A> is a record containing .diffTable as returned by
##  <Ref Func="PermutationRepForDiffsetCalculations"/>.
##  <Example><![CDATA[
##  gap>  G:=DihedralGroup(6);
##  <pc group of size 6 with 2 generators>
##  gap> N:=NormalSubgroups(G)[2];
##  Group([ f2 ])
##  gap> dat:=PermutationRepForDiffsetCalculations(G);
##  rec( A := <group of size 6 with 2 generators>, 
##    Aac := Group([ (3,5)(4,6), (2,4,6) ]), Ahom := <action homomorphism>, 
##    Ai := Group([ (3,5), (3,5)(4,6), (2,4,6) ]), 
##    G := <pc group of size 6 with 2 generators>, 
##    Glist := [ <identity> of ..., f1, f2, f1*f2, f2^2, f1*f2^2 ], 
##    diffTable := [ [ 1, 2, 5, 4, 3, 6 ], [ 2, 1, 6, 3, 4, 5 ], 
##        [ 3, 6, 1, 2, 5, 4 ], [ 4, 5, 2, 1, 6, 3 ], [ 5, 4, 3, 6, 1, 2 ], 
##        [ 6, 3, 4, 5, 2, 1 ] ] )
##  gap> Nperm:=GroupList2PermList(Set(N),dat);
##  [ 1, 3, 5 ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PermList2GroupList",[IsDenseList,IsRecord]);


#############################################################################
##
#O GroupList2PermList(<list>,<Gdata>) 
##
##  <#GAPDoc Label="GroupList2PermList">
##  <ManSection>
##  <Oper Name="GroupList2PermList" Arg="list,Gdata"/>
##  <Description>
##  converts a list of group elements to integers according to the
##  enumeration given in Gdata.Glist.
##  Here <A>Gdata</A> is a record containing .diffTable as returned by
##  <Ref Func="PermutationRepForDiffsetCalculations"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("GroupList2PermList",[IsDenseList,IsRecord]);

#############################################################################
##
#O  NewPresentables( <list>,<newel>,<table> ) calculates quotients of a list and a given element.
#O  NewPresentables( <list>,<newel>,<Gdata> ) calculates quotients of a list and a given element.
#O  NewPresentables( <list>,<newlist>,<Gdata> ) calculates quotients of two lists
#O  NewPresentables( <list>,<newlist>,<table> ) calculates quotients of two lists
##
##  <#GAPDoc Label="NewPresentables">
##  <ManSection>
##  <Oper Name="NewPresentables" Arg="list,newel,table"/>
##  <Oper Name="NewPresentables" Label="for list,newel,Gdata" Arg="list,newel,Gdata"/>
##  <Oper Name="NewPresentables" Label="for list,newlist,Gdata" Arg="list,newlist,Gdata"/>
##  <Oper Name="NewPresentables" Label="for list,newlist,table" Arg="list,newlist,table"/>
##  <Description>
##  <C>NewPresentables( <A>list</A>,<A>newel</A>,<A>Gdata</A> )</C> takes a record <A>Gdata</A> as
##  returned by <C>PermutationRepForDiffsetCalculations(<A>group</A>)</C>.
##  For <C>NewPresentables( <A>list</A>,<A>newel</A>,<A>table</A> )</C>, <A>table</A> has to be the
##  multiplication table in the form of
##  <C>NewPresentables( <A>list</A>,<A>newel</A>,<A>Gdata.diffTable</A>)</C>
##  <P/>
##  The method returns the unordered list of quotients <M>d_1&lt;newel&gt;^{-1}</M> with
##  <M>d_1\in &lt;list&gt;\cup\{1\}</M> (in permutation representation).
##  <P/>
##  When used with a list <A>newlist</A>, a list of quotients <M>d_1d_2^{-1}</M> with
##  <M>d_1\in &lt;list&gt;\cup\{1\}</M> and <M>d_2\in &lt;newlist&gt;</M> is returned.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("NewPresentables",[IsDenseList,IsInt,IsMatrix]);
DeclareOperation("NewPresentables",[IsDenseList,IsInt,IsRecord]);
DeclareOperation("NewPresentables",[IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("NewPresentables",[IsDenseList,IsDenseList,IsRecord]);



#############################################################################
##
#O  AllPresentables( <list>,<table> ) calculates quotients of elements in <list>.
#O  AllPresentables( <list>,<Gdata> ) calculates quotients of elements in <list>.
##
##  <#GAPDoc Label="AllPresentables">
##  <ManSection>
##  <Oper Name="AllPresentables" Arg="list,table"/>
##  <Oper Name="AllPresentables" Label="for list,Gdata" Arg="list,Gdata"/>
##  <Description>
##  Let <A>list</A> be a list of integers representing elements of a group defined
##  by <A>Gdata</A> (or <A>table</A>).
##  <C>AllPresentables( <A>list</A>,<A>table</A>)</C> returns an unordered list of
##  quotients <M>ab^{-1}</M> for all group elements <M>a,b</M>  represented by integers
##  in <A>list</A>. If <M>1\in &lt;list&gt;</M>, an error is issued.
##  The multiplication table <A>table</A> has to be of the form as returned by
##  <Ref Func="PermutationRepForDiffsetCalculations"/>. And <A>Gdata</A> is a record as
##  calculated by <Ref Func="PermutationRepForDiffsetCalculations"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AllPresentables",[IsDenseList,IsMatrix]);
DeclareOperation("AllPresentables",[IsDenseList,IsRecord]);

#############################################################################
##
#O  RemainingCompletions( <diffset>,<completions>[,<forbidden>],<Gdata>[,<lambda>] ) calculates all elements of <completions> which may be added to the partial difference set <diffset>.
#O  RemainingCompletionsNoSort( <diffset>,<completions>[,<forbidden>],<table>[,<lambda>] ) calculates all elements of <completions> which may be added to the partial difference set <diffset>.
##
##  <#GAPDoc Label="RemainingCompletions">
##  <ManSection>
##  <Oper Name="RemainingCompletions" Arg="diffset,completions[,forbidden],Gdata[,lambda]"/>
##  <Oper Name="RemainingCompletionsNoSort" Arg="diffset,completions[,forbidden],table[,lambda]"/>
##  <Description>
##  For a partial difference set <A>diffset</A>,
##  <C>RemainingCompletions(<A>diffset</A>,<A>completions</A>,<A>Gdata</A>)</C> returns a
##  subset of the <E>set</E> <A>completions</A>, such that each of its elements may be
##  added to <A>diffset</A> without it loosing the property to be a partial
##  difference set.
##  Only elements greater than the last element of <A>diffset</A> are returned.
##  <P/>
##  For partial <E>relative</E> difference sets, <A>forbidden</A> is the forbidden set.
##  <P/>
##  <C>RemainingCompletionsNoSort</C> does also return elements from <A>completions</A> which
##  are smaller than <C><A>diffset</A>[Size(<A>diffset</A>)]</C>.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(7);
##  <pc group of size 7 with 1 generator>
##  gap> dat:=PermutationRepForDiffsetCalculations(G);;
##  gap> RemainingCompletionsNoSort([4],[1..7],dat);
##  [ 2, 3 ]
##  gap> RemainingCompletionsNoSort([4],[1..7],dat,2);
##  [ 2, 3, 5, 6, 7 ]
##  gap> RemainingCompletions([4],[1..7],dat);        
##  [  ]
##  gap> RemainingCompletions([4],[1..7],dat,2);
##  [ 5, 6, 7 ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="ExtendedStartsets">
##  <ManSection>
##  <Oper Name="ExtendedStartsets" Arg="startsets,completions,[forbiddenset][,aim],Gdata[,lambda]"/>
##  <Oper Name="ExtendedStartsetsNoSort" Arg="startsets,completions,[forbiddenset][,aim],Gdata[,lambda]"/>
##  <Description>
##  For a set of partial (relative) difference sets <A>startsets</A>, the set of
##   all extensions by one element from <A>completions</A> is returned.
##   Here an <Q>extension</Q> of a partial difference set <M>S</M> is a list which has
##   one element more than <M>S</M> and contains <M>S</M>.
##  <P/>
##  Here <A>completions</A> is a set of elements wich may be appended to the lists in
##   <A>startsets</A> to generate new partial difference sets. For relative difference
##   sets, the forbidden set <A>forbiddenset</A> must be given.
##   And the integer <A>aim</A> gives the desired total length, i.e. the number
##   of elements of <A>completions</A> that have to be added to each startset
##   plus its length. Note that the elements of <A>startset</A> are always extended
##   by <E>one</E> element (if they can be extended). <A>aim</A> does only tell how
##   many elements from <A>completions</A> you want to add. A partial difference
##   set is only be extended, if there are enough admissible elements in
##   <A>completions</A>, so if for some <M>S\in&lt;startsets&gt;</M>, we have less than
##   <M>&lt;aim&gt;-`Size'(S)</M> elements in <A>completions</A> which can be added to <M>S</M>,
##   no extension of <M>S</M> is returned.
##  <P/>
##  If <A>lambda</A> is not passed as a parameter, it is assumed to be <M>1</M>.
##  <P/>
##  Note that <C>ExtendedStartsets</C> does use <Ref Func="RemainingCompletions"/> while
##   <C>ExtendedStartsetsNoSort</C> uses <Ref Func="RemainingCompletionsNoSort"/>.
##   Note that the partial difference sets generated with <C>ExtendedStartsetsNoSort</C>
##   are <E>not</E> sets (i.e. not sorted). This may result in doing work
##   twice. But it can also be useful, especially when generating difference sets
##  <Q>coset by coset</Q>.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(7);;dat:=PermutationRepForDiffsetCalculations(G);;
##  gap> startsets:=[[2],[4],[6]];;
##  gap> ExtendedStartsets(startsets,[1..7],dat);
##  [ [ 2, 4 ], [ 2, 6 ] ]
##  gap> ExtendedStartsets(startsets,[1..7],3,dat);
##  [ [ 2, 4 ] ]
##  gap> ExtendedStartsets(startsets,[1..7],dat,2);
##  [ [ 2, 3 ], [ 2, 4 ], [ 2, 5 ], [ 2, 6 ], [ 2, 7 ], [ 4, 5 ], [ 4, 6 ], 
##    [ 4, 7 ], [ 6, 7 ] ]
##  gap> ExtendedStartsetsNoSort(startsets,[1..7],dat);
##  [ [ 2, 4 ], [ 2, 6 ], [ 4, 2 ], [ 4, 3 ], [ 6, 2 ], [ 6, 5 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
