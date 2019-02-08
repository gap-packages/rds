#############################################################################
##
#W OneDiffset.gd 			 RDS Package		 Marc Roeder
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
#O OneDiffset([<partial>],<group>,[<lambda>])
#O OneDiffset(<partial>,[<aim>],<forbidden>,<group>,[<lambda>])
#O OneDiffset([<partial>],<Gdata>,[<lambda>])
#O OneDiffset(<partial>,[<aim>],<forbidden>,<Gdata>,[<lambda>])
#O OneDiffset(<partial>,<completions>,<aim>,<forbidden>,<Gdata>,<lambda>)
##
##  This function works exactly like "AllDiffsets", but stops once a 
##  (partial) relative difference set is found.
##  This (partial) relative difference set is then returned. If no set 
##  with the requested property exists, the empty list is returned.
##
##  If `OneDiffset' is called using <Gdata> and lists of integers as
##  <partial> and <forbidden>, then the returned difference set is 
##  the lexicographically smallest one starting with <partial>.
##  If the <group>-form is used and <partial> is not empty, `OneDiffset'
##  does only work, if the smallest element of <group> is the identity.
##  This is not the case for matrix groups in general.
##
DeclareOperation("OneDiffset",
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("OneDiffset",[IsGroup]);
DeclareOperation("OneDiffset",[IsRecord]);
DeclareOperation("OneDiffset",[IsGroup,IsPosInt]);
DeclareOperation("OneDiffset",[IsRecord,IsPosInt]);
DeclareOperation("OneDiffset",[IsDenseList,IsGroup]);
DeclareOperation("OneDiffset",[IsDenseList,IsRecord]);
DeclareOperation("OneDiffset",[IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("OneDiffset",[IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("OneDiffset",[IsDenseList,IsDenseList,IsGroup]);
DeclareOperation("OneDiffset",[IsDenseList,IsDenseList,IsRecord]);
DeclareOperation("OneDiffset",[IsDenseList,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("OneDiffset",[IsDenseList,IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("OneDiffset",[IsDenseList,IsPosInt,IsDenseList,IsGroup]);
DeclareOperation("OneDiffset",[IsDenseList,IsPosInt,IsDenseList,IsRecord]);
DeclareOperation("OneDiffset",[IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("OneDiffset",[IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);




#############################################################################
##
#O OneDiffsetNoSort(<partial>,<group>)
#O OneDiffsetNoSort(<partial>,<Gdata>)
#O OneDiffsetNoSort(<partial>,[<completions>],<aim>,[<forbidden>],<group>,[<lambda>])
#O OneDiffsetNoSort(<partial>,[<completions>],<aim>,[<forbidden>],<Gdata>,[<lambda>])
##  
##  This works exactly as "AllDiffsetsNoSort" does, but stops once a set 
##  with the desired properties is found and returns it.
##  If no difference set exists, the empty list is returned.
##
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsGroup]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsRecord]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsRecord,IsPosInt]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsGroup]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsRecord]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsGroup,IsPosInt]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsRecord,IsPosInt]);

DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsGroup]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsRecord]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsGroup,IsPosInt]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsRecord,IsPosInt]);

DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsDenseList,IsGroup]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsDenseList,IsRecord]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);

DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt]);
DeclareOperation("OneDiffsetNoSort",[IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt]);


#############################################################################
##
#E  END
##