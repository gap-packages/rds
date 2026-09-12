#############################################################################
##
#W sigs.gd 			 RDS Package		 Marc Roeder
##
##  Invariants for partial difference sets
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
#V RDS_MaxAutsizeForOrbitCalculation
##
##  <#GAPDoc Label="RDS_MaxAutsizeForOrbitCalculation">
##  <ManSection>
##  <Var Name="RDS_MaxAutsizeForOrbitCalculation"/>
##  <Description>
##  In <Ref Func="ReducedStartsets"/>, a bound is needed to decide if <C>Orbit</C> or
##  <C>RepresentativeAction</C> should be used. If the group is larger than
##  <A>RDS_MaxAutsizeForOrbitCalculation</A>, <C>RepresentativeAction</C> is used.
##  The default value for <C>RDS_MaxAutsizeForOrbitCalculation</C> is <M>5*10^6</M>.
##  You can change it by simply setting it to a different value.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
RDS_MaxAutsizeForOrbitCalculation := 5*10^6;

#############################################################################
##
#O  RDSFactorGroupData(<U>,<N>,<lambda>,<Gdata>)
##
##  <#GAPDoc Label="RDSFactorGroupData">
##  <ManSection>
##  <Oper Name="RDSFactorGroupData" Arg="U,N,lambda,Gdata"/>
##  <Description>
##  takes the subgroup <A>U</A> of <A>G</A>, the forbidden set <A>N</A> as a subgroup or
##  subset of <A>G</A> and the record of data <A>Gdata</A> as returned by
##  <C>PermutationRepForDiffsetCalculations(<A>G</A>)</C> and returns a record containing
##  <List>
##  <Mark>.fg</Mark>
##  <Item> the factor group modulo <A>U</A>
##   </Item>
##  <Mark>.fglist</Mark>
##  <Item> the factor group as a strictly ordered list
##   </Item>
##  <Mark>.cosets</Mark>
##  <Item> the cosets modulo <A>U</A> as lists of integers
##   </Item>
##  <Mark>.lambda</Mark>
##  <Item> the parameter <A>lambda</A> as passed to the function
##   </Item>
##  <Mark>.Usize</Mark>
##  <Item> the size of <A>U</A>
##   </Item>
##  <Mark>.fgaut</Mark>
##  <Item> the automorphism group of &lt;.fg&gt;
##   </Item>
##  <Mark>.Nfg</Mark>
##  <Item> the image of <A>N</A> in &lt;.fg&gt;
##   </Item>
##  <Mark>.fgintersect</Mark>
##  <Item> a list of pairs such that the <M>i^{th}</M> entry is the
##    pair consisting of &lt;.fg[i]&gt; and the size of the intersection of &lt;.fg&gt; with
##   &lt;.Nfg&gt; as cosets modulo <A>U</A>.
##   </Item>
##  <Mark>.intersectshort</Mark>
##  <Item> ist just the second component of &lt;.fgintersect&gt;.</Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("RDSFactorGroupData",[IsGroup,IsObject,IsInt,IsRecord]);

#############################################################################
##
#O MatchingFGDataNonGrp(<fgdatalist>,<fgmatchdata>)  
##
##  <#GAPDoc Label="MatchingFGDataNonGrp">
##  <ManSection>
##  <Oper Name="MatchingFGDataNonGrp" Arg="fgdatalist,fgmatchdata"/>
##  <Description>
##  Let <A>fgdatalist</A> be a list of records and <A>fgmatchdata</A> a record with components
##  &lt;.fg&gt;, &lt;.Nfg&gt; and &lt;.fgintersect&gt;  as returned by <Ref Func="RDSFactorGroupData"/>.
##  Then <C>MatchingFGDataNonGrp</C> returns the entry of <A>fgdatalist</A> that defines
##  the same admissible signatures as <A>fgmatchdata</A>. If no such entry exists,
##  <K>fail</K> is returned.
##  <P/>
##  The forbidden set <M>N</M> is not assumed to be a group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("MatchingFGDataNonGrp",[IsList,IsRecord]);

#############################################################################
##
#O MatchingFGData(<fgdatalist>,<fgmatchdata>)  
##
##  <#GAPDoc Label="MatchingFGData">
##  <ManSection>
##  <Oper Name="MatchingFGData" Arg="fgdatalist,fgmatchdata"/>
##  <Description>
##  Let <A>fgdatalist</A> be a list of records and <A>fgmatchdata</A> a record with components
##  &lt;.fg&gt;, &lt;.Nfg&gt;, &lt;.fgintersect&gt; and &lt;.fgaut&gt; as returned by <Ref Func="RDSFactorGroupData"/>.
##  Then <C>MatchingFGDataNonGrp</C> returns the entry of <A>fgdatalist</A> that defines
##  the same admissible signatures as <A>fgmatchdata</A>. If no such entry exists,
##  <K>fail</K> is returned.
##  <P/>
##  Here the forbidden set <M>N</M> has to be a group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("MatchingFGData",[IsList,IsRecord]);


#############################################################################
##
#O  CosetSignatures( <Gsize>,<Usize>,<diffsetorder> )    calculates possible signatures for difference sets.
#O  CosetSignatures( <Gsize>,<Nsize>,<Usize>,<Intersectsizes>,<k>,<lambda>)    calculates possible signatures for relative difference sets with forbidden groups.
##
##  <#GAPDoc Label="CosetSignatures">
##  <ManSection>
##  <Oper Name="CosetSignatures" Arg="Gsize,Usize,diffsetorder"/>
##  <Oper Name="CosetSignatures" Label="for Gsize,Nsize,Usize,Intersectsizes,k,lambda" Arg="Gsize,Nsize,Usize,Intersectsizes,k,lambda"/>
##  <Description>
##  <C>CosetSignatures( <A>Gsize</A>,<A>Usize</A>,<A>diffsetorder</A>)</C> returns all
##  <M>&lt;Gsize&gt;/&lt;Usize&gt;</M> tuples such that the sum of the squares of each tuple
##  equals  <A>Usize</A>+<A>diffsetorder</A>. And the sum of each tuple equals
##  <A>diffsetorder</A>+1.
##  <P/>
##  These are necessary conditions for signatures of difference sets and
##  normal subgroups of order <A>Usize</A> in groups of order <A>Gsize</A> (see <Ref Sect="The Coset Signature"/>).
##  <P/>
##  <C>CosetSignatures( <A>Gsize</A>,<A>Nsize</A>,<A>Usize</A>,<A>Intersectsizes</A>,<A>k</A>,<A>lambda</A>)</C>
##  Calculates all multiset meeting some  conditions for signatures of relative
##  difference sets and normal subgroups of order <A>Usize</A> in groups of
##  order <A>Gsize</A> (see <Ref Sect="The Coset Signature"/>).
##  Here <A>Nsize</A> is the size of the forbidden group,
##  <A>Intersectsizes</A> is a list of integers determining the size of the
##  intersection of the forbidden set and the normal Subgroup of order <A>Usize</A>.
##  The parameters <A>k</A> and <A>lambda</A> are the usual ones for designs.
##  <C>CosetSignatures</C> returns a list containing one pair for each entry <A>i</A> of
##  <A>Intersectsizes</A>. The first entry of this pair is
##  <M>[&lt;Gsize&gt;,&lt;Nsize&gt;,&lt;Usize&gt;,&lt;i&gt;,&lt;k&gt;,&lt;lambda&gt;]</M> and the second one is a list
##  of admissible signatures with these parameters.
##  <Example><![CDATA[
##  gap> CosetSignatures(256,16,64,[1,4,8,16],17,1);  
##  [ [ [ 256, 16, 64, 1, 17, 1 ], [  ] ], 
##    [ [ 256, 16, 64, 4, 17, 1 ], [ [ 3, 4, 4, 6 ] ] ], 
##    [ [ 256, 16, 64, 8, 17, 1 ], [ [ 4, 4, 4, 5 ] ] ], 
##    [ [ 256, 16, 64, 16, 17, 1 ], [  ] ] ]
##  gap> #And for an ordinary difference set of order 16.
##  gap> CosetSignatures(273,1,39,[1],17,1);  
##  [ [ [ 273, 1, 39, 1, 17, 1 ], 
##        [ [ 0, 1, 2, 3, 3, 4, 4 ], [ 0, 2, 2, 2, 3, 3, 5 ], 
##            [ 1, 1, 1, 2, 4, 4, 4 ], [ 1, 1, 1, 3, 3, 3, 5 ], 
##            [ 1, 1, 2, 2, 2, 4, 5 ] ] ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("CosetSignatures",[IsInt,IsInt,IsInt]);
DeclareOperation("CosetSignatures",[IsInt,IsInt,IsInt,IsInt,IsInt,IsInt]);
DeclareOperation("CosetSignatures",[IsInt,IsInt,IsInt,IsDenseList,IsInt,IsInt]);

#############################################################################
##
#O  TestedSignatures(<sigs>,<group>,<Normalsg>[,<maxtest>][,<moretest>])   returns a subset of <sigs> satisfying necessary conditions for signatures of difference sets.
##
##  <#GAPDoc Label="TestedSignatures">
##  <ManSection>
##  <Oper Name="TestedSignatures" Arg="sigs,group,Normalsg[,maxtest][,moretest]"/>
##  <Description>
##  <E>this does only work for ordinary difference sets, not for
##  relative difference sets in general</E>
##  <P/>
##  Let <A>sigs</A> be a list of possible signatures as returned by
##  <Ref Func="CosetSignatures"/>. Let <A>Normalsg</A> be a subgroup of <A>group</A>.
##  For each signature in <A>sigs</A>, the necessary conditions described in
##  <Ref Sect="The Coset Signature"/> are tested to decide
##  if the signature can be a signature of a  difference set in <A>group</A> for
##  for the normal subgroup <A>Normalsg</A>.
##  <P/>
##  As this involves computation for all permutations of the signature, this
##  can be very costly. The argument <A>maxtest</A> determines how many
##  permutations are admissible. If <A>maxtest</A>=0, all signatures are tested,
##  regardless of how much work is necessary for this. If a signature has
##  too many permutations, it is returned without test. Even though it is
##  not wise, <C><A>maxtest</A>=0</C> is the default option.
##  If <C>InfoLevel(InfoRDS)</C><Index>InfoRDS@ InfoRDS</Index> is at least <M>2</M>,
##  information about skipped signatures is echoed.
##  <P/>
##  If the boolean value <A>moretest</A> is <A>false</A> and all signatures in <A>sigs</A> but
##  the last one are found to be not admissible, the last one is returned
##  without test. This saves the time to test the last signature, but if
##  chances are that there is no difference set in <A>group</A>, this may also
##  give away a chance to find out early (every difference set has
##  signatures, so no admissible signature means that no difference set can
##  exist). Default is <A>true</A>.
##  <P/>
##  <C>TestedSignatures</C> calls <Ref Func="TestSignatureCyclicFactorGroup"/> or
##  <Ref Func="TestSignatureLargeIndex"/> and returns a sublist of <A>sigs</A>.
##  <Example><![CDATA[
##  gap> G:=SmallGroup(273,2);;
##  gap> N:=First(NormalSubgroups(G),g->Order(g)=39);
##  Group([ f1, f3 ])
##  gap> sigs:=CosetSignatures(273,1,39,[1],17,1);  
##  [ [ [ 273, 1, 39, 1, 17, 1 ], 
##        [ [ 0, 1, 2, 3, 3, 4, 4 ], [ 0, 2, 2, 2, 3, 3, 5 ], 
##            [ 1, 1, 1, 2, 4, 4, 4 ], [ 1, 1, 1, 3, 3, 3, 5 ], 
##            [ 1, 1, 2, 2, 2, 4, 5 ] ] ] ]
##  gap> TestedSignatures(sigs[1][2],G,N);                              
##  [ [ 1, 1, 1, 2, 4, 4, 4 ], [ 1, 1, 1, 3, 3, 3, 5 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup]);
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup,IsInt]);
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup,IsBool]);
DeclareOperation("TestedSignatures",[IsList,IsGroup,IsGroup,IsInt,IsBool]);


#############################################################################
##
#O  TestedSignaturesRelative(<sigs>,<fgdata>,[,<maxtest>][,<moretest>])  returns subset of <sigs> which might be a set of signatures of relative difference sets with forbidden group.
##
##  <#GAPDoc Label="TestedSignaturesRelative">
##  <ManSection>
##  <Oper Name="TestedSignaturesRelative" Arg="sigs,fgdata,[,maxtest][,moretest]"/>
##  <Description>
##  <C>TestedSignaturesRelative</C> takes a list <A>sigs</A> of lists of integers and
##  returns a those which may be signatures of relative difference sets with
##  forbidden set.
##  <P/>
##  <A>fgdata</A> is a record as returned by
##  <C>RDSFactorGroupData(<A>U</A>,<A>N</A>,<A>lambda</A>,<A>Gdata</A>)</C>
##  If <A>maxtest</A> is set, a signature <M>s</M> is only tested if
##  <C>NrPermutationsList(s)</C>
##  is less than <A>maxtest</A> if <A>maxtest</A> is set to 0, all signatures are tested
##  this is the default.
##  If <A>moretest</A> is tue, a signature is tested even if it is the only one left.
##  This means we do not assume that there must be an admissible signature at all.
##  The default for <A>moretest</A> is <A>true</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord,IsInt,IsBool]);
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord,IsInt]);
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord,IsBool]);
DeclareOperation("TestedSignaturesRelative",[IsList,IsRecord]);
DeclareOperation("TestSignatureRelative",[IsList,IsRecord]);


#############################################################################
##
#O  TestSignatureLargeIndex(<sig>,<group>,<Normalsg>[,<factorgrp>])  tests if a list can be signature for a difference set
##
##  <#GAPDoc Label="TestSignatureLargeIndex">
##  <ManSection>
##  <Oper Name="TestSignatureLargeIndex" Arg="sig,group,Normalsg[,factorgrp]"/>
##  <Description>
##  <E>this does only work for ordinary difference sets, not for
##  relative difference sets in general</E>
##  <P/>
##  <C>TestSignatureLargeIndex(<A>sig</A>,<A>group</A>,<A>Normalsg</A>[,<A>factorgrp</A>])</C> tests
##  if <A>sig</A> meets some necessary conditions of <Ref Sect="The Coset Signature"/> to be
##  a signature for a difference set in  <A>group</A> for the normal subgroup
##  <A>Normalsg</A>. <A>factorgrp</A> is the factorgroup <A>group</A>/<A>Normalsg</A>.
##  The returned value is <A>true</A> or <A>false</A> resp.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TestSignatureLargeIndex",[IsList,IsGroup,IsGroup]);
DeclareOperation("TestSignatureLargeIndex",[IsList,IsGroup,IsGroup,IsGroup]);

#############################################################################
##
#O  TestSignatureCyclicFactorGroup(<sig>,<Nsize>)  tests if a list can be signature for a difference set
##
##  <#GAPDoc Label="TestSignatureCyclicFactorGroup">
##  <ManSection>
##  <Oper Name="TestSignatureCyclicFactorGroup" Arg="sig,Nsize"/>
##  <Description>
##  <E>This does only work for ordinary difference sets, not for relative
##  difference sets in general</E>
##  <P/>
##  <C>TestSignatureCyclicFactorGroup(<A>sig</A>,<A>Nsize</A>)</C> test if <A>sig</A> meets
##  meets some necessary conditions of <Ref Sect="The Coset Signature"/> to be a signature
##  for a difference set in some group, which has a normal subgroup of
##  size <A>Nsize</A> such that  the factor group is cyclic.
##  The returned value is <A>true</A> or <A>false</A> resp.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("TestSignatureCyclicFactorGroup",[IsList,IsInt]);


#############################################################################
##
#F  CosetSignatureOfSet( <set>,<cosets>)        calculate the signature of a partial RDS.
##
##  <#GAPDoc Label="CosetSignatureOfSet">
##  <ManSection>
##  <Func Name="CosetSignatureOfSet" Arg="set,cosets"/>
##  <Description>
##  <C>CosetSignatureOfSet( <A>set</A>,<A>cosets</A>)</C> returns the <E>ordered list</E> of
##  intersection numbers of <A>set</A>. That is, the size of the intersection
##  of <A>set</A> with each Element of <A>cosets</A>.
##  <P/>
##  Note that it is not tested, if <A>cosets</A> is really a list of cosets.
##  <C>CosetSignatureOfSet( <A>set</A>,<A>cosets</A>)</C> works for any List <A>set</A> and any
##  list of lists <A>cosets</A>. So be careful!
##  <Example><![CDATA[
##  gap> G:=SymmetricGroup(5);;
##  gap> A:=AlternatingGroup(5);;
##  gap> CosetSignatureOfSet([(1,2),(1,5),(1,2,3)],RightCosets(G,A));
##  [ 1, 2 ]
##  gap> CosetSignatureOfSet([(1,2),(1,5),(1,2,3)],[A]);              
##  [ 1 ]
##  gap> CosetSignatureOfSet([(1,2),(1,5),(1,2,3)],[[(1,2),(1,2,3)],[(3,2,1)]]);
##  [ 0, 2 ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("CosetSignatureOfSet");

#############################################################################
##
#F  OrderedCosetSignatureOfSet( <set>,<cosets>)        calculate the signature of a partial RDS.
##
##  <#GAPDoc Label="OrderedCosetSignatureOfSet">
##  <ManSection>
##  <Func Name="OrderedCosetSignatureOfSet" Arg="set,cosets"/>
##  <Description>
##  <C>CosetSignatureOfSet( <A>set</A>,<A>cosets</A>)</C> returns the list of
##  intersection numbers of <A>set</A>. That is, the size of the intersection
##  of <A>set</A> with each Element of <A>cosets</A>.
##  <P/>
##  Note that it is not tested, if <A>cosets</A> is really a list of cosets.
##  <C>CosetSignatureOfSet( <A>set</A>,<A>cosets</A>)</C> works for any List <A>set</A> and any
##  list of lists <A>cosets</A>. So be careful!
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("OrderedCosetSignatureOfSet");


#############################################################################
##
#O SigInvariant( < diffset >,<data>)      calculates the signature of a partial relative difference set.
##
##  <#GAPDoc Label="SigInvariant">
##  <ManSection>
##  <Oper Name="SigInvariant" Arg="diffset ,data"/>
##  <Description>
##  Given a partial relative difference set <A>diffset</A> and a list of
##  records with entries <A>cosets</A> and <A>sigs</A>.
##  Here <A>cosets</A> is a full list of cosets and <A>sigs</A> is a list of
##  signatures that may occur for relative difference sets.
##  <P/>
##  For each record <A>rec</A> in <A>data</A>, the intersection numbers of
##  <A>diffset</A> with  the cosets of <A>rec.cosets</A> are computed stored in
##  a set <A>sig</A>. If none of the signatures in <A>rec.sigs</A> is pointwise
##  greater or equal <A>sig</A>, <C>SigInvariant( <A>diffset</A>,<A>data</A>) returns `fail</C>.
##  Otherwise <A>sig</A> is added to a list of signatures that is returned.
##  <P/>
##  Note the returned invariant is that of <M>diffset\cup \{1\}</M>.
##  The output from <C>SignatureDataForNormalSubgroups</C> can be used as <A>data</A>.
##  <Example><![CDATA[
##  gap> G:=SmallGroup(273,2);                    
##  <pc group of size 273 with 3 generators>
##  gap> Gdata:=PermutationRepForDiffsetCalculations(G);;
##  gap> N:=First(NormalSubgroups(G),g->Order(g)=39);
##  Group([ f1, f3 ])
##  gap> sigs:=CosetSignatures(273,1,39,[1],17,1);  
##  [ [ [ 273, 1, 39, 1, 17, 1 ], 
##        [ [ 0, 1, 2, 3, 3, 4, 4 ], [ 0, 2, 2, 2, 3, 3, 5 ], 
##            [ 1, 1, 1, 2, 4, 4, 4 ], [ 1, 1, 1, 3, 3, 3, 5 ], 
##            [ 1, 1, 2, 2, 2, 4, 5 ] ] ] ]
##  gap> TestedSignatures(sigs[1][2],G,N);                              
##  [ [ 1, 1, 1, 2, 4, 4, 4 ], [ 1, 1, 1, 3, 3, 3, 5 ] ]
##  gap> sigs:=TestedSignatures(sigs[1][2],G,N);
##  [ [ 1, 1, 1, 2, 4, 4, 4 ], [ 1, 1, 1, 3, 3, 3, 5 ] ]
##  gap>   ## calculate cosets in permutation notation:
##  gap> rc:=List(RightCosets(G,N),i->GroupList2PermList(Set(i),Gdata));;
##  gap> data:=[rec(cosets:=rc,sigs:=sigs)];;
##  gap> SigInvariant([3,4,5],data);
##  [ [ [ 0, 0, 0, 0, 0, 1, 3 ], 1 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("SigInvariant",[IsDenseList,IsDenseList]);

#############################################################################
##
#O ReducedStartsets(<startsets>,<autlist>,<csdata>,<Gdata>) returns a reduced set of startsets
#O ReducedStartsets(<startsets>,<autlist>,<func>,<Gdata>) returns a reduced set of startsets
##
##  <#GAPDoc Label="ReducedStartsets">
##  <ManSection>
##  <Oper Name="ReducedStartsets" Arg="startsets,autlist,csdata,Gdata"/>
##  <Oper Name="ReducedStartsets" Label="for startsets,autlist,func,Gdata" Arg="startsets,autlist,func,Gdata"/>
##  <Description>
##  Let  <A>startsets</A> be a set of partial relative difference sets, <A>autlist</A> a
##  list of permutation groups and <A>Gdata</A> record returned by
##  <C>PermutationRepForDiffsetCalculations</C>.
##  Then <C>ReducedStartsets</C> partitions the list <A>startsets</A> according to the
##  values of the function <A>func</A> and performs a test for equivalence on the
##  elements of the partition. The list returned is a sublist
##  of <A>startsets</A> of pairwise non-equivalent partial relative difference sets
##  if <A>func</A> is an invariant for partial relative difference sets. All elements
##  for which <A>func</A> returns <K>fail</K> are discarded.
##  <P/>
##  If a list <A>csdata</A> of records as used for <Ref Func="SigInvariant"/> (i.e. containing
##  &lt;.cosets&gt; and &lt;.signatures&gt;) is passed, then <C>ReducedStartsets</C>
##  uses <Ref Func="SigInvariant"/> for <A>func</A>.
##  <Log><![CDATA[
##  gap> G:=CyclicGroup(57);
##  <pc group of size 57 with 2 generators>
##  gap> Gdata:=PermutationRepForDiffsetCalculations(G);;
##  gap> cosetsigs:=SignatureDataForNormalSubgroups(NormalSubgroups(Gdata.G),
##  > sigdata, [One(Gdata.G)],Gdata,[8,1,10^6,true]);;
##  gap> SigInvariant([3,4,5,9],cosetsigs);
##  [ [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1 ], 1 ], [ [ 1, 1, 3 ], 1 ] ]
##  gap> ssets:=AllDiffsets([],2,[],Gdata);; 
##  gap> Size(ssets);
##  1458
##  gap> Size(ReducedStartsets(ssets,[Group(())],cosetsigs,Gdata));
##  #I  Size 1458
##  #I  5/ 0 @ 0:00:00.126
##  486
##  gap> Size(ReducedStartsets(ssets,[Gdata.Ai],cosetsigs,Gdata)); 
##  #I  Size 1458
##  #I  5/ 0 @ 0:00:00.123
##  17
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix]);
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsFunction,IsMatrix]);
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsFunction,IsRecord]);
DeclareOperation("ReducedStartsets",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord]);
DeclareSynonym("MoreReduction",ReducedStartsets);

#############################################################################
##
#O SignatureDataForNormalSubgroups(<Normals>,<globalSigData>,<forbiddenSet>,<Gdata>,<parameters>)
##
##  <#GAPDoc Label="SignatureDataForNormalSubgroups">
##  <ManSection>
##  <Oper Name="SignatureDataForNormalSubgroups" Arg="Normals,globalSigData,forbiddenSet,Gdata,parameters"/>
##  <Description>
##  Let <A>Gdata</A> be a record as returned by <Ref Func="PermutationRepForDiffsetCalculations"/>.
##  Let <A>Normals</A> be a list of normal subgroups of <A>Gdata.G</A>, and <A>forbiddenSet</A> the forbidden set
##  (as set of group elements or group).
##  <P/>
##  <A>parameters</A> must be a list of length 4 of the form &lt;[k,lambda,maxtest,moretest]&gt;
##  with <A>k</A> the length of the relative difference set to be constructed and <A>lambda</A> the parameter
##  as always. <A>maxtest</A> and <A>moretest</A> are passed to <C>TestedSignaturesRelative</C> and must be set.
##  <P/>
##  <C>SignatureDataForNormalSubgroups</C> returns a list containing one record for each group <M>U</M> in
##  <A>Normals</A>. This record contains:
##  <Enum>
##  <Item> the subgroup <A>U</A> named &lt;.subgroup&gt;
##   </Item>
##  <Item> the signatures &lt;.sigs&gt; for <A>U</A>
##   </Item>
##  <Item> the cosets &lt;.cosets&gt; modulo <A>U</A> as lists of integers</Item>
##  </Enum>
##  Moreover, the list <A>globalSigData</A> is used to store global information which can be
##  reused with other groups. The <M>i^{th}</M> entry of <A>globalSigData</A> is a list of records
##  that contains all known information about subgroups of order <M>i</M>.
##  Each of these records has the following components:
##  <List>
##  <Mark>1.</Mark>
##  <Item> &lt;.cspara&gt; the parameters for <Ref Func="CosetSignatures"/>
##   </Item>
##  <Mark>2.</Mark>
##  <Item> &lt;.sigs&gt; the output of <Ref Func="CosetSignatures"/> when the input is &lt;.cspara&gt;
##   </Item>
##  <Mark>3.</Mark>
##  <Item> &lt;.fgsigs&gt; a list of records containing data about factor groups with parameters &lt;.cspara&gt;:
##    </Item>
##  <Mark>3.1.</Mark>
##  <Item> &lt;.fg&gt; the factor group
##    </Item>
##  <Mark>3.2.</Mark>
##  <Item> &lt;.fgaut&gt; the automorphism group of &lt;.fg&gt;
##    </Item>
##  <Mark>3.3.</Mark>
##  <Item> &lt;.Nfg&gt; the image of the forbidden set <M>N</M> under the natural epimorphism to &lt;.fg&gt;
##    </Item>
##  <Mark>3.4.</Mark>
##  <Item> &lt;.fgintersect&gt; the pairs <M>[g,|g\cap N| ]</M> for all <M>g</M> in &lt;.fg&gt;. Here <M>N</M> is the forbidden set.
##    </Item>
##  <Mark>3.5.</Mark>
##  <Item> &lt;.sigs&gt; the known admissible signatures (this is a subset of the set in number 2.
##               of course)</Item>
##  </List>
##  <P/>
##  The list <A>globalSigData</A> can be used if different groups are studied. If a group has a normal
##  subgroup with parameters (in the sense of &lt;.cspara&gt;) listed in <A>globalSigData</A>, the signatures
##  from a previous calculation may be used. Of course, the factor groups have to be checked first.
##  This check is done with <Ref Func="MatchingFGData"/> or <Ref Func="MatchingFGDataNonGrp"/>.
##  <P/>
##  So the second run of <C>SignatureDataForNormalSubgroups</C> with the same parameters and different
##  <A>Gdata</A> and <A>Normals</A> will normally be much faster, as the signatures are already stored in
##  <A>globalSigData</A>. Note that <A>maxtest</A> and <A>moretest</A> are not stored. So a second run with
##  larger <A>maxtest</A> will not result in a recalculation of signatures.
##  <Log><![CDATA[
##  gap> G:=CyclicGroup(57);
##  <pc group of size 57 with 2 generators>
##  gap> Gdata:=PermutationRepForDiffsetCalculations(G);;
##  gap> SignatureDataForNormalSubgroups(NormalSubgroups(Gdata.G),sigdata,
##  > [One(Gdata.G)],Gdata,[8,1,10^6,true]);   # for ordinary diffset of order 7.
##  [ rec( subgroup := Group([ f1*f2^6 ]), 
##        sigs := [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 ] ], 
##        cosets := [ [ 1, 20, 40 ], [ 3, 23, 43 ], [ 6, 26, 46 ], [ 9, 29, 49 ], 
##        	     	  [ 12, 32, 52 ], [ 15, 35, 55 ], [ 18, 38, 57 ], 
##  		  [ 4, 21, 41 ], [ 7, 24, 44 ], [ 10, 27, 47 ], 
##            	  [ 13, 30, 50 ], [ 16, 33, 53 ], [ 19, 36, 56 ], 
##  		  [ 2, 22, 39 ], [ 5, 25, 42 ], [ 8, 28, 45 ], [ 11, 31, 48 ], 
##  		  [ 14, 34, 51 ], [ 17, 37, 54 ] ] ), 
##    rec( subgroup := Group([ f2 ]), sigs := [ [ 1, 3, 4 ] ], 
##        cosets := [ [ 1, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 
##        	     	  45, 48, 51, 54 ], 
##            [ 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50,
##  	    53, 56 ], 
##            [ 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49,
##  	     52, 55, 57 ] ] ) ]
##  gap> Filtered([1..Size(sigdata)],i->IsBound(sigdata[i]));
##  [ 3, 19 ]
##  gap> Size(sigdata[3]);
##  2
##  gap> sigdata[3][1].cspara;sigdata[3][2].cspara;
##  [ 57, 1, 3, 1, 7, 1 ]
##  [ 57, 1, 3, 1, 8, 1 ]
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("SignatureDataForNormalSubgroups",
        [IsDenseList,IsList,IsObject,IsRecord,IsDenseList]);


#############################################################################
##
#O MultiplicityInvariantLargeLambda( <set>,<Gdata>)
##
##  <#GAPDoc Label="MultiplicityInvariantLargeLambda">
##  <ManSection>
##  <Oper Name="MultiplicityInvariantLargeLambda" Arg="set,Gdata"/>
##  <Description>
##  Let <A>set</A> be a partial relative difference set with <M>\lambda&gt;1</M>.
##  Set <C><A>P</A>:=AllPresentables(<A>set</A>,<A>Gdata</A>)</C> then the set of multiplicities
##  of <A>P</A> is an invariant for partial relative difference sets.
##  <P/>
##  <C>MultiplicityInvariantLargeLambda</C> returns a list in a form as <C>Collected</C>
##  does.
##  <Example><![CDATA[
##  gap> G:=CyclicGroup(7);;Gdata:=PermutationRepForDiffsetCalculations(G);;
##  gap> AllPresentables([2,3],Gdata);
##  [ 2, 3, 7, 2, 7, 6 ]
##  gap> MultiplicityInvariantLargeLambda([2,3],Gdata);
##  [ [ 1, 2 ], [ 2, 2 ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("MultiplicityInvariantLargeLambda",[IsDenseList,IsRecord]);


#############################################################################
##
#O NormalSgsForQuotientImages(<forbidden>,<Gdata>)
##
##  <#GAPDoc Label="NormalSgsForQuotientImages">
##  <ManSection>
##  <Oper Name="NormalSgsForQuotientImages" Arg="forbidden,Gdata"/>
##  <Description>
##  calculates all normal subgroups of <A>Gdata.G</A> which lie in <A>forbidden</A>.
##  The returned value is a list of normal subgroups which define pairwise
##  non-isomorphic factor groups.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("NormalSgsForQuotientImages",
        [IsMagmaWithInverses,IsRecord]);
DeclareOperation("NormalSgsForQuotientImages",
        [IsDenseList,IsRecord]);


#############################################################################
##
#O DataForQuotientImage(<normal>,<forbidden>,<k>,<lambda>,<Gdata>);
##
##  <#GAPDoc Label="DataForQuotientImage">
##  <ManSection>
##  <Oper Name="DataForQuotientImage" Arg="normal,forbidden,k,lambda,Gdata"/>
##  <Description>
##  Let <A>Gdata</A> be the usual record for a group <M>G</M>. And let <A>k</A> and <A>lambda</A>
##  be the parameters of the relative difference set we want to find.
##  Let then <A>forbidden</A> be the forbidden set (as a group or a list of group
##  elements or integers) and <A>normal</A> a normal subgroup of <M>G</M> which is
##  contained in <A>forbidden</A>.
##  <P/>
##  Then <C>DataForQuotientImage</C> returns a record containing the record
##  &lt;.Gdata&gt; of the factor group <M>G/U</M> where the automorphism group is the one
##  induced by the stabiliser of <A>normal</A> in the automorphism group of <M>G</M>.
##  Furthermore the returned record contains the forbidden set &lt;.forbidden&gt; in
##  <M>G/U</M> and the new parameter &lt;.lambda&gt; for the difference set in <M>G/U</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("DataForQuotientImage",
        [IsMagmaWithInverses,IsMagmaWithInverses,IsPosInt,IsPosInt,IsRecord]);

DeclareOperation("DataForQuotientImage",
        [IsMagmaWithInverses,IsDenseList,IsPosInt,IsPosInt,IsRecord]);


#############################################################################
##
#O OrderedSigsFromQuotientImages(<fGroupData>,<qimages>,<forbidden>,<normal>,<Gdata>)
##
##  <#GAPDoc Label="OrderedSigsFromQuotientImages">
##  <ManSection>
##  <Oper Name="OrderedSigsFromQuotientImages" Arg="fGroupData,qimages,forbidden,normal,Gdata"/>
##  <Description>
##  Let <A>Gdata</A> be the usual record for a group <M>G</M> and <A>normal</A> a normal
##  subgroup of <M>G</M> which lies in the forbidden set <A>forbidden</A>.
##  Let then <A>fGroupData</A> be the record &lt;.Gdata&gt; describing <M>G/&lt;normal&gt;</M> as
##  returned by <Ref Func="DataForQuotientImage"/> and <A>qimages</A> a set of difference sets
##  in <M>G/&lt;normal&gt;</M>.
##  <P/>
##  Then <C>OrderedSigsFromQuotientImages</C> returns a record containing a list of
##  ordered signatures &lt;.orderedSigs&gt; and a list of cosets &lt;.cosets&gt; as well as
##  the factor group &lt;.fg&gt; defined by <A>fGroupData</A> and its full automorphism
##  group <A>fgaut</A> and the image of <A>forbidden</A> in &lt;.fg&gt; is returned as &lt;.Nfg&gt;.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("OrderedSigsFromQuotientImages",
        [IsRecord,IsDenseList,IsObject,IsMagmaWithInverses,IsRecord]);

#############################################################################
##
#O OrderedSigInvariant(<set>,<data>)  calculate ordered signatures
##
##  <#GAPDoc Label="OrderedSigInvariant">
##  <ManSection>
##  <Oper Name="OrderedSigInvariant" Arg="set,data"/>
##  <Description>
##  does the same as <Ref Func="SigInvariant"/>, but for ordered signatures. Here <A>data</A>
##  has to be a list of records containing ordered signatures called
##  &lt;.orderedSigs&gt; and cosets &lt;.cosets&gt; just as returned by
##  <Ref Func="OrderedSigsFromQuotientImages"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("OrderedSigInvariant",[IsDenseList,IsDenseList]);



#############################################################################
##
#O MatchingFGDataForOrderedSigs(<forbidden>,<Gdata>,<Normalsgs>,<fgdata>)
##
##  <#GAPDoc Label="MatchingFGDataForOrderedSigs">
##  <ManSection>
##  <Oper Name="MatchingFGDataForOrderedSigs" Arg="forbidden,Gdata,Normalsgs,fgdata"/>
##  <Description>
##  Let <A>fgdata</A> be a list of records of the form returned by
##  <Ref Func="OrderedSigsFromQuotientImages"/> and <A>Normalsgs</A> a list of normal subgroups
##  of the group <A>Gdata.G</A>. Furthermore let <A>forbidden</A> be the forbidden set
##  as a list of group elements or integers or a subgroup of <A>Gdata.G</A>.
##  <P/>
##  Then <C>MatchingFGDataForOrderedSigs</C> retruns all elements of <A>fgdata</A> which
##  match a normal subgroup of <A>Normalsgs</A>. The returned value is a record
##  containing the normal subgroup &lt;.normal&gt; from <A>Normalsgs</A>, the record
##  &lt;.sigdata&gt; from <A>fgdata</A> and a homomorphism &lt;.hom&gt; which maps <A>Gdata.G</A>
##  onto &lt;.sigdata.Gdata.G&gt; and takes <A>forbidden</A> to &lt;.sigdata.Nfg&gt;.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareOperation("MatchingFGDataForOrderedSigs",
        [IsObject,IsRecord,IsDenseList,IsDenseList]);
        
        
#############################################################################
##
#E   ........ ENDE
##
