#############################################################################
##
#W plane_isomorphisms.gd 			 RDS Package		 Marc Roeder
##
##  Methods for calculations with projective planes
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
##O  DualPlane( <plane> )  generate dual plane
##
##  For a projective plane <plane>, `DualPlane( <blocks> )' returns
##  the dual plane. This plane is represented by a record as usual, but 
##  additionally contains  and a list <.image> of blocks such that 
##  <image[p]> is the image of the point <p> under duality.
##  It is not tested, if <plane> is actually a projective plane.
##
#DeclareOperation("DualPlane",[IsDenseList]);
#DeclareOperation("DualPlane",[IsRecord]);


#############################################################################
##
#O ProjectiveClosureOfPointSet(<points>[,<maxsize>],<plane>)
##
##  Let <plane> be a projective plane. Let <points> be a set of non-collinear
##  points (integers) of this plane. Then
##  `ProjectiveClosureOfPointSet' returns a record with the entries <.closure> 
##  and <.embedding>.
##
##  Here <.closure> is the projective closure of <points>  (the smallest 
##  projectively closed subset of <plane> containing the points <points>). 
##  It is not checked, whether this is a projective plane. As the BlockDesign
##  <.closure> has points `[1..w]' and <plane> has points `[1..v]' with 
##  $w\leq v$, we need an embedding of <.closure> into <plane>. This embedding
##  is the permutation <.embedding>. It is a permutation on `[1..v]' which
##  takes the points of <.closure> to a set of points in <plane> containing
##  <points> and preserving incidence. Note that nothing is known about the
##  behaviour of <.embedding> on any point outside `[1..w]' and 
##  `[1..w]^<.embedding>'.
##
##  If $<maxsize>$ is given and $<maxsize> \neq 0$, calculations are stopped
##  if the closure is known to
##  have at least <maxsize> points and the plane <plane> is returned as 
##  <.closure> with the trivial permutation as embedding.
##
##
DeclareOperation("ProjectiveClosureOfPointSet",[IsDenseList,IsInt,IsRecord]);
DeclareOperation("ProjectiveClosureOfPointSet",[IsDenseList,IsRecord]);


#############################################################################
##
#O  IsIsomorphismOfProjectivePlanes( <perm>,<plane1>,<plane2> )  test for isomorphism of projective planes
##
##  Let <plane1>, <plane2> be two projective planes.
##  `IsIsomorphismOfProjectivePlanes' test if the permutation
##  <perm> on points defines an isomorphism of the projective planes 
##   <plane1> and <plane2>.
##
DeclareOperation("IsIsomorphismOfProjectivePlanes",[IsPerm,IsRecord,IsRecord]);


#############################################################################
##
#O  IsCollineationOfProjectivePlane( <perm>,<plane> )  test if a permutation is a collineation of a projective plane
##
##  Let <plane> be a  projective plane and <perm> a permutation
##  on the points of this plane. `IsCollineationOfProjectivePlane(<perm>,<plane>)' returns 
##  `true', if <perm> induces a collineation of  <plane>.
## 
##  This is just another form to call `IsIsomorphismOfProjectivePlanes(<perm>,<plane>,<plane>)'
##
DeclareOperation("IsCollineationOfProjectivePlane",[IsPerm,IsRecord]);


#############################################################################
##
##F  ElationPrecalc( <blocks> )  generate data for calculating elations
##F  ElationPrecalcSmall( <blocks> )  generate data for calculating elations
##
##  Given the blocks <blocks> of a projective plane, 
##  `ElationPrecalc( <blocks> )' returns a record containing 
##  \beginlist
##   \item{.points} the points of the projective plane (immutable)
##   \item{.blocks} the blocks as passed to the function (immutable)
##   \item{.jpoint} a matrix with $ij$-th entry the point meeting the 
##      $i$-th and the $j$-th block.
##   \item{.jblock} a matrix with $ij$-th entry the position of the block 
##       connecting the point $i$ to the point $j$ in <blocks>.
##  \endlist
## 
##  `ElationPrecalcSmall( <blocks> )' returns a record which 
##  does only contain <.points>, <.blocks> and <.jblock>. Hence the name.
##
#DeclareGlobalFunction("ElationPrecalc");
#DeclareGlobalFunction("ElationPrecalcSmall");

#############################################################################
##
#O  ElationByPair( <centre>,<axis>,<pair>,<plane>)  calculate elations of projective planes.
##
##  Let <centre> be a point and  <axis> a block of a projective plane  
##  <plane> .
##  <pair>  must be a pair of points outside <axis> and lie on a block 
##  containing <center>. Then there is a unique collineation fixing <axis> 
##  pointwise  and <centre> blockwise (an elation) and taking  <point[1]> 
##  to <point[2]>. 
##
##  If one of the conditions is not met, an error is issued. 
##  This method is faster, if <plane.jpoint> is known (see 
##  "RDS:PointJoiningLinesProjectivePlane")
##
DeclareOperation("ElationByPair",[IsInt,IsVector,IsVector,IsRecord]);


#############################################################################
##
#O  AllElationsCentAx( <centre>,<axis>,<plane>[,"generators"])  calculate elations of projective planes.
##
##  Let <centre> be a point and  <axis> a block of the projective plane  
##  <plane>.
##  `AllElationsCentAx' returns the group of all elations with centre
##  <centre> and axis <axis> as a group of permutations on the points of 
##  <plane>.
##
##  If ``generators'' is set, only a list of generators of the translation
##  group is returned.
##  This method is faster, if <plane.jpoint> is known (see 
##  "RDS:PointJoiningLinesProjectivePlane")
##  
DeclareOperation("AllElationsCentAx",[IsInt,IsVector,IsRecord]);
DeclareOperation("AllElationsCentAx",[IsInt,IsVector,IsRecord,IsString]);


#############################################################################
##
#O  AllElationsAx(<axis>,<plane>[,"generators"])  calculate all elations with given axis.
##
##  Let <axis> be a block of a projective plane <plane>.
##  `AllElationsAx' returns the group of all elations with axis 
##  <axis>.
##  
##  If ``generators'' is set, only a set of generators for the group of elations
##  is returned.
##  This method is faster, if <plane.jpoint> is known (see 
##  "RDS:PointJoiningLinesProjectivePlane")
##
DeclareOperation("AllElationsAx",[IsDenseList,IsRecord]);
DeclareOperation("AllElationsAx",[IsDenseList,IsRecord,IsString]);


#############################################################################
##
#O IsTranslationPlane([<infline>,]<plane>)
##
##  Returns `true' if the plane <plane> has a block $b$ such that the
##  group of elations with axis $b$ is transitive outside $b$.
##
##  If <infline> is given, only the group of elations with axis 
##  <infline> is considered.
##  This is faster than 
##  calculating the full translation group if the projective plane <plane> 
##  is not a translation plane. If <plane> is a translation plane, the full
##  translation group is calculated.
##
##  This method is faster, if <plane.jpoint> is known (see 
##  "RDS:PointJoiningLinesProjectivePlane")
##
DeclareOperation("IsTranslationPlane",[IsDenseList,IsRecord]);
DeclareOperation("IsTranslationPlane",[IsRecord]);

#############################################################################
##
#O GroupOfHomologies(<centre>,<axis>,<plane>)
##
##  returns the group of homologies with centre <centre> and axis 
##  <axis> of the plane <plane>.
##
DeclareOperation("GroupOfHomologies",[IsInt,IsDenseList,IsRecord]);

#############################################################################
##
#O HomologyByPair(<centre>,<axis>,<pair>,<plane>)
##
##  `HomologyByPair' returns the homology defined by the pair
##  <pair> fixing <centre> blockwise and <axis> pointwise. 
##  The returned permutation fixes <axis> pointwise and <centre> linewise and
##  takes <pair[1]> to <pair[2]>.
##
DeclareOperation("HomologyByPair",[IsInt,IsDenseList,IsDenseList,IsRecord]);

#############################################################################
##
#O InducedCollineation(<baerplane>,<baercoll>,<point>,<image>,<planedata>,<embedding>)
##
##  If a projective plane contains a Baer subplane, collineations of the 
##  subplane may be lifted to the full plane. If such an extension to the 
##  full plane exists, it is uniquely determined by the image of one point 
##  outside the Baer plane.
##
##  Here <baercoll> is a collineation (a permutation of the points)
##  of the projective plane <baerplane>. 
##  The permutation <embedding> is a permutation on the points of the full pane
##  which converts the enumeration of <baerplane> to that of the full plane. 
##  This means that the image of the points of <baerplane> under <embedding> 
##  is a subset of the points of <plane>. Namely the one representing the Baer 
##  plane  in the enumeration used for the whole plane.
##  <point> and <image> are points outside the Baer plane.
##
##  The data for <baerplane> and <embedding> can be calculated using 
##  "ProjectiveClosureOfPointSet".
##
##  `InducedCollineation' returns a collineation of the full plane (as a  
##  permutation on the points of <plane>) which takes <point> to <image> and 
##  acts on the Baer plane as <baercoll> does. If no such collineation 
##  exists, `fail' is returned.
##
##  This method needs <plane.jpoint>. If it is unknown, it is calculated (see 
##  "RDS:PointJoiningLinesProjectivePlane")
##
DeclareOperation("InducedCollineation",[IsRecord,IsPerm,IsInt,IsInt,IsRecord,IsPerm]);

#############################################################################
##
#O  NrFanoPlanesAtPoints(<points>,<plane>)  invariant for projective planes
##
##  For a projective plane <plane>, `NrFanoPlanesAtPoints(<points>,<plane>)' 
##  calculates the so-called Fano invariant. That is, for each point 
##  in <points>, the number of subplanes of order 2 (so-called Fano planes)
##  containing this point is calculated.
##  The method returns a list of pairs of the form $[<point>,<number>]$
##  where <number> is the number of Fano sub-planes in <point>.
##
##  This method is faster, if <plane.jpoint> is known (see 
##  "RDS:PointJoiningLinesProjectivePlane"). Indeed, if <plane.jpoint> is 
##  not known, this method is very slow.
##
DeclareOperation("NrFanoPlanesAtPoints",[IsDenseList,IsRecord]);

#############################################################################
##
#O IncidenceMatrix(<plane>)
##
##  returns a matrix <I>, where the columns are numbered by the blocks and
##  the rows are numbered by points. And <I[i][j]=1> if and only if 
##  <points[i]> is incident (contained in) <blocks[j]> (an 0 else). 
##
DeclareOperation("IncidenceMatrix",[IsRecord]);

#############################################################################
##
#O RDS_PRank(<plane>,<p>)
##
##  Let $I$ be the incidence matrix of the projective plane <plane> and <p> a 
##  prime power.
##  The rank of $I.I^t$ as a matrix over
##  $GF(p)$ is called  <p>-rank of the projective plane. Here $I^t$ denotes
##  the transposed matrix.
##
DeclareOperation("RDS_PRank",[IsRecord,IsInt]);

#############################################################################
##
#O FingerprintAntiFlag(<point>,<linenr>,<plane>)
##
##  Let $m_1,\dots,m_{n+1}$ be the lines containing <point> and 
##  $E_1,\dots,E_{n+1}$ the points on the line given by <linenr> such that
##  $E_i$ is incident with $m_i$. Now label the points of $m_i$ as 
##  $<point>=P_{i,1},\dots,P_{i,n+1}=E_i$ and the lines of $E_i$ as
##  $<line>=l_1,\dots,l_{i,n+1}=m_i$. 
##  For $i\not = j$, each $P_{j,k}$ lies on exactly one line 
##  $l_{i,k\sigma_{i,j}}$ containing $E_i$ for some permutation $\sigma_{i,j}$
##
##  Define a matrix $A$, where $A_{i,j}$ is the sign of $\sigma_{i,j}$ if 
##  $i\neq j$ and $A_{i,i}=0$ for all $i$.
##  The partial fingerprint is the multiset of entries of $|AA^t|$ where $A^t$ 
##  denotes the transposed matrix of $A$.
##
##
DeclareOperation("FingerprintAntiFlag",[IsInt,IsInt,IsRecord]);

#############################################################################
##
#O FingerprintProjPlane(<plane>)
##
##  For each anti-flag $(p,l)$ of a projective plane <plane> of order $n$, 
##  define an arbitrary but fixed enumeration of the lines through $p$ and 
##  the points on $l$. Say $l_1,\dots,l_{n+1}$ and $p_1,\dots,p_{n+1}$
##  The incidence relation defines a canonical bijection between the $l_i$ and
##  the $p_i$ and hence a permutation on the indices $1,\dots,n+1$. 
##  Let $\sigma_{(p,l)}$ be this permutation.
##
##  Denote the points and lines of the plane by $q_1,\dots q_{n^2+n+1}$ 
##  and $e_1,\dots,e_{n^2+n+1}$. 
##  Define the sign matrix as $A_{ij}=sgn(\sigma_{(q_i,e_j)})$ if $(q_i,e_j)$ 
##  is an anti-flag and $=0$ if it is a flag.
##  Then the fingerprint is defined as the multiset of the entries of $|AA^t|$.
##
DeclareOperation("FingerprintProjPlane",[IsRecord]);


#############################################################################
##
#O IsomorphismProjPlanesByGenerators(<gens1>,<plane1>,<gens2>,<plane2>)
#O IsomorphismProjPlanesByGeneratorsNC(<gens1>,<plane1>,<gens2>,<plane2>)
##
##  Let <gens1> be a list of points generating the projective plane  
##  <plane1> and <gens2> a list of generating points for <plane2>. Then a 
##  permutation is returned representing a mapping from the points of <plane1> 
##  to those of <plane2> and taking the list <gens1> to the list <gens2>.
##  If there is no such mapping which defines an isomorphism of projective
##  planes, `fail' is returned.
##
##  `IsomorphismProjPlanesByGeneratorsNC' does *not* check whether <gens1> 
##  and <gens2> really generate the planes <plane1> and <plane2>. 
##
DeclareOperation("IsomorphismProjPlanesByGenerators",[IsDenseList,IsRecord,IsDenseList,IsRecord]);
DeclareOperation("IsomorphismProjPlanesByGeneratorsNC",[IsDenseList,IsRecord,IsDenseList,IsRecord]);

#############################################################################
##
#E  END
##
