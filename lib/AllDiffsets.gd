#############################################################################
##
#W AllDiffsets.gd 			 RDS Package		 Marc Roeder
##
##  

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
#O AllDiffsets([<partial>],<group>,[<lambda>])
#O AllDiffsets(<partial>,[<aim>],<forbidden>,<group>,[<lambda>])
#O AllDiffsets([<partial>],<Gdata>,[<lambda>])
#O AllDiffsets(<partial>,[<aim>],<forbidden>,<Gdata>,[<lambda>])
#O AllDiffsets(<partial>,<completions>,<aim>,<forbidden>,<Gdata>,<lambda>)
##
##  <#GAPDoc Label="AllDiffsets">
##  <ManSection>
##  <Oper Name="AllDiffsets" Arg="[partial],group,[lambda]"/>
##  <Oper Name="AllDiffsets" Label="for partial,[aim],forbidden,group,[lambda]" Arg="partial,[aim],forbidden,group,[lambda]"/>
##  <Oper Name="AllDiffsets" Label="for [partial],Gdata,[lambda]" Arg="[partial],Gdata,[lambda]"/>
##  <Oper Name="AllDiffsets" Label="for partial,[aim],forbidden,Gdata,[lambda]" Arg="partial,[aim],forbidden,Gdata,[lambda]"/>
##  <Oper Name="AllDiffsets" Label="for partial,completions,aim,forbidden,Gdata,lambda" Arg="partial,completions,aim,forbidden,Gdata,lambda"/>
##  <Description>
##  Let <A>partial</A> be a list of elements of the group <A>group</A> which form a
##  partial relative difference set with parameter <A>lambda</A> and forbidden
##  set <A>forbidden</A> (which is also a set of group elements). That means that
##  the every non-trivial element in the list of quotients in elements of
##  <A>partial</A> occurs at most <A>lambda</A> times and no element of <A>forbidden</A>
##  is in this set.
##  Then <C>AllDiffsets</C> returns the list of all partial relative difference
##  sets of length <A>aim</A> with parameter <A>lambda</A> and forbidden set <A>forbidden</A>
##  which contain <A>partial</A>. Only those partial relative difference sets will
##  be constructed, which start with <A>partial</A> and continue with elements
##  larger than the last element in <A>partial</A>.
##  <P/>
##  To calculate <E>all</E> difference sets which contain <A>partial</A> as a subset,
##  you can use <Ref Func="AllDiffsetsNoSort"/>.
##  <P/>
##  Note that a difference set is also assumed to
##  contain the identity element, but this does not occur in the returned
##  lists. So a returned difference set contains <A>aim</A> elements but actually
##  represents a set of length <A>aim</A>+1, as it still is a partial relative
##  difference set when the identity element is added.
##  If <A>partial</A> is not given or the empty set, all difference set in the
##  group <A>group</A> are calculated. If <A>lambda</A> is not given, it is set to 1.
##  Without <A>forbidden</A>, ordinary difference sets are calculated.
##  If <A>aim</A> is not given, it is set to the size of a full relative
##  difference set with forbidden set <A>forbidden</A> and parameter <A>lambda</A>.
##  <P/>
##  Instead of using a group <A>group</A>, you can also use the data record
##  <A>Gdata</A> returned by <Ref Func="PermutationRepForDiffsetCalculations"/>.
##  In this case, <A>partial</A> and <A>forbidden</A> must be lists of integers.
##  In the last form, <A>completions</A> must be a list of integers and
##  <C>AllDiffsets</C> does only extend <A>partial</A> by elements from <A>completions</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AllDiffsets",
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("AllDiffsets",[IsGroup]);
DeclareOperation("AllDiffsets",[IsRecord]);
DeclareOperation("AllDiffsets",[IsGroup,IsPosInt]);
DeclareOperation("AllDiffsets",[IsRecord,IsPosInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsGroup]);
DeclareOperation("AllDiffsets",[IsDenseList,IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsPosInt,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsets",[IsDenseList,IsPosInt,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);


#############################################################################
##
#O AllDiffsetsNoSort(<partial>,<group>)
#O AllDiffsetsNoSort(<partial>,<Gdata>)
#O AllDiffsetsNoSort(<partial>,[<completions>],<aim>,[<forbidden>],<group>,[<lambda>])
#O AllDiffsetsNoSort(<partial>,[<completions>],<aim>,[<forbidden>],<Gdata>,[<lambda>])
##
##  <#GAPDoc Label="AllDiffsetsNoSort">
##  <ManSection>
##  <Oper Name="AllDiffsetsNoSort" Arg="partial,group"/>
##  <Oper Name="AllDiffsetsNoSort" Label="for partial,Gdata" Arg="partial,Gdata"/>
##  <Oper Name="AllDiffsetsNoSort" Label="for partial,[completions],aim,[forbidden],group,[lambda]" Arg="partial,[completions],aim,[forbidden],group,[lambda]"/>
##  <Oper Name="AllDiffsetsNoSort" Label="for partial,[completions],aim,[forbidden],Gdata,[lambda]" Arg="partial,[completions],aim,[forbidden],Gdata,[lambda]"/>
##  <Description>
##  This calculates all partial relative difference sets which contain the partial
##  relative difference set <A>partial</A>. The returned value is a set of lists.
##  Each of the returned lists starts with the list <A>partial</A>.
##  If <A>partial</A> is not a partial relative difference set, the empty list is
##  returned.
##  <P/>
##  Note that despite the name, <C>AllDiffsetsNoSort</C> does not calculate all
##  difference sets as unordered lists. It just calculates all difference
##  sets which contain <A>partial</A> as a subset.
##  <P/>
##  As it does not only append larger elements to <A>partial</A>, <C>AllDiffsetsNoSort</C>
##  works for all groups.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsRecord,IsPosInt]);

DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsRecord,IsPosInt]);

DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);

DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);



#############################################################################
##
#E
##
