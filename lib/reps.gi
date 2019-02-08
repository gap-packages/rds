#############################################################################
##
#W reps.gi 			 RDS Package		 Marc Roeder
##
##  Representation theoretic methods for a special class of groups and difference sets
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
SetInfoLevel(InfoRDS,1);
SetInfoLevel(DebugRDS,0);

#############################################################################
##
#P IsListOfIntegers( <list> )	test if a collection contains only integers.
##
InstallMethod(IsListOfIntegers,"for lists",
        [IsDenseList],x->IsSubset(Integers,x)
        );
InstallOtherMethod(IsListOfIntegers,"for lists",
        [IsObject],
        function(x)
    if IsDenseList(x)
       then 
        TryNextMethod();
    else 
        return false;
    fi;
end);
    
#############################################################################
##
#P IsRootOfUnity( <cyc> )     test if a cyclotomic is a root of unity.
##
InstallMethod(IsRootOfUnity,"for cyclotomics",
        [IsCyclotomic],x->x*ComplexConjugate(x)=1
        );

#############################################################################
##
#O  CoeffList2CyclotomicList( <list>,<root> ) takes a list of integers and returns a list of integral cyclotomics.
##
InstallMethod(CoeffList2CyclotomicList,
        "for lists of integers and roots of unity",
        [IsSmallList,IsCyc],
        function(list,root)
    if not IsRootOfUnity(root) or not IsListOfIntegers(list)
       then
        TryNextMethod();
    fi;
    return List([1..Size(list)],i->list[i]*root^(i-1));
end);


RedispatchOnCondition(CoeffList2CyclotomicList,
        true,
        [IsList,IsCyc],[IsList,IsIntegralCyclotomic],0
        );

#############################################################################
##
#O  AbssquareInCyclotomics( <list>,<root> ) returns the modulus of an algebraic integer given by <list> and <root>.
##
InstallMethod(AbssquareInCyclotomics,
        "for lists of integers and roots of unity",
        [IsSmallList,IsCyc],
        function(list,root)
    local list1,sum1;
    if not IsRootOfUnity(root) or not IsListOfIntegers(list)
       then
        TryNextMethod();
    fi;
    list1:=CoeffList2CyclotomicList(list,root);
    sum1:=Sum(list1);
    return sum1*ComplexConjugate(sum1);
end);

#############################################################################
##
#O  List2Tuples( <list>,<int> ) splits <list> into <int> parts
##
InstallMethod(List2Tuples,"for lists",
        [IsList,IsPosInt],
        function(list,parts)
    local   partlength,  tmplist;
    if not Size(list) mod parts =0
       then 
        Error("Size of <list> must be divisible by <parts>");
    fi;
    partlength:=Size(list) / parts;
    tmplist:=[1..partlength];
    return List([0..parts-1],i->list{i*partlength+tmplist});
end);

#############################################################################
##
#O  CycsGivenCoeffSum( <sum>, <root> ) returns all cyclotomic integers with given coefficient sum.
##
InstallMethod(CycsGivenCoeffSum,"for cyclotomic integers",
        [IsCyc,IsCyc],
        function(sum,root)
    local   rorder,  partitions,  returnlist;
    if not IsRootOfUnity(root) then TryNextMethod();fi;
    rorder:=Order(root);
    partitions:=OrderedPartitions(sum+rorder,rorder);
    Apply(partitions,i->i-1);
    returnlist:=PartitionByFunctionNF(partitions,i->
                        AbssquareInCyclotomics(i,root));
    return List(returnlist,i->[AbssquareInCyclotomics(Representative(i),root),i]);
end);

#############################################################################
##
#O NormalSubgroupsForRep
##
InstallMethod(NormalSubgroupsForRep,
        [IsRecord,IsInt],
        function(Gdata,divisor)
    local   group,  returnlist,  normals,  Nsg,  epi,  fgrp,  gens,  
            b,  a,  rootorder,  m,  fgrp2pairmap,  int2Gmap,  root,  
            int2pairtable;
    
    group:=Gdata.G;
    returnlist:=[];
    normals:=Set(Filtered(NormalSubgroups(group),i->
                     (Index(group,i) mod divisor=0)
                     and not Size(i)=Size(group) and not Size(i)=1 
                     and not Index(group,i)=divisor)
                 );
    normals:=Filtered(normals,i->not IsAbelian(FactorGroup(group,i)));
    for Nsg in normals
      do
        epi:=NaturalHomomorphismByNormalSubgroup(group,Nsg);
        fgrp:=ImagesSource(epi);
        fgrp:=FactorGroup(group,Nsg);
        gens:=MinimalGeneratingSet(fgrp);
        b:=First(gens,i->Order(i)=divisor);
        a:=First(gens,i->Order(i)<>divisor);
        if Size(gens)=2 and b<>fail and (a^b in Group(a))
           then

            rootorder:=Order(a);
            m:=First([1..rootorder],i->
                     (a^i=a^b and 1=i^divisor mod rootorder));
            
            fgrp2pairmap:=InverseGeneralMapping(MappingByFunction(
                                  Domain(Cartesian([1..Order(a)],[1..Order(b)])),fgrp,
                                  pair->a^(pair[1]-1)*b^(pair[2]-1))
                                  );
            int2Gmap:=MappingByFunction(Domain([1..Size(Gdata.Glist)]),group,
                              i->Gdata.Glist[i]);
            
            Add(returnlist,
                rec(Nsg:=Nsg,alpha:=ANFAutomorphism(CF(rootorder),m),
                         root:=E(rootorder),fgrp:=fgrp,epi:=epi,a:=a,b:=b,
                         int2pairtable:=List([1..Size(group)],
                                 i->i^(int2Gmap*epi*fgrp2pairmap)))
                         );
        fi;     
    od; 
    return returnlist;
end);

#############################################################################
##
#O  NormalSubgroupsForRep( <groupdata>,<divisor> ) calculates normal subgroups to use with `OrderedSigs'
##
#InstallMethod(NormalSubgroupsForRep,
#        [IsMagmaWithInverses,IsInt],
#        function(group,divisor)
#    local   returnlist,  normals,  Nsg,  epi,  fgrp,  gens,  b,  a,  
#            rootorder,  m,  root;
#
#    returnlist:=[];
#    normals:=Set(Filtered(NormalSubgroups(group),i->
#                     (Index(group,i) mod divisor=0)
#                     and not Size(i)=Size(group) and not Size(i)=1 
#                     and not Index(group,i)=divisor)
#                 );
#    normals:=Filtered(normals,i->not IsAbelian(FactorGroup(group,i)));
#    for Nsg in normals
#      do
#        epi:=NaturalHomomorphismByNormalSubgroup(group,Nsg);
#        fgrp:=ImagesSource(epi);
#        fgrp:=FactorGroup(group,Nsg);
#        gens:=MinimalGeneratingSet(fgrp);
#        b:=First(gens,i->Order(i)=divisor);
#        a:=First(gens,i->Order(i)<>divisor);
#        if Size(gens)=2 and b<>fail and (a^b in Group(a))
#           then
#
#            rootorder:=Order(a);
#            m:=First([1..rootorder],i->
#                     (a^i=a^b and 1=i^divisor mod rootorder));
#            Add(returnlist,
#                rec(Nsg:=Nsg,alpha:=ANFAutomorphism(CF(rootorder),m),
#                         root:=E(rootorder),fgrp:=fgrp,epi:=epi,a:=a,b:=b));
#        fi;     
#    od; 
#    return returnlist;
#end);

#############################################################################
##
#O OrderedSigs
##
InstallMethod(OrderedSigs,"for difference sets in certain groups",
        [IsSmallList,IsPosInt,IsGeneralMapping,IsCyc],
        function(coeffSums,absSum,alpha,root)
    local   List2Number,  TestTuple,  rorder,  perm,  permorder,  src,  
            blockshifts,  blockshiftperms,  PermTupleEmbedding,  
            rightsideMatrix,  m,  rshift,  cc,  ccac,  ccacdp,  
            rootmults,  block,  tuple,  b,  acGroup,  stabGroup,  
            sortedcoeffSums,  unsortingPerm,  coeffSet,  partSet,  
            absClassDict,  abscoordinates,  searchtuples,  aimSet,  
            absClassTuples,  returnlist,  lastEntry,  absClassTuple,  
            cartesian,  lastone,  rawtuple,  tuples,  tup,  splittup,  
            cyc;

    if not (IsListOfIntegers(coeffSums) and  IsRootOfUnity(root))
       then
        Error("Argumtents are of wrong type!");
    fi;

    List2Number:=function(list);
        return Sum(CoeffList2CyclotomicList(list,root));
    end;

    TestTuple:=function(cycrow,pi,gamma,matrix)
        if not (Size(cycrow)=Order(pi) and Order(pi)=Order(gamma) 
                and Order(gamma)=Size(matrix))
           then   # this should never happen!
            Error("I will not buy this record, it is scratched!");
        fi;
        return ForAll([0..Size(cycrow)-1],i->cycrow*Permuted(List(cycrow,j->
                       ComplexConjugate(j)^(gamma^i)),pi^i)
                      =matrix[1][i+1]);
    end;

    rorder:=Order(root);
    perm:=PermList(Concatenation([2..Size(coeffSums)],[1]));
    permorder:=Order(perm);

    if not Order(alpha^Size(coeffSums))=1
       then
        Error("Wrong form of matrix!");
    fi;

    src:=[1..rorder];

    blockshifts:=List([1..Size(coeffSums)],i->(i-1)*rorder+src);
    blockshiftperms:=List(blockshifts,dst->MappingPermListList(src,dst));

    PermTupleEmbedding:=function(permtup)
        return Product(List([1..Size(permtup)],i->permtup[i]^blockshiftperms[i]));
    end;

    rightsideMatrix:=absSum*IdentityMat(Size(coeffSums));

    m:=First([1..rorder-1],i->root^alpha=root^i);
    rshift:=PermList(Concatenation([2..rorder],[1]));
    cc:=ANFAutomorphism(CF(rorder),-1);
    ccac:=MinimalGeneratingSet(Action(Group(cc),List([1..rorder],i->root^(i-1))))[1];
    ccacdp:=PermTupleEmbedding(List([1..Size(coeffSums)],i->ccac));    

    rootmults:=[];

    for block in [1..Size(coeffSums)]
      do
        tuple:=[];
        tuple[block]:=0;
        for b in [1..Size(coeffSums)-1]
          do
            tuple[block^(perm^b)]:=(tuple[block^(perm^(b-1))]+1)*m mod rorder;
        od;
        Info(DebugRDS,1,tuple);
        Add(rootmults,List([1..Size(tuple)],i->rshift^tuple[i]));
    od;

    Apply(rootmults,i->PermTupleEmbedding(i));
    acGroup:=Group(Concatenation(rootmults,[ccacdp]));

    stabGroup:=Stabilizer(Group(rootmults),[2*rorder+1..Size(coeffSums)*rorder],OnTuples);
    sortedcoeffSums:=ShallowCopy(coeffSums);
    unsortingPerm:=Inverse(Sortex(sortedcoeffSums));

    coeffSet:=Set(sortedcoeffSums);
    partSet:=List(coeffSet,i->[i,CycsGivenCoeffSum(i,root)]);
    absClassDict:=List(sortedcoeffSums,i->First(partSet,j->i=j[1])[2]);
    abscoordinates:=List(absClassDict,i->Set(i,j->j[1]));
    searchtuples:=Cartesian(abscoordinates{[1..Size(abscoordinates)-1]});
    
    Info(DebugRDS,2,"|searchtuples|=",Size(searchtuples));
    
    aimSet:=Set(abscoordinates[Size(abscoordinates)]);
    absClassTuples:=[];
    returnlist:=[];
    for tuple in searchtuples
      do
        lastEntry:=absSum-Sum(tuple);
        if lastEntry in aimSet
           then
            absClassTuple:=List([1..Size(tuple)],i->
                                List(Filtered(absClassDict[i],j->j[1]=tuple[i]),k->k[2]));
            Apply(absClassTuple,Concatenation);
            cartesian:=Cartesian(absClassTuple);
            Apply(cartesian,Concatenation);
            cartesian:=List(Orbits(stabGroup,cartesian,Permuted),Representative);
            lastone:=List(Filtered(absClassDict[Size(tuple)+1],j->j[1]=lastEntry),k->k[2]);
            lastone:=Concatenation(lastone);
            Add(absClassTuples,[cartesian,lastone]);
        fi;
    od;

    Info(DebugRDS,2,"|absClassTuples|=",Size(absClassTuples));
    
    returnlist:=[];
    for rawtuple in absClassTuples
      do
        tuples:=List(rawtuple[1],i->List(rawtuple[2],j->Concatenation([i,j])));
        tuples:=Concatenation(tuples);
        tuples:=List(Orbits(acGroup,tuples,Permuted),Representative);
        Info(DebugRDS,3,Size(tuples));
        for tup in tuples
          do
            splittup:=List2Tuples(tup,Size(coeffSums));
            cyc:=List(splittup,List2Number);
            if TestTuple(cyc,perm,alpha,rightsideMatrix)
               then
                Add(returnlist,tup);
            fi;
        od;
    od;
    returnlist:=Concatenation(List(returnlist,i->Orbit(acGroup,i,Permuted)));
    returnlist:=Set(returnlist,i->List2Tuples(i,Size(coeffSums)));
    Apply(returnlist,i->Permuted(i,unsortingPerm));
    return Set(returnlist);
end);


#############################################################################
##
#O OrderedSignatureOfSet(<set>,<normal_data>)
##
InstallMethod(OrderedSignatureOfSet,
        "for ordinary difference sets of special form",
        [IsDenseList,IsRecord],        
        function(set,normal_data)
    local   table,  returnlist,  image,  i;
    table:=normal_data.int2pairtable;
    returnlist:=NullMat(Order(normal_data.b),Order(normal_data.a));
    image:=Collected(List(set,i->table[i]));
    for i in image
      do
        returnlist[i[1][2]][i[1][1]]:=i[2];
    od;
    return returnlist;
end);

#############################################################################
##
#E  END
##
