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
##  <#GAPDoc Label="OneDiffset">
##  <ManSection>
##  <Oper Name="OneDiffset" Arg="[partial],group,[lambda]"/>
##  <Oper Name="OneDiffset" Label="for partial,[aim],forbidden,group,[lambda]" Arg="partial,[aim],forbidden,group,[lambda]"/>
##  <Oper Name="OneDiffset" Label="for [partial],Gdata,[lambda]" Arg="[partial],Gdata,[lambda]"/>
##  <Oper Name="OneDiffset" Label="for partial,[aim],forbidden,Gdata,[lambda]" Arg="partial,[aim],forbidden,Gdata,[lambda]"/>
##  <Oper Name="OneDiffset" Label="for partial,completions,aim,forbidden,Gdata,lambda" Arg="partial,completions,aim,forbidden,Gdata,lambda"/>
##  <Description>
##  This function works exactly like <Ref Func="AllDiffsets"/>, but stops once a
##  (partial) relative difference set is found.
##  This (partial) relative difference set is then returned. If no set
##  with the requested property exists, the empty list is returned.
##  <P/>
##  If <C>OneDiffset</C> is called using <A>Gdata</A> and lists of integers as
##  <A>partial</A> and <A>forbidden</A>, then the returned difference set is
##  the lexicographically smallest one starting with <A>partial</A>.
##  If the <A>group</A>-form is used and <A>partial</A> is not empty, <C>OneDiffset</C>
##  does only work, if the smallest element of <A>group</A> is the identity.
##  This is not the case for matrix groups in general.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="OneDiffsetNoSort">
##  <ManSection>
##  <Oper Name="OneDiffsetNoSort" Arg="partial,group"/>
##  <Oper Name="OneDiffsetNoSort" Label="for partial,Gdata" Arg="partial,Gdata"/>
##  <Oper Name="OneDiffsetNoSort" Label="for partial,[completions],aim,[forbidden],group,[lambda]" Arg="partial,[completions],aim,[forbidden],group,[lambda]"/>
##  <Oper Name="OneDiffsetNoSort" Label="for partial,[completions],aim,[forbidden],Gdata,[lambda]" Arg="partial,[completions],aim,[forbidden],Gdata,[lambda]"/>
##  <Description>
##  This works exactly as <Ref Func="AllDiffsetsNoSort"/> does, but stops once a set
##  with the desired properties is found and returns it.
##  If no difference set exists, the empty list is returned.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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