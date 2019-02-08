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
## This calculates the development of a (partial relative) difference set
## <diffset> in the group given by <Gdata>. 
## That is, the associated block design. 
##
## <diffset> can be given as a list of group 
## elements or a list of integers (positions in the set of group elements).
## <Gdata> can either be the record returned by 
## "PermutationRepForDiffsetCalculations" or a group or a set of group elements.
##
## In either case, the returned object is a `BlockDesign' in the sense of 
## L. Soichers DESIGN package.
##
DeclareOperation("DevelopmentOfRDS",[IsDenseList,IsObject]);


#############################################################################
##
#O IsProjectivePlane(plane)  test, if block design is a projective plane
##
## Tests if the BlockDesign <plane> is  a projective plane. 
## This adds the entry <.isProjectivePlane> to the block design <plane>. 
## If <plane> is a projective plane, an entry called <.block> is generated
## as well. This is a matrix with $ij$th entry the number of the block 
## connecting the points $i$ and $j$.
##
DeclareOperation("IsProjectivePlane",[IsRecord]);

#############################################################################
##
#O PointJoiningLinesProjectivePlane(<plane>) generate additional data for projective planes
##
##  Returns a matrix which has as $ij$th entry the point wich is contained
##  in the blocks with numbers $i$ and $j$. This matrix is also stored in
##  <plane>. Some operations are faster if <plane> contains this matrix.
##  If <plane> is not a projective plane, an error is issued.
##
DeclareOperation("PointJoiningLinesProjectivePlane",[IsRecord]);


#############################################################################
##
#O  ProjectivePlane( <blocks> )  generate projective plane from blocks
##
##  Given a list of lists <blocks> which represents the blocks of a 
##  projective plane, a block design is generated. If the <blocks> is not 
##  a set of sets of the integers `[1..v]' for some $v$, the points are 
##  sorted and enumerated and the blocks are changed accordingly.
##  But the original names are known to the returned BlockDesign.
##
##  The block design generated this way will contain two extra entries,
##  <jblock> and <isProjectivePlane>. The matrix <.jblock> contains the 
##  number of the block containing the points $i$ and $j$ at the $(i,j)$th 
##  position. And <isProjectivePlane> will be `true'.
##  If <blocks> do not form the lines of a projective plane, an error is 
##  issued.
##
DeclareOperation("ProjectivePlane",[IsMatrix]);
        
#############################################################################
##
#E  END
##