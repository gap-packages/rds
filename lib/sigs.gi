#############################################################################
##
#W sigs.gi 			 RDS Package		 Marc Roeder
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
#O RDSFactorGroupData(<U>,<N>,<lambda>,<Gdata>);
##
InstallMethod(RDSFactorGroupData,
        [IsGroup,IsObject,IsInt,IsRecord],
        function(U,N,lambda,Gdata)
    local   group,  cosets,  csreps,  cosetsperm,  epi,  fg,  fglist,  
            intersectlist,  returnlist;

    group:=Gdata.G;
    if not IsNormal(group,U)
       then
        Error("The normal subgroup should be a _normal_ subgroup");
    fi;
    cosets:=RightCosets(group,U);
    csreps:=List(cosets,Representative);
    cosetsperm:=List(cosets,coset->GroupList2PermList(Set(coset),Gdata));
    epi:=NaturalHomomorphismByNormalSubgroup(group,U);
    fg:=ImagesSource(epi);
    fglist:=Set(fg);
    intersectlist:=List(csreps,i->[Image(epi,i),Size(Intersection(RightCoset(U,i),N))]);
    returnlist:=List(fglist,i->First(intersectlist,j->j[1]=i)[2]);
    return rec(fg:=fg,
               fglist:=fglist,
               lambda:=lambda,
               cosets:=cosetsperm,
               cosetsreps:=csreps,
               Usize:=Size(U),
               fgaut:=AutomorphismGroup(fg),
               Nfg:=Image(epi,N),
               fgintersect:=intersectlist,
               intersectshort:=returnlist);
end);
           




#######									####
##MatchingFGData:							   #
##Prueft, ob es in fgdatalist schon einen Eintrag gibt, die zum Datensatz  
##fgmatchdata passt und gibt ihn zurueck.
##
## gibt es einen, ist er eindeutig, gibt es keinen, wird [] zurueckgegeben.
##  Mindestgehalt von fgmatchdata:
##   .fg, .Nfg .fgintersect .fgaut
##  Dabei muss .Nfg eine Gruppe sein.
######									####

InstallMethod(MatchingFGData,
        [IsList,IsRecord],
        function(fgdatalist,fgmatchdata)
    local remaining,Nfgiso,fgiso,imageNfg,group,fgmatchset,fgmatchintnumbers,fggroupset,fggroupintnumbers,perm,Nfgaut,newfgiso, sigma;
    
    if fgdatalist=[] then return [];fi;
    remaining:=Filtered(fgdatalist,d->IsomorphismGroups(d.fg,fgmatchdata.fg)<>fail);
    if remaining=[] then return fail;fi;
    
    remaining:=Filtered(remaining,d->IsomorphismGroups(d.Nfg,fgmatchdata.Nfg)<>fail);
    if remaining=[] then return fail;fi;

    for group in remaining
      do
        fgiso:=IsomorphismGroups(fgmatchdata.fg,group.fg);
        imageNfg:=Image(fgiso,fgmatchdata.Nfg);
        if imageNfg=group.Nfg
           then
            fgmatchset:=List(fgmatchdata.fgintersect,i->i[1]);
            fgmatchintnumbers:=List(fgmatchdata.fgintersect,i->i[2]);
            fggroupset:=Set(group.fg);
            fggroupintnumbers:=List(group.fgintersect,i->i[2]);
            perm:=PermListList(Image(fgiso,fgmatchset),fggroupset);     
            if Permuted(fgmatchintnumbers,perm)=fggroupintnumbers
               then 
                return group;
            fi;
        fi;
        Nfgaut:=RepresentativeAction(group.fgaut,group.Nfg,imageNfg,OnSubgroups);
        if Nfgaut<>fail
           then
            Info(DebugRDS,2,"*",Size(Stabilizer(group.fgaut,imageNfg,OnSubgroups)),"*\c");
            for sigma in Stabilizer(group.fgaut,imageNfg,OnSubgroups)              do
                newfgiso:=fgiso*Nfgaut*sigma;
                fgmatchset:=List(fgmatchdata.fgintersect,i->i[1]);
                fgmatchintnumbers:=List(fgmatchdata.fgintersect,i->i[2]);
                fggroupset:=List(group.fg);
                fggroupintnumbers:=List(group.fgintersect,i->i[2]);
                perm:=PermListList(Image(newfgiso,fgmatchset),fggroupset);     
                if Permuted(fgmatchintnumbers,perm)=fggroupintnumbers
                   then 
                    return group;
                fi;
            od;
        fi;
    od;
    return fail;
end);


#######									####
##MatchingFGDataNonGrp:							   #
##Prueft, ob es in fgdatalist schon einen Eintrag gibt, die zum Datensatz  
##fgmatchdata passt und gibt ihn zurueck.
##
## gibt es einen, ist er eindeutig, gibt es keinen, wird [] zurueckgegeben.
##  Mindestgehalt von fgmatchdata:
##   .fg, .Nfg .fgintersect
##  Hier muss .Nfg nicht Gruppe sein.
######									####

InstallMethod(MatchingFGDataNonGrp,
        [IsList,IsRecord],
        function(fgdatalist,fgmatchdata)
    local remaining,fgiso,Nfgiso,imageNfg,group,newfgiso,fgmatchset,fggroupset,fgmatchintnumbers,fggroupintnumbers,perm,Nfgaut,sigma ;
    if fgdatalist=[] then return fail;fi;

    remaining:=Filtered(fgdatalist,d->IsomorphismGroups(d.fg,fgmatchdata.fg)<>fail);
    if remaining=[] 
       then 
        return fail;
    fi;

    for group in remaining
      do
        fgiso:=IsomorphismGroups(fgmatchdata.fg,group.fg);
        imageNfg:=Image(fgiso,fgmatchdata.Nfg);
        if imageNfg=group.Nfg
           then
            fgmatchset:=List(fgmatchdata.fgintersect,i->i[1]);
            fgmatchintnumbers:=List(fgmatchdata.fgintersect,i->i[2]);
            fggroupset:=List(group.fg);
            fggroupintnumbers:=List(group.fgintersect,i->i[2]);
            perm:=PermListList(Image(fgiso,fgmatchset),fggroupset);     
            if Permuted(fgmatchintnumbers,perm)=fggroupintnumbers
               then 
                return group;
            fi;
        fi;
        Nfgaut:=RepresentativeAction(group.fgaut,group.Nfg,imageNfg,OnSets);
        if Nfgaut<>fail
           then
            Info(DebugRDS,2,"*",Size(Stabilizer(group.fgaut,imageNfg,OnSets)),"*\c");            
            for sigma in Stabilizer(group.fgaut,imageNfg,OnSets)
              do
                newfgiso:=fgiso*Nfgaut*sigma;
                fgmatchset:=List(fgmatchdata.fgintersect,i->i[1]);
                fgmatchintnumbers:=List(fgmatchdata.fgintersect,i->i[2]);
                fggroupset:=List(group.fg);
                fggroupintnumbers:=List(group.fgintersect,i->i[2]);
                perm:=PermListList(Image(newfgiso,fgmatchset),fggroupset);     
                if Permuted(fgmatchintnumbers,perm)=fggroupintnumbers
                   then 
                    return group;
                fi;
            od;
        fi;
    od;
    return fail;
end);


#############################################################################
##
#O  CosetSignatures( <Gsize>,<Usize>,<diffsetorder> )    calculates possible signatures for difference sets.
##
InstallMethod(CosetSignatures,[IsInt,IsInt,IsInt],
        function(Gsize,Usize,diffsetorder)
    local   siglist,  sig;

    return CosetSignatures(Gsize,1,Usize,1,diffsetorder+1,1);
end);



#############################################################################
##
#O  CosetSignatures( <Gsize>,<Nsize>,<Usize>,<Intersectsize>,<k>,<lambda>)    calculates possible signatures for relative difference sets.
##
InstallMethod(CosetSignatures,[IsInt,IsInt,IsInt,IsInt,IsInt,IsInt],
        function(Gsize,Nsize,Usize,Intersectsize,k,lambda) #order n=k-lambda

    return CosetSignatures(Gsize,Nsize,Usize,[Intersectsize],k,lambda)[1][2];
end);



#############################################################################
##
#O  CosetSignatures( <Gsize>,<Nsize>,<Usize>,<Intersectsizes>,<k>,<lambda>)    calculates possible signatures for relative difference sets.
##
InstallMethod(CosetSignatures,[IsInt,IsInt,IsInt,IsDenseList,IsInt,IsInt],
        function(Gsize,Nsize,Usize,Intersectsizes,k,lambda) #order n=k-lambda
    local   parameters,  partint,  range,  partsize,  sig,  
            sig0indices,  largest,  largestsquare,  rightsides,  
            siglist,  minright,  maxright,  sig0,  leftside;

    if Gsize<=Nsize then Error("Stupid parameters!");fi;
    parameters:=[Gsize,Nsize,Usize,0,k,lambda];
    partint:=k+Gsize/Usize;
    range:=[1..k-lambda+1];
    partsize:=Gsize/Usize;
    sig:=[1..partsize];
    sig0indices:=[2..partsize];
    largest:=0;
    largestsquare:=0;
    rightsides:=List(Intersectsizes,i->k+lambda*(Usize-i));
    siglist:=List(Intersectsizes,i->[[Gsize,Nsize,Usize,i,k,lambda],[]]);
    minright:=Minimum(rightsides);
    maxright:=Maximum(rightsides);
    while range<>[]
      do
        largest:=range[Size(range)];
        largestsquare:=(largest-1)^2;
        sig[1]:=largest-1;
        if largestsquare<=maxright and partint<=largest*partsize and largestsquare*partsize>=minright
           then
            for sig0 in RestrictedPartitions(partint-largest,range,partsize-1)
              do        
                Apply(sig0,i->i-1);
                leftside:=largestsquare+sig0*sig0;
                if leftside in rightsides
                   then 
                    sig{sig0indices}:=sig0;
                    AddSet(siglist[Position(rightsides,leftside)][2],SortedList(sig));
                fi;
            od;
        fi;
        Unbind(range[Size(range)]);
    od;
    return siglist;
end);



#############################################################################
##
#O  TestedSignatures(<sigs>,<group>,<normalsg>[,<maxtest>][,<moretest>])   returns a subset of <sigs> satisfying necessary conditions.
##
InstallMethod(TestedSignatures,
        [IsList,IsGroup,IsGroup],
        function(sigs,group,normalsg)
    return TestedSignatures(sigs,group,normalsg,0,true);
end);

InstallMethod(TestedSignatures,
        [IsList,IsGroup,IsGroup,IsInt],
        function(sigs,group,normalsg,maxtest)
    return TestedSignatures(sigs,group,normalsg,maxtest,true);
end);

InstallMethod(TestedSignatures,
        [IsList,IsGroup,IsGroup,IsBool],
        function(sigs,group,normalsg,moretest)
    return TestedSignatures(sigs,group,normalsg,0,moretest);
end);



InstallMethod(TestedSignatures,
        [IsList,IsGroup,IsGroup,IsInt,IsBool],
        function(sigs,group,normalsg,maxtest,moretest)
    local   Nsize,  lsigs,  factorgrp,  sig;

    Nsize:=Size(normalsg);
    lsigs:=[];
    if Size(sigs)=1 and not moretest
       then
        Info(InfoRDS,1,"There is only one signature to test, I will skip it as requested:\n",sigs[1]);
        return sigs;
    fi;
    factorgrp:=FactorGroup(group,normalsg);
    if IsCyclic(factorgrp)
       then
        for sig in sigs
          do
            if maxtest<>0 and NrPermutationsList(sig)>maxtest
               then 
                Add(lsigs,sig);
                Info(InfoRDS,2,"Signature ",sig," has too many permutations, not tested as requested. factor:",Int(NrPermutationsList(sig)/maxtest));
            elif Position(sigs,sig)=Size(sigs) and lsigs=[] and not moretest
              then
                Info(InfoRDS,1,"All but the last signature died. Adding it without testing");
                Add(lsigs,sig);
            elif TestSignatureCyclicFactorGroup(sig,Nsize)
              then
                Add(lsigs,sig);
            fi;
        od;
    else
        for sig in sigs
          do
            if maxtest<>0 and NrPermutationsList(sig)>maxtest
               then 
                Add(lsigs,sig);
                Info(InfoRDS,2,"Signature ",sig," has too many permutations, not tested as requested, factor:",Int(NrPermutationsList(sig)/maxtest));
            elif Position(sigs,sig)=Size(sigs) and lsigs=[] and not moretest
              then
                Info(InfoRDS,1,"All but the last signature died. Adding it without testing");
                Add(lsigs,sig);
            elif TestSignatureLargeIndex(sig,group,normalsg,factorgrp)
              then
                Add(lsigs,sig);
            fi;
        od;
    fi;
    return lsigs;
end);


#############################################################################
##
#O  TestSignatureLargeIndex(<sig>,<group>,<Normalsg>)  tests if a given list can be signature for a difference set
##
InstallMethod(TestSignatureLargeIndex,
        [IsList,IsGroup,IsGroup],
        function(sig,group,Normalsg) 
    local   factorgrp;

    factorgrp:=FactorGroup(group,Normalsg);
    return TestSignatureLargeIndex(sig,group,Normalsg,factorgrp);
end);



#############################################################################
##
#O  TestSignatureLargeIndex(<sig>,<group>,<Normalsg>,<factorgrp>)  tests if a given list can be signature for a difference set
##
InstallMethod(TestSignatureLargeIndex,
        [IsList,IsGroup,IsGroup,IsGroup],
        function(sig,group,Normalsg,factorgrp) 
    local   fgrplist,  nsgsize,  offs,  partitions,  part,  perma,  
            permb,  parta,  partb,  psig;


    fgrplist:=Set(factorgrp);         #Faktorgruppe als strikt geordnete Liste
    nsgsize:=Size(Normalsg);

    offs:=Filtered(fgrplist,i->Order(i)<>1);            #offset.
    partitions:=List(Combinations(sig,Int(Size(sig)/2)),i->[i,RemovedSublist(sig,i)]);
    for part in partitions                                      #Alle Permutationen von sig zu berechnen ist zu 
      do                                                        # speicheraufwaendig. Teile sig also in zwei Teile
        perma:=Iterator(PermutationsList(part[1]));             # und rechne die Permutationen so in Stuecken.
        permb:=PermutationsList(part[2]);
        for parta in perma
          do
            for partb in permb
              do 
                psig:=Concatenation(parta,partb);
                if ForAll(offs,o->Sum(fgrplist,i->(psig[PositionSet(fgrplist,i)]*psig[PositionSet(fgrplist,(i*o))]))=nsgsize)
                   then
                    return true;                        
                fi;
            od;
        od;
    od;
    return false;
end);


#############################################################################
##
#O  TestSignatureCyclicFactorGroup(<sig>,<Nsize>)  tests if a list can be signature for a difference set
##
InstallMethod(TestSignatureCyclicFactorGroup,
        [IsList,IsInt],
        function(sig,Nsize)
    local   index,  indices,  offs,  partitions,  part,  perma,  
            permb,  parta,  partb,  psig;

    index:=Size(sig);
    indices:=[0..index-1];
    offs:=Filtered(indices,i->(i mod index <>0));
    partitions:=List(Combinations(sig,Int(index/2)),i->[i,RemovedSublist(sig,i)]);
    for part in partitions
      do 
        perma:=Iterator(PermutationsList(part[1]));
        permb:=PermutationsList(part[2]);
        for parta in perma
          do
            for partb in permb
              do 
                psig:=Concatenation(parta,partb);
                if ForAll(offs,o->Sum(indices,i->(psig[i+1]*psig[((i-o) mod index)+1]))=Nsize)
                   then                                  # Size(psig)=Size(sig)=|G:N|
                    return true;
                fi;
            od;
        od;
    od;
    return false;
end);



#############################################################################
#O  TestSignatureRelative(<sig>,<fgdata>)  tests if a list can be signature for a relative difference set with forbidden set
##

InstallMethod(TestSignatureRelative,
        [IsList,IsRecord],
        function(sig,fgdata)
    local   Intersectsize,  fgrplist,  Usize,  lambda,  offsnonN,  
            offsN,  partitions,  part,  perma,  permb,  parta,  partb,  
            psig,  intersectlist;


    if Size(Set(fgdata.fgintersect))=1
       then 
        Intersectsize:=Set(fgdata.fgintersect);
    else
        Intersectsize:=0;
    fi;

    ##
    #  U=N is the trivial case #
    ##
    if Intersectsize>0 and fgdata.Usize=Intersectsize and Size(fgdata.Nfg)=1
       then
        if Number(sig,i->i=1)=Sum(sig) then return true; else return false;fi;
    fi;

    if not Size(fgdata.fg)=Size(sig)
       then
        Error("fg and sig don't match");
    fi;
    fgrplist:=fgdata.fglist;
    Usize:=fgdata.Usize;
    lambda:=fgdata.lambda;
    offsnonN:=Set(Filtered(fgrplist,i->Order(i)<>1));	#offset.
    offsN:=Filtered(IntersectionSet(fgrplist,Set(fgdata.Nfg)),i->Order(i)<>1); #offset in Nfg
    SubtractSet(offsnonN,offsN);				#offset outside Nfg

    partitions:=List(Combinations(sig,Int(Size(sig)/2)),i->[i,RemovedSublist(sig,i)]);
    if Intersectsize>0 
       then
        for part in partitions	
          do							
            perma:=Iterator(PermutationsList(part[1]));		
            permb:=PermutationsList(part[2]);
            for parta in perma
              do
                for partb in permb
                  do 
                    psig:=Concatenation(parta,partb);
                    if ForAll(offsN,o->Sum(fgrplist,i->(psig[PositionSet(fgrplist,i)]*psig[PositionSet(fgrplist,(i*o))]))=lambda*(Usize-Intersectsize))
                       and
                       ForAll(offsnonN,o->Sum(fgrplist,i->(psig[PositionSet(fgrplist,i)]*psig[PositionSet(fgrplist,(i*o))]))=lambda*Usize)
                       then
                        return true;
                    fi;
                od;
            od;
        od;
    else
        intersectlist:=fgdata.intersectshort;
        for part in partitions	
          do							
            perma:=Iterator(PermutationsList(part[1]));		
            permb:=PermutationsList(part[2]);
            for parta in perma
              do
                for partb in permb
                  do 
                    psig:=Concatenation(parta,partb);
                    if ForAll(offsN,o->Sum(fgrplist,i->(psig[PositionSet(fgrplist,i)]*psig[PositionSet(fgrplist,(i*o))]))=lambda*(Usize-intersectlist[PositionSet(fgrplist,o)]))
                       and
                       ForAll(offsnonN,o->Sum(fgrplist,i->(psig[PositionSet(fgrplist,i)]*psig[PositionSet(fgrplist,(i*o))]))=lambda*Usize)
                       then
                        return true;
                    fi;
                od;
            od;
        od;
    fi;
    return false;
end);




#############################################################################
##
#O  TestedSignaturesRelative(<sigs>,<fgdata>,[,<maxtest>][,<moretest>])  returns subset of <sigs> which might be a set of signatures of relative difference sets with forbidden group.
##
InstallMethod(TestedSignaturesRelative,
        [IsList,IsRecord,IsInt],
        function(sigs,fgdata,maxtest)
    return TestedSignaturesRelative(sigs,fgdata,maxtest,true);
end);

InstallMethod(TestedSignaturesRelative,
        [IsList,IsRecord],
        function(sigs,fgdata)
    return TestedSignaturesRelative(sigs,fgdata,0,true);
end);

InstallMethod(TestedSignaturesRelative,
        [IsList,IsRecord,IsBool],
        function(sigs,fgdata,moretest)
    return TestedSignaturesRelative(sigs,fgdata,0,moretest);
end);

InstallMethod(TestedSignaturesRelative,
	[IsList,IsRecord,IsInt,IsBool],
        function(sigs,fgdata,maxtest,moretest)
    local   lsigs,  sig;
    lsigs:=[];
    if Size(sigs)=1 and not moretest
       then
        Info(InfoRDS,1,"All but the last signature died. Adding it without testing");
        return sigs;
    fi;
    for sig in sigs
      do
        if maxtest<>0 and NrPermutationsList(sig)>maxtest 
           then 
            Add(lsigs,sig);
            Info(InfoRDS,2,"Signature ",sig," has too many permutations, I didn't test it. Factor: ",Int(NrPermutationsList(sig)/maxtest));
        elif Position(sigs,sig)=Size(sigs) and lsigs=[] and not moretest
          then
            Info(InfoRDS,1,"All but the last signature died. Adding it without testing");
            Add(lsigs,sig);
        elif TestSignatureRelative(sig,fgdata)
          then
            Add(lsigs,sig);
        fi;
    od;
    return lsigs;
end);



#############################################################################
##
#F  OrderedCosetSignatureOfSet( <set>,<cosets>)        calculate the signature of a patial RDS.
##
InstallGlobalFunction("OrderedCosetSignatureOfSet",
        function(set,cosets)
    local   sig,  class;

    sig:=[];
    for class in cosets
      do
        Add(sig,Number(set,i->i in class));
    od;
    return sig;
end);


#############################################################################
##
#F  CosetSignatureOfSet( <set>,<cosets>)        calculate the signature of a patial RDS.
##
InstallGlobalFunction("CosetSignatureOfSet",
        function(set,cosets)
    return SortedList(OrderedCosetSignatureOfSet(set,cosets));
end);


#############################################################################
##
#O  SigInvariant( < prd >,<data>)      calculates the signature of a partial relative difference set.
##
InstallMethod(SigInvariant,
        [IsDenseList,IsDenseList],
        function(set,cosets_sigs)
    local lset,coset_data,setsig,return_list; 

    if cosets_sigs=[] 
       then 
        return [];
    fi;
    if IsListOfIntegers(set) or not (IsSet(set) and 
               CategoryCollections(IS_REC)(cosets_sigs))
       then 
        TryNextMethod();
    fi;

    if not set[1]^0 in set
       then
        lset:=Union(set,[set[1]^0]);
    else
        lset:=set;
    fi;

    return_list:=[];
    for coset_data in cosets_sigs
      do
        setsig:=CosetSignatureOfSet(lset,coset_data.cosets);
        if ForAll(coset_data.sigs,i->(not Pointwiseleq(setsig,i)))
           then
            return fail;
        else 
            Add(return_list,setsig);
        fi;
    od;
    return_list:=Collected(return_list);
    return return_list;
end);
##########
InstallOtherMethod(SigInvariant,
        [IsDenseList,IsDenseList],
        function(set,cosets_sigs)
    local lset,coset_data,setsig,return_list; 

    if cosets_sigs=[] 
       then 
        return [];
    fi;
    if not IsListOfIntegers(set) or not (IsSet(set) and 
               CategoryCollections(IS_REC)(cosets_sigs))
       then 
        TryNextMethod();
    fi;

    if not 1 in set
       then
        lset:=Union(set,[1]);
    else
        lset:=set;
    fi;

    return_list:=[];
    for coset_data in cosets_sigs
      do
        setsig:=CosetSignatureOfSet(lset,coset_data.cosets);
        if ForAll(coset_data.sigs,i->(not Pointwiseleq(setsig,i)))
           then
            return fail;
        else 
            Add(return_list,setsig);
        fi;
    od;
    return_list:=Collected(return_list);
    return return_list;
end);


#############################################################################
##
#O ReducedStartsets(<startsets>,<autlist>,<csdata>,<difftable>) returns a reduced set of startsets
##
InstallMethod(ReducedStartsets,
        "for partial relative difference sets",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix],
        function(startsets,autlist,csdata,difftable)	
    return ReducedStartsets(startsets,autlist,s->SigInvariant(Union(s,[1]),csdata),difftable);
end);


#
# rewritten (just after version 1.0) and moved to separate file:
#
##############################################################################
###
##O ReducedStartsets(<startsets>,<autlist>,<func>,<difftable>) returns a reduced set of startsets
###
#InstallMethod(ReducedStartsets,
#        "for partial relative difference sets",
#        [IsDenseList,IsDenseList,IsFunction,IsMatrix],
#        function(startsets,autlist,func,difftable)	
#    local   Translates,  timetmp,  partition,  returnset,  lssets,  
#            transset,  auts,  set,  interesting_sets,  orbit,  
#            interesting,  transset_pos;
#
#    if not IsSet(startsets) then Error("\nThe set of startsets must be a SET\n");fi;
#    Info(InfoRDS,1,"Size ",Size(startsets));
#    if startsets=[] then return [];fi;
#
#    Translates:=function(set)
#        local   returnlist,  g,  trans;
#
#        returnlist:=[];
#        for g in set
#          do
#            trans:=difftable{set}[g];                 
#            Add(trans,difftable[1][g]); 
#            Sort(trans);
#            RemoveSet(trans,1);
#            Add(returnlist,trans);
#        od;
#        Add(returnlist,AsSet(set));
#        return returnlist;
#    end;
#    timetmp:=Runtime();
#    partition:=PartitionByFunction(startsets,func);
#    Info(InfoRDS,1,Size(partition),"/ ",Number(partition,p->Size(p)=1)," @",StringTime(Runtime()-timetmp));
#    Apply(partition,SortedList);
#
#    returnset:=[];
#    for lssets in partition
#      do
#        Info(DebugRDS,2,Size(lssets));
#        if Size(lssets)>1
#           then
#            transset:=Set(lssets,l->[l,Translates(l)]);#Translatmengen
#            for auts in autlist 
#              do
#                for set in lssets    
#                  do		  
#                    if Size(set)>1 and Size(auts)>RDS_MaxAutsizeForOrbitCalculation
#                       then
#                        interesting_sets:=Set(Filtered(transset,t->ForAny(t[2],s->RepresentativeAction(auts,s,AsSet(set),OnSets)<>fail)),
#                                                i->i[1]);
#                    else       
#                        orbit:=AsSortedList(Orbit(auts,AsSet(set),OnSets));;
#                        interesting_sets:=Set(Filtered(transset,t->ForAny(t[2],s->s in orbit)),
#                                                i->i[1]);
#                    fi;
#                    interesting_sets:=Intersection(interesting_sets,lssets);
#                    RemoveSet(interesting_sets,Reversed(Minimum(List(interesting_sets,b->Reversed(b)))));
#                    for interesting in interesting_sets
#                      do
#                        Unbind(lssets[Position(lssets,interesting)]);
#                        for transset_pos in [1..Size(transset)]
#                          do
#                            if IsBound(transset[transset_pos])
#                               and transset[transset_pos][1]=interesting
#                               then
#                                Unbind(transset[transset_pos]);
#                                break;
#                            fi;
#                        od;
#                    od;
#                    #                    if not set in lssets then Error("PANIC! this should not happen!");fi;
#                od;         #<for set in lssets>
#                Info(DebugRDS,2,"->",Size(Compacted(lssets)));    
#            od;
#        fi;         #<\if Size(lssets)>1>#
#    od;         #<\for lssets in partition>#
#    returnset:=Compacted(Concatenation(partition));
#    return SortedList(returnset);
#end); 
#
#InstallMethod(ReducedStartsets,
#        "for partial relative difference sets",
#        [IsDenseList,IsDenseList,IsDenseList,IsRecord],
#        function(startsets,autlist,csdata,data)
#    return ReducedStartsets(startsets,autlist,csdata,data.diffTable);
#end);
#
#InstallMethod(ReducedStartsets,
#        "for partial relative difference sets",
#        [IsDenseList,IsDenseList,IsFunction,IsRecord],
#        function(startsets,autlist,func,data)
#    return ReducedStartsets(startsets,autlist,func,data.diffTable);
#end);



#############################################################################
##
#O SignatureDataForNormalSubgroups(<Normals>,<globalSigData>,<forbiddenSet>,<Gdata>,<parameters>)
##
InstallMethod(SignatureDataForNormalSubgroups,
        [IsDenseList,IsList,IsObject,IsRecord,IsDenseList],
        function(Normals,globalSigData,forbiddenSet,Gdata,parameters)
    local   k,  lambda,  maxtest,  moretest,  forbidden,  isgroup,  
            groupOrder,  forbiddenSetOrder,  normalSubgroupsData,  
            isbadforbiddenset,  nsg,  Usize,  Intersectsize,  
            csparameters,  oldfgsigs,  sigs,  olddata,  newdata,  
            newglobaldata,  fgmatch,  cosets;

 
    k:=parameters[1];
    lambda:=parameters[2];
    maxtest:=parameters[3];
    moretest:=parameters[4];
    if not IsSubset(Gdata.G,Set(forbiddenSet))
       then
        Error("forbidden set must be a list of group elements or a group");
    fi;
    if IsGroup(forbiddenSet) 
       then
        forbidden:=forbiddenSet;
        isgroup:=true;
    elif Size(Group(forbiddenSet))=Size(forbiddenSet)       
       then    
        isgroup:=true;
        forbidden:=Group(forbiddenSet);
    else
        isgroup:=false;
        forbidden:=forbiddenSet;
    fi;

    if not IsInt(k) and IsInt(lambda) and IsInt(maxtest) and IsBool(moretest)
       then
        Error("wrong parameters");
    fi;
    groupOrder:=Size(Gdata.G);
    forbiddenSetOrder:=Size(forbidden);    
    normalSubgroupsData:=[];
    isbadforbiddenset:=false;
    for nsg in Filtered(Normals,n->not (Size(n)=1 or n=Gdata.G))
      do
        if not isbadforbiddenset 
           then
            Usize:=Size(nsg);
            Intersectsize:=Size(Intersection(forbidden,nsg));
            csparameters:=[groupOrder,forbiddenSetOrder,Usize,Intersectsize,k,lambda];

            oldfgsigs:=[];	
            sigs:=[];
            ####look if this has already been calculated...####
            if IsBound(globalSigData[Usize]) and globalSigData[Usize]<>[]
               then
                olddata:=Filtered(globalSigData[Usize],d->d.cspara=csparameters);
            else 
                olddata:=[];
            fi;
            if olddata<>[]
               then
                if Size(olddata)>1 
                   then 
                    Error("global signature data is corrupt!");
                fi;
                olddata:=olddata[1]; #olddata has just one entry.
                sigs:=olddata.sigs;
                oldfgsigs:=olddata.fgsigs;
            else	####...if not, calculate it now.
                sigs:=CallFuncList(CosetSignatures,csparameters);
            fi;
            newdata:=RDSFactorGroupData(nsg,forbidden,lambda,Gdata);
            newdata.sigs:=StructuralCopy(sigs);
            newglobaldata:=rec(cspara:=csparameters,sigs:=sigs,fgsigs:=[newdata]);

            if newglobaldata.fgsigs[1].sigs=[]
               then 
                Info(InfoRDS,1,"Signature equations have no solution.");
                isbadforbiddenset:=true;#this forbidden group does not occur
                return fail;   # nothing to to here...
            fi;			
            fgmatch:=fail;
            if oldfgsigs<>[]
               then 
                if not isgroup
                   then
                    fgmatch:=MatchingFGDataNonGrp(oldfgsigs,newglobaldata.fgsigs[1]);
                else 
                    fgmatch:=MatchingFGData(oldfgsigs,newglobaldata.fgsigs[1]);
                fi;
            fi;
            if fgmatch=fail
               ###							      ###
               # oldfgsigs=[] means, csparameters has not been calculated before#
               # fgmatch=fail means, the factor groups do not match any of the 	#
               #		previous ones			                #
               ###							      ###
               then
                newglobaldata.fgsigs[1].sigs:=TestedSignaturesRelative(sigs,newdata,maxtest,moretest);
                newdata.sigs:=newglobaldata.fgsigs[1].sigs;	#for this run
                if newglobaldata.fgsigs[1].sigs=[]
                   then 
                    Info(InfoRDS,1,"Signature equations have no solution.");
                    isbadforbiddenset:=true;
                fi;
                if oldfgsigs<>[]
                   then
                    Append(oldfgsigs,newglobaldata.fgsigs);	#Pointers! Beware!
                else      
                    if IsBound(globalSigData[Usize])
                       then
                        Add(globalSigData[Usize],newglobaldata);
                    else
                        globalSigData[Usize]:=[newglobaldata];
                    fi;
                fi;
            else    #old data can be used. I saved some work!
                newdata.sigs:=fgmatch.sigs;
            fi;
            Add(normalSubgroupsData,
                rec(subgroup:=nsg,
                              sigs:=newdata.sigs,
                              cosets:=newdata.cosets,
                              #cosetsgroup:=newdata.cosetsgroup
                              )
                              );	#data for this time.
        fi;
    od;
    if isbadforbiddenset
       then
        return fail;
    else
        return normalSubgroupsData;
    fi;
end);


#############################################################################
##
##  Here are some methods for ordered signatures from quotient images
## 
#############################################################################

#############################################################################
##
#O MultiplicityInvariantLargeLambda( <set>,<Gdata>)
## 
InstallMethod(MultiplicityInvariantLargeLambda,
        [IsDenseList,IsRecord],
        function(set,Gdata)
    local   mults;
    mults:=List(Collected(AllPresentables(set,Gdata)),i->i[2]);
    return Collected(mults);
end);

#############################################################################
##
#O NormalSgsForQuotientImages(<forbidden>,<Gdata>)
##
InstallMethod(NormalSgsForQuotientImages,
        [IsMagmaWithInverses,IsRecord],
        function(forbidden,Gdata)
    local   normals,  list;
    
    normals:=Filtered(NormalSubgroups(Gdata.G),n->IsSubgroup(forbidden,n) 
                     and not Order(n)=1 
                     and not n=forbidden);
    list:=PartitionByFunction(normals,n->IdSmallGroup(FactorGroup(Gdata.G,n)));
    return Set(list,Representative);
end);


InstallMethod(NormalSgsForQuotientImages,
        [IsDenseList,IsRecord],
        function(forbidden,Gdata)
    local   forb,  normals,  list;
    if IsListOfIntegers(forbidden)
       then
        forb:=PermList2GroupList(forbidden,Gdata);
    else
        forb:=forbidden;
    fi;
    normals:=Filtered(NormalSubgroups(Gdata.G),n->IsSubset(forb,n) 
                     and not Order(n)=1 
                     and not Size(n)=Size(forb));
    list:=PartitionByFunction(normals,n->IdSmallGroup(FactorGroup(Gdata.G,n)));
    return Set(list,Representative);
end);
        
#############################################################################
##
#O DataForQuotientImage(<normal>,<forbidden>,<k>,<lambda>,<Gdata>);
##
InstallMethod(DataForQuotientImage,
        [IsMagmaWithInverses,IsMagmaWithInverses,IsPosInt,IsPosInt,IsRecord],
        function(normal,forbidden,k,lambda,Gdata)
    return DataForQuotientImage(normal,Set(forbidden),k,lambda,Gdata);
end);

InstallMethod(DataForQuotientImage,
        [IsMagmaWithInverses,IsDenseList,IsPosInt,IsPosInt,IsRecord],
        function(normal,forbidden,k,lambda,Gdata)
    local   forb,  phi,  cosets,  fGroup,  auts,  fauts,  fGroupData,  
            fforbidden,  flambda;
    
    if not IsSubgroup(Gdata.G,normal) or not IsNormal(Gdata.G,normal)
       then
        Error("`normal' must be a normal subgroup ");
    fi;
    if IsListOfIntegers(forbidden)
       then
        forb:=PermList2GroupList(forbidden,Gdata);
    else
        forb:=forbidden;
    fi;
    if not IsSubset(forb,normal)
       then
        Error("normal subgroup must lie in the forbidden set");
    fi;
    phi:=NaturalHomomorphismByNormalSubgroup(Gdata.G,normal);
    cosets:=PartitionByFunction(Gdata.Glist,x->x^phi);
        # represent cosets by lists of integers:
    Apply(cosets,i->Set(GroupList2PermList(i,Gdata)));
          
    fGroup:=ImagesSource(phi);
    auts:=Intersection(Stabilizer(Gdata.A,Set(normal),OnSets),
                  Stabilizer(Gdata.A,Set(forb),OnSets));
    fauts:=Group(Set(GeneratorsOfGroup(auts),g->g^phi));
    fGroupData:=PermutationRepForDiffsetCalculations(fGroup,fauts);;
    fforbidden:=Image(phi,forb);
    flambda:=Order(normal)*lambda;
    
    return rec(Gdata:=fGroupData,forbidden:=fforbidden,lambda:=flambda);
end);

#############################################################################
##
#O OrderedSigsFromQuotientImages(<fGroupData>,<qimages>,<forbidden>,<normal>,<Gdata>)
##
InstallMethod(OrderedSigsFromQuotientImages,
        [IsRecord,IsDenseList,IsObject,IsMagmaWithInverses,IsRecord],
        function(fGroupData,qimages,forbidden,normal,Gdata)
    local   fforbiddens,  fforbidden,  fAut,  epi,  fgroup,  iso,  
            phi,  forbiddenimage,  psi,  phi2,  sigs,  pos,  set,  i,  
            cosets,  cosetsindices,  unsortingPerm;
    
    if not IsSubgroup(Gdata.G,normal)
       then
        Error("`normal' must be a normal subgroup of `Gdata'");
    fi;
    # calculate the forbidden set in the factor group:
    fforbiddens:=Set(qimages,i->Set(Difference([2..Size(fGroupData.Glist)],AllPresentables(i,fGroupData))));
    if not Size(fforbiddens)=1
       then
        Error("`qimages' have different forbidden sets!");
    else
        fforbidden:=PermList2GroupList(Union([1],fforbiddens[1]),fGroupData);
        if Size(Group(fforbidden))=Size(fforbidden)
           then
            fforbidden:=Group(fforbidden);
        else
            fforbidden:=Set(fforbidden);
        fi;
    fi;
    
    fAut:=AutomorphismGroup(fGroupData.G);
    
    epi:=NaturalHomomorphismByNormalSubgroup(Gdata.G,normal);
    fgroup:=ImagesSource(epi);
    iso:=IsomorphismGroups(fgroup,fGroupData.G);
    if iso<>fail
       then
        phi:=epi*iso;
        if IsGroup(normal)
           then
            forbiddenimage:=Image(phi,forbidden);
        else
            forbiddenimage:=Set(Image(phi,Set(forbidden)));
        fi;
        if not forbiddenimage=fforbidden
           then
            if IsGroup(normal)
               then
                psi:=RepresentativeAction(fAut,forbiddenimage,fforbidden,OnSubgroups);
            else
                psi:=RepresentativeAction(fAut,forbiddenimage,fforbidden,OnSets);
            fi;
        else
            psi:=phi;
        fi;

        if psi=fail
           then
            Error("forbidden set does not match!");
        elif psi<>phi
          then
            phi2:=phi*psi;
        else
            phi2:=phi;
        fi;
    else
        Error("normal subgroup does not match!");
    fi;
    
    sigs:=List(qimages,i->ListWithIdenticalEntries(Size(fGroupData.Glist),0));
    for pos in [1..Size(qimages)]
      do
        set:=Union(qimages[pos],[1]);
        for i in set
          do
            sigs[pos][i]:=sigs[pos][i]+1;
        od;
    od;  
    
    cosets:=PartitionByFunction([1..Size(Gdata.Glist)],i->PositionSet(fGroupData.Glist,Gdata.Glist[i]^phi2));
    Apply(cosets,Set);
    Sort(cosets);
    # if the cosets are not ordered in the same way as the elements of 
    # the factor group, we will have to permute the ordered signatures.
    # So now we claculate the according permutation (in most cases, this 
    # will be the trivial one)
    cosetsindices:=List(cosets,i->PositionSet(fGroupData.Glist,(PermList2GroupList([i[1]],Gdata)[1])^phi2));
    unsortingPerm:=Inverse(SortingPerm(cosetsindices)); 
    
    # Sort the signatures according to the order of cosets:
    Apply(sigs,s->Permuted(s,unsortingPerm));
    
    return rec(orderedSigs:=sigs,cosets:=cosets,fg:=fGroupData.G,fgaut:=fAut,Nfg:=fforbidden);
end);



#############################################################################
##
#O  OrderedSigInvariant( < prd >,<data>)      calculates the signature of a partial relative difference set.
##
InstallMethod(OrderedSigInvariant,
        [IsDenseList,IsDenseList],
        function(set,cosets_sigs)
    local   lset,  return_list,  coset_data,  setsig;

    if cosets_sigs=[] 
       then 
        return [];
    fi;
    if IsListOfIntegers(set) or not (IsSet(set) and 
               CategoryCollections(IS_REC)(cosets_sigs))
       then 
        TryNextMethod();
    fi;

    if not set[1]^0 in set
       then
        lset:=Union(set,[set[1]^0]);
    else
        lset:=set;
    fi;

    return_list:=[];
    for coset_data in cosets_sigs
      do
        setsig:=OrderedCosetSignatureOfSet(lset,coset_data.cosets);

        if ForAll(coset_data.orderedSigs,i->(not Pointwiseleq(setsig,i)))
           then
            return fail;
        else 
            Add(return_list,setsig);
        fi;
    od;
    return_list:=Collected(return_list);
    return return_list;
end);
##########
InstallOtherMethod(OrderedSigInvariant,
        [IsDenseList,IsDenseList],
        function(set,cosets_sigs)
    local lset,coset_data,setsig,return_list; 

    if cosets_sigs=[] 
       then 
        return [];
    fi;
    if not IsListOfIntegers(set) or not (IsSet(set) and 
               CategoryCollections(IS_REC)(cosets_sigs))
       then 
        TryNextMethod();
    fi;

    if not 1 in set
       then
        lset:=Union(set,[1]);
    else
        lset:=set;
    fi;

    return_list:=[];
    for coset_data in cosets_sigs
      do
        setsig:=OrderedCosetSignatureOfSet(lset,coset_data.cosets);
        if ForAll(coset_data.orderedSigs,i->(not Pointwiseleq(setsig,i)))
           then
            return fail;
        else 
            Add(return_list,setsig);
        fi;
    od;
    return_list:=Collected(return_list);
    return return_list;
end);

#############################################################################
##
#O MatchingFGDataForOrderedSigs(<forbidden>,<group>,<normalsgs>,<fgdata>)
## 
InstallOtherMethod(MatchingFGDataForOrderedSigs,
        [IsObject,IsRecord,IsDenseList,IsDenseList],
        function(forbidden,Gdata,normalsgs,fgdata)
    local   forb;
    if IsListOfIntegers(forbidden)
       then
        forb:=PermList2GroupList(forbidden,Gdata);
    fi;
    if not IsSubset(Gdata.Glist,forb)
       then
        Error("forbidden set must be in <Gdata.Glist>");
    fi;
    return MatchingFGDataForOrderedSigs(forb,Gdata,normalsgs,fgdata);
end);

#############################################################################
##
#O MatchingFGDataForOrderedSigs(<forbidden>,<group>,<normalsgs>,<fgdata>)
## 
InstallMethod(MatchingFGDataForOrderedSigs,
        [IsObject,IsRecord,IsDenseList,IsDenseList],
        function(forbidden,Gdata,normalsgs,fgdata)
    local   group,  isgroup,  returnlist,  forb,  normal,  phi,  
            quotient,  quotid,  filteredfgdata,  fg,  psi,  forbimage,  
            rho;
    group:=Gdata.G;
    isgroup:=false;
    returnlist:=[];
    if IsGroup(forbidden)
       then
        forb:=forbidden;
        isgroup:=true;
    elif IsDenseList(forbidden) and Size(Group(forbidden))=Size(forbidden)
      then
        forb:=Group(forbidden);
        isgroup:=true;
    elif IsDenseList(forbidden) and IsListOfIntegers(forbidden)
      then
        TryNextMethod();
    elif IsDenseList(forbidden) and IsSubset(Gdata.Glist,forbidden)
      then
        forb:=forbidden;
        isgroup:=false;
    else
        Error("forbidden set is not valid");
    fi;
    for normal in normalsgs
      do
        phi:=NaturalHomomorphismByNormalSubgroup(group,normal);
        quotient:=ImagesSource(phi);
        quotid:=IdSmallGroup(quotient);
        filteredfgdata:=Filtered(fgdata,i->IdSmallGroup(i.fg)=quotid);
        for fg in filteredfgdata
          do
            psi:=IsomorphismGroups(quotient,fg.fg);
            if isgroup
               then 
                forbimage:=Image(phi*psi,forb);
            else
                forbimage:=Set(Image(phi*psi,forb));
            fi;
            if forbimage=fg.Nfg
               then
                Add(returnlist,rec(nomral:=normal,hom:=phi*psi,sigdata:=fg));
            else
                if isgroup 
                   then
                    rho:=RepresentativeAction(fg.fgaut,forbimage,fg.Nfg,OnSubgroups);
                else
                    rho:=RepresentativeAction(fg.fgaut,forbimage,fg.Nfg,OnSets);
                fi;
                if rho<>fail
                   then
                    Add(returnlist,rec(normal:=normal,hom:=phi*psi*rho,sigdata:=fg));
                fi;
            fi;
        od;
    od;
    return returnlist;
end);

#############################################################################
##
#E   ........ ENDE
##
