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
##  Let <partial> be a list of elements of the group <group> which form a
##  partial relative difference set with parameter <lambda> and forbidden 
##  set <forbidden> (which is also a set of group elements). That means that 
##  the every non-trivial element in the list of quotients in elements of
##  <partial> occurs at most <lambda> times and no element of <forbidden>
##  is in this set.
##  Then `AllDiffsets' returns the list of all partial relative difference
##  sets of length <aim> with parameter <lambda> and forbidden set <forbidden>
##  which contain <partial>. Only those partial relative difference sets will
##  be constructed, which start with <partial> and continue with elements
##  larger than the last element in <partial>.
##
##  To calculate *all* difference sets which contain <partial> as a subset,
##  you can use "AllDiffsetsNoSort".
##
##  Note that a difference set is also assumed to 
##  contain the identity element, but this does not occur in the returned
##  lists. So a returned difference set contains <aim> elements but actually
##  represents a set of length <aim>+1, as it still is a partial relative 
##  difference set when the identity element is added.
##  If <partial> is not given or the empty set, all difference set in the 
##  group <group> are calculated. If <lambda> is not given, it is set to 1.
##  Without <forbidden>, ordinary difference sets are calculated.
##  If <aim> is not given, it is set to the size of a full relative 
##  difference set with forbidden set <forbidden> and parameter <lambda>.
##
##  Instead of using a group <group>, you can also use the data record 
##  <Gdata> returned by "PermutationRepForDiffsetCalculations".
##  In this case, <partial> and <forbidden> must be lists of integers.
##  In the last form, <completions> must be a list of integers and 
##  `AllDiffsets' does only extend <partial> by elements from <completions>.
##  
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
##  This calculates all partial relative difference sets which contain the partial
##  relative difference set <partial>. The returned value is a set of lists.
##  Each of the returned lists starts with the list <partial>.
##  If <partial> is not a partial relative difference set, the empty list is 
##  returned. 
##
##  Note that despite the name, `AllDiffsetsNoSort' does not calculate all
##  difference sets as unordered lists. It just calculates all difference 
##  sets which contain <partial> as a subset.
##
##  As it does not only append larger elements to <partial>, `AllDiffsetsNoSort'
##  works for all groups.
##
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
