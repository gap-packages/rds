#############################################################################
##
#W force.gd 			 RDS Package		 Marc Roeder
##
##  Brute force methods for finding relative difference sets
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
#O AllDiffsets(<partial>,<completions>,<aim>,<forbidden>,<Gdata>,<lambda>)
##
##  Let <partial> be partial relative difference set and <completions> a list
##  of possible completions and <forbidden> the forbidden set. Then
##  `AllDiffsets' returns a list of (partial) difference sets which contain
##  <partial>. <Gdata> is the record as always and <lambda> is the parameter
##  of the relative difference set. <forbidden> and <completions> have to be
##  lists of integers.
##
DeclareOperation("AllDiffsets",
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsRecord,IsPosInt]);

#############################################################################
##
#O AllDiffsets(<partial>,<aim>,<forbidden>,<Group>,<lambda>)
##
##  Let <partial> be a set of elements of the group <Group> which form a
##  partial relative difference set with parameter <lambda> and forbidden 
##  set <forbidden> (which is also a set of group elements). That means that 
##  the every non-trivial element in the list of quotients in elements of
##  <partial> occurs at most <lambda> times and no element of <forbidden>
##  is in this set.
##  Then `AllDiffsets' returns the list of all (partial) relative difference
##  sets of length <aim> with parameter <lambda> and forbidden set <forbidden>
##  which contain <partial>. Note that a difference set is also assumed to 
##  contain the identity element, but this does not occur in the returned
##  lists. So a returned difference set contains <aim> elements but actually
##  represents a set of length <aim>+1, as it still is a partial relative 
##  difference set when the identity element is added.
##  

#############################################################################
##
#O AllDiffsets(<group>)
#O AllDiffsets(<Gdata>)
#O AllDiffsets(<start>,[<forbidden>],<group>,[<lambda>])
#O AllDiffsets(<start>,[<forbidden>],<Gdata>,[<lambda>])
#O AllDiffsets(<start>, <aim>, <forbidden>, <group>, <lambda>)
#O AllDiffsets(<start>, <aim>, <forbidden>, <Gdata>, <lambda>)
##

DeclareOperation("AllDiffsets",[IsGroup]);
DeclareOperation("AllDiffsets",[IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsGroup]);
DeclareOperation("AllDiffsets",[IsDenseList,IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsGroup,IsInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsRecord,IsInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsGroup,IsInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsDenseList,IsRecord,IsInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsInt,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsets",[IsDenseList,IsInt,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsets",[IsDenseList,IsInt,IsDenseList,IsGroup,IsInt]);
DeclareOperation("AllDiffsets",[IsDenseList,IsInt,IsDenseList,IsRecord,IsInt]);


#############################################################################
##
#O AllDiffsetsNoSort(<start>,[<completions>],<aim>,[<forbidden>],<group>,[<lambda>])
#O AllDiffsetsNoSort(<start>,[<completions>],<aim>,[<forbidden>],<Gdata>,[<lambda>])
##
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsGroup,IsInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsRecord,IsInt]);

DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsInt,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsInt,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsInt,IsGroup,IsInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsDenseList,IsInt,IsRecord,IsInt]);

DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsDenseList,IsGroup]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsDenseList,IsRecord]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsDenseList,IsGroup,IsInt]);
DeclareOperation("AllDiffsetsNoSort",[IsDenseList,IsInt,IsDenseList,IsRecord,IsInt]);


#############################################################################
##
#E  END
##