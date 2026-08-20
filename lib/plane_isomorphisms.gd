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
##  <#GAPDoc Label="ProjectiveClosureOfPointSet">
##  <ManSection>
##  <Oper Name="ProjectiveClosureOfPointSet" Arg="points[,maxsize],plane"/>
##  <Description>
##  Let <A>plane</A> be a projective plane. Let <A>points</A> be a set of non-collinear
##  points (integers) of this plane. Then
##  <C>ProjectiveClosureOfPointSet</C> returns a record with the entries &lt;.closure&gt;
##  and &lt;.embedding&gt;.
##  <P/>
##  Here &lt;.closure&gt; is the projective closure of <A>points</A>  (the smallest
##  projectively closed subset of <A>plane</A> containing the points <A>points</A>).
##  It is not checked, whether this is a projective plane. As the BlockDesign
##  &lt;.closure&gt; has points <C>[1..w]</C> and <A>plane</A> has points <C>[1..v]</C> with
##  <M>w\leq v</M>, we need an embedding of &lt;.closure&gt; into <A>plane</A>. This embedding
##  is the permutation &lt;.embedding&gt;. It is a permutation on <C>[1..v]</C> which
##  takes the points of &lt;.closure&gt; to a set of points in <A>plane</A> containing
##  <A>points</A> and preserving incidence. Note that nothing is known about the
##  behaviour of &lt;.embedding&gt; on any point outside <C>[1..w]</C> and
##  <C>[1..w]^&lt;.embedding&gt;</C>.
##  <P/>
##  If <M>&lt;maxsize&gt;</M> is given and <M>&lt;maxsize&gt; \neq 0</M>, calculations are stopped
##  if the closure is known to
##  have at least <A>maxsize</A> points and the plane <A>plane</A> is returned as
##  &lt;.closure&gt; with the trivial permutation as embedding.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("ProjectiveClosureOfPointSet",[IsDenseList,IsInt,IsRecord]);
DeclareOperation("ProjectiveClosureOfPointSet",[IsDenseList,IsRecord]);


#############################################################################
##
#O  IsIsomorphismOfProjectivePlanes( <perm>,<plane1>,<plane2> )  test for isomorphism of projective planes
##
##  <#GAPDoc Label="IsIsomorphismOfProjectivePlanes">
##  <ManSection>
##  <Oper Name="IsIsomorphismOfProjectivePlanes" Arg="perm,plane1,plane2"/>
##  <Description>
##  Let <A>plane1</A>, <A>plane2</A> be two projective planes.
##  <C>IsIsomorphismOfProjectivePlanes</C> test if the permutation
##  <A>perm</A> on points defines an isomorphism of the projective planes
##   <A>plane1</A> and <A>plane2</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IsIsomorphismOfProjectivePlanes",[IsPerm,IsRecord,IsRecord]);


#############################################################################
##
#O  IsCollineationOfProjectivePlane( <perm>,<plane> )  test if a permutation is a collineation of a projective plane
##
##  <#GAPDoc Label="IsCollineationOfProjectivePlane">
##  <ManSection>
##  <Oper Name="IsCollineationOfProjectivePlane" Arg="perm,plane"/>
##  <Description>
##  Let <A>plane</A> be a  projective plane and <A>perm</A> a permutation
##  on the points of this plane. <C>IsCollineationOfProjectivePlane(<A>perm</A>,<A>plane</A>)</C> returns
##  <K>true</K>, if <A>perm</A> induces a collineation of  <A>plane</A>.
##  <P/>
##  This is just another form to call <C>IsIsomorphismOfProjectivePlanes(<A>perm</A>,<A>plane</A>,<A>plane</A>)</C>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
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
##  <#GAPDoc Label="ElationByPair">
##  <ManSection>
##  <Oper Name="ElationByPair" Arg="centre,axis,pair,plane"/>
##  <Description>
##  Let <A>centre</A> be a point and  <A>axis</A> a block of a projective plane
##  <A>plane</A> .
##  <A>pair</A>  must be a pair of points outside <A>axis</A> and lie on a block
##  containing <A>center</A>. Then there is a unique collineation fixing <A>axis</A>
##  pointwise  and <A>centre</A> blockwise (an elation) and taking  &lt;point[1]&gt;
##  to &lt;point[2]&gt;.
##  <P/>
##  If one of the conditions is not met, an error is issued.
##  This method is faster, if <A>plane.jpoint</A> is known (see
##  <Ref Func="PointJoiningLinesProjectivePlane"/>)
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("ElationByPair",[IsInt,IsVector,IsVector,IsRecord]);


#############################################################################
##
#O  AllElationsCentAx( <centre>,<axis>,<plane>[,"generators"])  calculate elations of projective planes.
##
##  <#GAPDoc Label="AllElationsCentAx">
##  <ManSection>
##  <Oper Name="AllElationsCentAx" Arg="centre,axis,plane[,&quot;generators&quot;]"/>
##  <Description>
##  Let <A>centre</A> be a point and  <A>axis</A> a block of the projective plane
##  <A>plane</A>.
##  <C>AllElationsCentAx</C> returns the group of all elations with centre
##  <A>centre</A> and axis <A>axis</A> as a group of permutations on the points of
##  <A>plane</A>.
##  <P/>
##  If <Q>generators</Q> is set, only a list of generators of the translation
##  group is returned.
##  This method is faster, if <A>plane.jpoint</A> is known (see
##  <Ref Func="PointJoiningLinesProjectivePlane"/>)
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AllElationsCentAx",[IsInt,IsVector,IsRecord]);
DeclareOperation("AllElationsCentAx",[IsInt,IsVector,IsRecord,IsString]);


#############################################################################
##
#O  AllElationsAx(<axis>,<plane>[,"generators"])  calculate all elations with given axis.
##
##  <#GAPDoc Label="AllElationsAx">
##  <ManSection>
##  <Oper Name="AllElationsAx" Arg="axis,plane[,&quot;generators&quot;]"/>
##  <Description>
##  Let <A>axis</A> be a block of a projective plane <A>plane</A>.
##  <C>AllElationsAx</C> returns the group of all elations with axis
##  <A>axis</A>.
##  <P/>
##  If <Q>generators</Q> is set, only a set of generators for the group of elations
##  is returned.
##  This method is faster, if <A>plane.jpoint</A> is known (see
##  <Ref Func="PointJoiningLinesProjectivePlane"/>)
##  <Example><![CDATA[
##  gap> P:=ProjectivePlane( [ [ 1, 2, 6 ], [ 1, 3, 5 ], [ 1, 4, 7 ], 
##  >       [ 2, 3, 7 ], [ 2, 4, 5 ], [ 3, 4, 6 ], [ 5, 6, 7 ] ]);;
##  gap> pi:=ElationByPair(1,[1,2,6],[3,5],P);
##  (3,5)(4,7)
##  gap> AllElationsCentAx(1,[1,2,6],P);
##  Group([ (3,5)(4,7) ])
##  gap> AllElationsAx([1,2,6],P); 
##  Group([ (3,5)(4,7), (3,7)(4,5) ])
##  gap> AllElationsAx([1,2,6],P);
##  Group([ (3,5)(4,7), (3,7)(4,5) ])
##  gap> Size(last);
##  4
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("AllElationsAx",[IsDenseList,IsRecord]);
DeclareOperation("AllElationsAx",[IsDenseList,IsRecord,IsString]);


#############################################################################
##
#O IsTranslationPlane([<infline>,]<plane>)
##
##  <#GAPDoc Label="IsTranslationPlane">
##  <ManSection>
##  <Oper Name="IsTranslationPlane" Arg="[infline,]plane"/>
##  <Description>
##  Returns <K>true</K> if the plane <A>plane</A> has a block <M>b</M> such that the
##  group of elations with axis <M>b</M> is transitive outside <M>b</M>.
##  <P/>
##  If <A>infline</A> is given, only the group of elations with axis
##  <A>infline</A> is considered.
##  This is faster than
##  calculating the full translation group if the projective plane <A>plane</A>
##  is not a translation plane. If <A>plane</A> is a translation plane, the full
##  translation group is calculated.
##  <P/>
##  This method is faster, if <A>plane.jpoint</A> is known (see
##  <Ref Func="PointJoiningLinesProjectivePlane"/>)
##  <Example><![CDATA[
##  gap> AllElationsAx(P.blocks[1],P);
##  Group([ (3,5)(4,7), (3,7)(4,5) ])
##  gap> Size(last);
##  4
##  gap> IsTranslationPlane(P);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IsTranslationPlane",[IsDenseList,IsRecord]);
DeclareOperation("IsTranslationPlane",[IsRecord]);

#############################################################################
##
#O GroupOfHomologies(<centre>,<axis>,<plane>)
##
##  <#GAPDoc Label="GroupOfHomologies">
##  <ManSection>
##  <Oper Name="GroupOfHomologies" Arg="centre,axis,plane"/>
##  <Description>
##  returns the group of homologies with centre <A>centre</A> and axis
##  <A>axis</A> of the plane <A>plane</A>.
##  <Log><![CDATA[
##  gap> HomologyByPair(3,[1,2,6],[4,5],P);
##  Error, The centre must be fixed blockwise called from
##   # ...
##  gap> GroupOfHomologies(3,[1,2,6],P);   
##  Group(())
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("GroupOfHomologies",[IsInt,IsDenseList,IsRecord]);

#############################################################################
##
#O HomologyByPair(<centre>,<axis>,<pair>,<plane>)
##
##  <#GAPDoc Label="HomologyByPair">
##  <ManSection>
##  <Oper Name="HomologyByPair" Arg="centre,axis,pair,plane"/>
##  <Description>
##  <C>HomologyByPair</C> returns the homology defined by the pair
##  <A>pair</A> fixing <A>centre</A> blockwise and <A>axis</A> pointwise.
##  The returned permutation fixes <A>axis</A> pointwise and <A>centre</A> linewise and
##  takes &lt;pair[1]&gt; to &lt;pair[2]&gt;.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("HomologyByPair",[IsInt,IsDenseList,IsDenseList,IsRecord]);

#############################################################################
##
#O InducedCollineation(<baerplane>,<baercoll>,<point>,<image>,<planedata>,<embedding>)
##
##  <#GAPDoc Label="InducedCollineation">
##  <ManSection>
##  <Oper Name="InducedCollineation" Arg="baerplane,baercoll,point,image,planedata,embedding"/>
##  <Description>
##  If a projective plane contains a Baer subplane, collineations of the
##  subplane may be lifted to the full plane. If such an extension to the
##  full plane exists, it is uniquely determined by the image of one point
##  outside the Baer plane.
##  <P/>
##  Here <A>baercoll</A> is a collineation (a permutation of the points)
##  of the projective plane <A>baerplane</A>.
##  The permutation <A>embedding</A> is a permutation on the points of the full pane
##  which converts the enumeration of <A>baerplane</A> to that of the full plane.
##  This means that the image of the points of <A>baerplane</A> under <A>embedding</A>
##  is a subset of the points of <A>plane</A>. Namely the one representing the Baer
##  plane  in the enumeration used for the whole plane.
##  <A>point</A> and <A>image</A> are points outside the Baer plane.
##  <P/>
##  The data for <A>baerplane</A> and <A>embedding</A> can be calculated using
##  <Ref Func="ProjectiveClosureOfPointSet"/>.
##  <P/>
##  <C>InducedCollineation</C> returns a collineation of the full plane (as a
##  permutation on the points of <A>plane</A>) which takes <A>point</A> to <A>image</A> and
##  acts on the Baer plane as <A>baercoll</A> does. If no such collineation
##  exists, <K>fail</K> is returned.
##  <P/>
##  This method needs <A>plane.jpoint</A>. If it is unknown, it is calculated (see
##  <Ref Func="PointJoiningLinesProjectivePlane"/>)
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("InducedCollineation",[IsRecord,IsPerm,IsInt,IsInt,IsRecord,IsPerm]);

#############################################################################
##
#O  NrFanoPlanesAtPoints(<points>,<plane>)  invariant for projective planes
##
##  <#GAPDoc Label="NrFanoPlanesAtPoints">
##  <ManSection>
##  <Oper Name="NrFanoPlanesAtPoints" Arg="points,plane"/>
##  <Description>
##  For a projective plane <A>plane</A>, <C>NrFanoPlanesAtPoints(<A>points</A>,<A>plane</A>)</C>
##  calculates the so-called Fano invariant. That is, for each point
##  in <A>points</A>, the number of subplanes of order 2 (so-called Fano planes)
##  containing this point is calculated.
##  The method returns a list of pairs of the form <M>[&lt;point&gt;,&lt;number&gt;]</M>
##  where <A>number</A> is the number of Fano sub-planes in <A>point</A>.
##  <P/>
##  This method is faster, if <A>plane.jpoint</A> is known (see
##  <Ref Func="PointJoiningLinesProjectivePlane"/>). Indeed, if <A>plane.jpoint</A> is
##  not known, this method is very slow.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(4^2+5);
##  <pc group of size 21 with 2 generators>
##  gap> diffset:=OneDiffset(G);        
##  [ f1, f1*f2, f1^2*f2^4, f1*f2^5 ]
##  gap> P:=DevelopmentOfRDS(diffset,G);;
##  gap> NrFanoPlanesAtPoints([3],P);
##  [ [ 3, 240 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("NrFanoPlanesAtPoints",[IsDenseList,IsRecord]);

#############################################################################
##
#O IncidenceMatrix(<plane>)
##
##  <#GAPDoc Label="IncidenceMatrix">
##  <ManSection>
##  <Oper Name="IncidenceMatrix" Arg="plane"/>
##  <Description>
##  returns a matrix <A>I</A>, where the columns are numbered by the blocks and
##  the rows are numbered by points. And &lt;I[i][j]=1&gt; if and only if
##  &lt;points[i]&gt; is incident (contained in) &lt;blocks[j]&gt; (an 0 else).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IncidenceMatrix",[IsRecord]);

#############################################################################
##
#O RDS_PRank(<plane>,<p>)
##
##  <#GAPDoc Label="RDS_PRank">
##  <ManSection>
##  <Oper Name="RDS_PRank" Arg="plane,p"/>
##  <Description>
##  Let <M>I</M> be the incidence matrix of the projective plane <A>plane</A> and <A>p</A> a
##  prime power.
##  The rank of <M>I.I^t</M> as a matrix over
##  <M>GF(p)</M> is called  <A>p</A>-rank of the projective plane. Here <M>I^t</M> denotes
##  the transposed matrix.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(2^2+3);
##  <pc group of size 7 with 1 generator>
##  gap> P:=DevelopmentOfRDS(OneDiffset(G),G);;
##  gap> IncidenceMatrix(P);
##  [ [ 1, 1, 1, 0, 0, 0, 0 ], [ 1, 0, 0, 1, 1, 0, 0 ], [ 0, 1, 0, 1, 0, 1, 0 ], 
##    [ 1, 0, 0, 0, 0, 1, 1 ], [ 0, 0, 1, 1, 0, 0, 1 ], [ 0, 0, 1, 0, 1, 1, 0 ], 
##    [ 0, 1, 0, 0, 1, 0, 1 ] ]
##  gap> RDS_PRank(P,3);
##  6
##  gap> RDS_PRank(P,2);
##  4
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("RDS_PRank",[IsRecord,IsInt]);

#############################################################################
##
#O FingerprintAntiFlag(<point>,<linenr>,<plane>)
##
##  <#GAPDoc Label="FingerprintAntiFlag">
##  <ManSection>
##  <Oper Name="FingerprintAntiFlag" Arg="point,linenr,plane"/>
##  <Description>
##  Let <M>m_1,\dots,m_{n+1}</M> be the lines containing <A>point</A> and
##  <M>E_1,\dots,E_{n+1}</M> the points on the line given by <A>linenr</A> such that
##  <M>E_i</M> is incident with <M>m_i</M>. Now label the points of <M>m_i</M> as
##  <M>&lt;point&gt;=P_{i,1},\dots,P_{i,n+1}=E_i</M> and the lines of <M>E_i</M> as
##  <M>&lt;line&gt;=l_1,\dots,l_{i,n+1}=m_i</M>.
##  For <M>i\not = j</M>, each <M>P_{j,k}</M> lies on exactly one line
##  <M>l_{i,k\sigma_{i,j}}</M> containing <M>E_i</M> for some permutation <M>\sigma_{i,j}</M>
##  <P/>
##  Define a matrix <M>A</M>, where <M>A_{i,j}</M> is the sign of <M>\sigma_{i,j}</M> if
##  <M>i\neq j</M> and <M>A_{i,i}=0</M> for all <M>i</M>.
##  The partial fingerprint is the multiset of entries of <M>|AA^t|</M> where <M>A^t</M>
##  denotes the transposed matrix of <M>A</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FingerprintAntiFlag",[IsInt,IsInt,IsRecord]);

#############################################################################
##
#O FingerprintProjPlane(<plane>)
##
##  <#GAPDoc Label="FingerprintProjPlane">
##  <ManSection>
##  <Oper Name="FingerprintProjPlane" Arg="plane"/>
##  <Description>
##  For each anti-flag <M>(p,l)</M> of a projective plane <A>plane</A> of order <M>n</M>,
##  define an arbitrary but fixed enumeration of the lines through <M>p</M> and
##  the points on <M>l</M>. Say <M>l_1,\dots,l_{n+1}</M> and <M>p_1,\dots,p_{n+1}</M>
##  The incidence relation defines a canonical bijection between the <M>l_i</M> and
##  the <M>p_i</M> and hence a permutation on the indices <M>1,\dots,n+1</M>.
##  Let <M>\sigma_{(p,l)}</M> be this permutation.
##  <P/>
##  Denote the points and lines of the plane by <M>q_1,\dots q_{n^2+n+1}</M>
##  and <M>e_1,\dots,e_{n^2+n+1}</M>.
##  Define the sign matrix as <M>A_{ij}=sgn(\sigma_{(q_i,e_j)})</M> if <M>(q_i,e_j)</M>
##  is an anti-flag and <M>=0</M> if it is a flag.
##  Then the fingerprint is defined as the multiset of the entries of <M>|AA^t|</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("FingerprintProjPlane",[IsRecord]);


#############################################################################
##
#O IsomorphismProjPlanesByGenerators(<gens1>,<plane1>,<gens2>,<plane2>)
#O IsomorphismProjPlanesByGeneratorsNC(<gens1>,<plane1>,<gens2>,<plane2>)
##
##  <#GAPDoc Label="IsomorphismProjPlanesByGenerators">
##  <ManSection>
##  <Oper Name="IsomorphismProjPlanesByGenerators" Arg="gens1,plane1,gens2,plane2"/>
##  <Oper Name="IsomorphismProjPlanesByGeneratorsNC" Arg="gens1,plane1,gens2,plane2"/>
##  <Description>
##  Let <A>gens1</A> be a list of points generating the projective plane
##  <A>plane1</A> and <A>gens2</A> a list of generating points for <A>plane2</A>. Then a
##  permutation is returned representing a mapping from the points of <A>plane1</A>
##  to those of <A>plane2</A> and taking the list <A>gens1</A> to the list <A>gens2</A>.
##  If there is no such mapping which defines an isomorphism of projective
##  planes, <K>fail</K> is returned.
##  <P/>
##  <C>IsomorphismProjPlanesByGeneratorsNC</C> does <E>not</E> check whether <A>gens1</A>
##  and <A>gens2</A> really generate the planes <A>plane1</A> and <A>plane2</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("IsomorphismProjPlanesByGenerators",[IsDenseList,IsRecord,IsDenseList,IsRecord]);
DeclareOperation("IsomorphismProjPlanesByGeneratorsNC",[IsDenseList,IsRecord,IsDenseList,IsRecord]);

#############################################################################
##
#E  END
##
