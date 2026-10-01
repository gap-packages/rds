#############################################################################
##
#W designs.gd 			 RDS Package		 Marc Roeder
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
############################################################################
##
#O  DevelopmentOfRDS(<diffset>,<Gdata>);
##
##  <#GAPDoc Label="DevelopmentOfRDS">
##  <ManSection>
##  <Oper Name="DevelopmentOfRDS" Arg="diffset,Gdata"/>
##  <Description>
##  This calculates the development of a (partial relative) difference set
##  <A>diffset</A> in the group given by <A>Gdata</A>.
##  That is, the associated block design.
##  <P/>
##  <A>diffset</A> can be given as a list of group
##  elements or a list of integers (positions in the set of group elements).
##  <A>Gdata</A> can either be the record returned by
##  <Ref Func="PermutationRepForDiffsetCalculations"/> or a group or a set of group elements.
##  <P/>
##  In either case, the returned object is a <C>BlockDesign</C> in the sense of
##  L. Soichers DESIGN package.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(21);;  Gdata:=PermutationRepForDiffsetCalculations(G);; 
##  gap> AllDiffsets([2],[1..21],4,[],Gdata,1);                                  
##  [ [ 2, 5, 16, 17 ], [ 2, 6, 10, 18 ] ]
##  gap> d1:=DevelopmentOfRDS(Set(G){[2,5,16,17]},Set(G)); 
##  rec( autSubgroup := <permutation group with 21 generators>, 
##    blockNumbers := [ 21 ], blockSizes := [ 5 ], 
##    blocks := [ [ 1, 2, 5, 16, 17 ], [ 1, 3, 14, 15, 21 ], [ 1, 4, 8, 10, 13 ], 
##        [ 1, 6, 7, 9, 20 ], [ 1, 11, 12, 18, 19 ], [ 2, 3, 9, 10, 12 ], 
##        [ 2, 4, 7, 15, 19 ], [ 2, 6, 8, 11, 21 ], [ 2, 13, 14, 18, 20 ], 
##        [ 3, 4, 6, 17, 18 ], [ 3, 5, 8, 19, 20 ], [ 3, 7, 11, 13, 16 ], 
##        [ 4, 5, 9, 11, 14 ], [ 4, 12, 16, 20, 21 ], [ 5, 6, 12, 13, 15 ], 
##        [ 5, 7, 10, 18, 21 ], [ 6, 10, 14, 16, 19 ], [ 7, 8, 12, 14, 17 ], 
##        [ 8, 9, 15, 16, 18 ], [ 9, 13, 17, 19, 21 ], [ 10, 11, 15, 17, 20 ] ], 
##    isBinary := true, isBlockDesign := true, isSimple := true, 
##    pointNames := [ <identity> of ..., f1, f2, f1^2, f1*f2, f2^2, f1^2*f2, 
##        f1*f2^2, f2^3, f1^2*f2^2, f1*f2^3, f2^4, f1^2*f2^3, f1*f2^4, f2^5, 
##        f1^2*f2^4, f1*f2^5, f2^6, f1^2*f2^5, f1*f2^6, f1^2*f2^6 ], v := 21 )
##  gap> d2:=DevelopmentOfRDS([2,5,16,17],Gdata);;
##  gap> d1=d2;
##  true
##  gap> d1=DevelopmentOfRDS(Set(G){[2,5,16,17]},G);  
##  true
##  gap> d1=DevelopmentOfRDS([2,5,16,17],G);        
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("DevelopmentOfRDS",[IsDenseList,IsObject]);


#############################################################################
##
#O IsProjectivePlane(plane)  test, if block design is a projective plane
##
##  <#GAPDoc Label="IsProjectivePlane">
##  <ManSection>
##  <Oper Name="IsProjectivePlane" Arg="plane"/>
##  <Description>
##  Tests if the BlockDesign <A>plane</A> is  a projective plane.
##  This adds the entry &lt;.isProjectivePlane&gt; to the block design <A>plane</A>.
##  If <A>plane</A> is a projective plane, an entry called &lt;.block&gt; is generated
##  as well. This is a matrix with <M>ij</M>th entry the number of the block
##  connecting the points <M>i</M> and <M>j</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IsProjectivePlane",[IsRecord]);

#############################################################################
##
#O PointJoiningLinesProjectivePlane(<plane>) generate additional data for projective planes
##
##  <#GAPDoc Label="PointJoiningLinesProjectivePlane">
##  <ManSection>
##  <Oper Name="PointJoiningLinesProjectivePlane" Arg="plane"/>
##  <Description>
##  Returns a matrix which has as <M>ij</M>th entry the point which is contained
##  in the blocks with numbers <M>i</M> and <M>j</M>. This matrix is also stored in
##  <A>plane</A>. Some operations are faster if <A>plane</A> contains this matrix.
##  If <A>plane</A> is not a projective plane, an error is issued.
##  <Example><![CDATA[
##  gap> b:=[ [ 1, 3 ], [ 1, 6 ], [ 2, 4 ], [ 2, 7 ], 
##  >       [ 3, 5 ], [ 4, 6 ], [ 5, 7 ] ];;
##  gap> plane:=ProjectivePlane(b);
##  rec( blockNumbers := [ 2 ], blockSizes := [ 2 ], 
##    blocks := [ [ 1, 3 ], [ 1, 6 ], [ 2, 4 ], [ 2, 7 ], [ 3, 5 ], [ 4, 6 ], 
##        [ 5, 7 ] ], isBinary := true, isBlockDesign := true, 
##    isConnected := true, isProjectivePlane := true, isSimple := true, 
##    jblock := [ [ 0, 0, 1, 0, 0, 2, 0 ], [ 0, 0, 0, 3, 0, 0, 4 ], 
##        [ 1, 0, 0, 0, 5, 0, 0 ], [ 0, 3, 0, 0, 0, 6, 0 ], 
##        [ 0, 0, 5, 0, 0, 0, 7 ], [ 2, 0, 0, 6, 0, 0, 0 ], 
##        [ 0, 4, 0, 0, 7, 0, 0 ] ], 
##    tSubsetStructure := rec( lambdas := [ 1 ], t := 2 ), v := 7 )
##  gap> PointJoiningLinesProjectivePlane(plane);
##  [ [ 0, 1, 0, 0, 3, 0, 0 ], [ 1, 0, 0, 0, 0, 6, 0 ], [ 0, 0, 0, 2, 0, 4, 0 ], 
##    [ 0, 0, 2, 0, 0, 0, 7 ], [ 3, 0, 0, 0, 0, 0, 5 ], [ 0, 6, 4, 0, 0, 0, 0 ], 
##    [ 0, 0, 0, 7, 5, 0, 0 ] ]
##  gap> RecNames(plane);
##  [ "blocks", "isSimple", "isBlockDesign", "v", "isBinary", "blockSizes", 
##    "blockNumbers", "tSubsetStructure", "isConnected", "isProjectivePlane", 
##    "jblock", "jpoint" ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("PointJoiningLinesProjectivePlane",[IsRecord]);


#############################################################################
##
#O  ProjectivePlane( <blocks> )  generate projective plane from blocks
##
##  <#GAPDoc Label="ProjectivePlane">
##  <ManSection>
##  <Oper Name="ProjectivePlane" Arg="blocks"/>
##  <Description>
##  Given a list of lists <A>blocks</A> which represents the blocks of a
##  projective plane, a block design is generated. If the <A>blocks</A> is not
##  a set of sets of the integers <C>[1..v]</C> for some <M>v</M>, the points are
##  sorted and enumerated and the blocks are changed accordingly.
##  But the original names are known to the returned BlockDesign.
##  <P/>
##  The block design generated this way will contain two extra entries,
##  <A>jblock</A> and <A>isProjectivePlane</A>. The matrix &lt;.jblock&gt; contains the
##  number of the block containing the points <M>i</M> and <M>j</M> at the <M>(i,j)</M>th
##  position. And <A>isProjectivePlane</A> will be <K>true</K>.
##  If <A>blocks</A> do not form the lines of a projective plane, an error is
##  issued.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("ProjectivePlane",[IsMatrix]);
        
#############################################################################
##
#E  END
##