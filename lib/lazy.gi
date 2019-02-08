#############################################################################
##
#W lazy.gi 			 RDS Package		 Marc Roeder
##
##  Some black-box functions for quick-and-dirty claculations
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
#O IsDiffset(<diffset>,[<forbidden>],<Gdata>,[<lambda>])
##
InstallMethod(IsDiffset,[IsDenseList,IsRecord],
        function(diffset,Gdata)
    return IsDiffset(diffset,[],Gdata,1);
end);

InstallMethod(IsDiffset,[IsDenseList,IsRecord,IsPosInt],
        function(diffset,Gdata,lambda)
    return IsDiffset(diffset,[],Gdata,lambda);
end);

InstallMethod(IsDiffset,[IsDenseList,IsDenseList,IsRecord],
        function(diffset,forbidden,Gdata)
    return IsDiffset(diffset,forbidden,Gdata,1);
end);

InstallMethod(IsDiffset,[IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,forbidden,Gdata,lambda)
    local   pres;
    if not IsSubset([1..Size(Gdata.Glist)],Union(forbidden,diffset))
       then
       Error("<forbidden> and <diffset> must consist of integers less than the group size"); 
    fi;
    pres:=Collected(AllPresentables(diffset,Gdata));
    if Set(pres,i->i[1])=Difference([2..Size(Gdata.Glist)],forbidden) 
       and Set(pres,i->i[2])=[lambda]
       then
        return true;
    else
        return false;
    fi;
end);

#############################################################################
##
#O IsPartialDiffset(<diffset>,[<forbidden>],<Gdata>,[<lambda>])
##
InstallMethod(IsPartialDiffset,[IsDenseList,IsRecord],
        function(diffset,Gdata)
    return IsPartialDiffset(diffset,[],Gdata,1);
end);

InstallMethod(IsPartialDiffset,[IsDenseList,IsRecord,IsPosInt],
        function(diffset,Gdata,lambda)
    return IsPartialDiffset(diffset,[],Gdata,lambda);
end);

InstallMethod(IsPartialDiffset,[IsDenseList,IsDenseList,IsRecord],
        function(diffset,forbidden,Gdata)
    return IsPartialDiffset(diffset,forbidden,Gdata,1);
end);

InstallMethod(IsPartialDiffset,[IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,forbidden,Gdata,lambda)
    local   pres;
    if not IsSubset([1..Size(Gdata.Glist)],Union(forbidden,diffset))
       then
       Error("<forbidden> and <diffset> must consist of integers less than the group size"); 
    fi;
    pres:=Collected(AllPresentables(diffset,Gdata));
    if IsSubset(Difference([2..Size(Gdata.Glist)],forbidden),Set(pres,i->i[1])) 
       and Set(pres,i->i[2])<=[lambda]
       then
        return true;
    else
        return false;
    fi;
end);


#############################################################################
##
#O IsDiffset(<diffset>,[<forbidden>],<group>,[<lambda>])
##
InstallMethod(IsDiffset,[IsDenseList,IsGroup],
        function(diffset,group)
    return IsDiffset(diffset,[],group,1);
end);

InstallMethod(IsDiffset,[IsDenseList,IsGroup,IsPosInt],
        function(diffset,group,lambda)
    return IsDiffset(diffset,[],group,lambda);
end);

InstallMethod(IsDiffset,[IsDenseList,IsDenseList,IsGroup],
        function(diffset,forbidden,group)
    return IsDiffset(diffset,forbidden,group,1);
end);

InstallMethod(IsDiffset,[IsDenseList,IsDenseList,IsGroup,IsPosInt],
        function(diffset,forbidden,group,lambda)
    local   iso,  Gdata;
    if not (IsSubset(group,forbidden) and IsSubset(group,diffset))
       then
        Error("<forbidden> and <diffset> must be contained in <group>");
    fi;
    if Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
    else
        iso:=IdentityMapping(group);
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    return IsDiffset(GroupList2PermList(Image(iso,diffset),Gdata),
                   Set(GroupList2PermList(Image(iso,forbidden),Gdata)),
                   Gdata,
                   lambda);
end);



#############################################################################
##
#O IsPartialDiffset(<diffset>,[<forbidden>],<group>,[<lambda>])
##
InstallMethod(IsPartialDiffset,[IsDenseList,IsGroup],
        function(diffset,group)
    return IsPartialDiffset(diffset,[],group,1);
end);

InstallMethod(IsPartialDiffset,[IsDenseList,IsGroup,IsPosInt],
        function(diffset,group,lambda)
    return IsPartialDiffset(diffset,[],group,lambda);
end);

InstallMethod(IsPartialDiffset,[IsDenseList,IsDenseList,IsGroup],
        function(diffset,forbidden,group)
    return IsPartialDiffset(diffset,forbidden,group,1);
end);

InstallMethod(IsPartialDiffset,[IsDenseList,IsDenseList,IsGroup,IsPosInt],
        function(diffset,forbidden,group,lambda)
    local   iso,  Gdata;
    if not (IsSubset(group,forbidden) and IsSubset(group,diffset))
       then
        Error("<forbidden> and <diffset> must be contained in <group>");
    fi;
    if Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
    else
        iso:=IdentityMapping(group);
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    return IsPartialDiffset(GroupList2PermList(Image(iso,diffset),Gdata),
                   Set(GroupList2PermList(Image(iso,forbidden),Gdata)),
                   Gdata,
                   lambda);
end);


#############################################################################
##
#F StartsetsInCoset(<ssets>,<coset>,<forbiddenSet>,<aim>,<autlist>,<sigdat>,<data>,<lambda>)
##
InstallGlobalFunction("StartsetsInCoset",
        function(ssets,coset,forbiddenSet,aim,autlist,sigdat,Gdata,lambda)
    local   Np,  cosetP,  localssets,  comps,  timetmp,  partfunc;
    
    if IsListOfIntegers(forbiddenSet)
       then
        Np:=Set(forbiddenSet);
    elif IsSubset(Gdata.G,forbiddenSet)
      then
        Np:=GroupList2PermList(Set(forbiddenSet),Gdata);
    else
        Error("forbidden set has the wrong form!");
    fi;
    if IsListOfIntegers(coset)
      then
        cosetP:=coset;
    elif IsSubset(Gdata.G,coset)
      then
        cosetP:=GroupList2PermList(Set(coset),Gdata);
    else
        Error("normal subgroup has the wrong form!");
    fi;
        if not (IsInt(aim) and IsDenseList(autlist) and IsList(sigdat) and ForAll(sigdat,IsRecord))
       then
        Error("at least one of aim/autlist/sigdat is o wrong type");
    fi;
    if ssets<>[] and Size(ssets[1])>=aim 
       then 
        Error("startsets already too large!");
    elif ssets<>[] and not Size(Set(ssets,Size))=1
      then
        Error("startsets are not of the same size");
    fi;
       
    if not ForAll(ssets,IsListOfIntegers) and ForAll(ssets,s->IsSubset(Gdata.Glist,s))
       then
        localssets:=List(ssets,s->GroupList2PermList(s,Gdata));
    elif ForAll(ssets,IsListOfIntegers)    
      then
        localssets:=StructuralCopy(ssets);
    fi;
    
    if not (IsInt(lambda) and 1<=lambda)
       then 
        Error("lambda must be an integer >=1");
    fi;
    
    if lambda>1 
       then
        partfunc:=function(set)
            local   multiplicities,  siginvar;
            multiplicities:=List(Collected(AllPresentables(set,Gdata)),i->i[2]);
            siginvar:=SigInvariant(Union(set,[1]),sigdat);
            return [Collected(multiplicities),siginvar];
        end;
    else
        partfunc:=function(set)
            return SigInvariant(Union(set,[1]),sigdat);
        end;
    fi;
    
    ## and now for the calculations:
    
    comps:=Difference(cosetP,Np); #the set of possible completions
    if localssets=[]              #generate initial startsets
       then                       # if none are given.
        localssets:=Set(Difference(cosetP,Np),i->[i]);
    elif ForAll(localssets,s->not s[Size(s)] in cosetP)
      then                        #raise startset length by 1, disregarding
        if lambda=1               # ordering of G.
           then
            localssets:=ExtendedStartsetsNoSort(localssets,comps,Np,aim,Gdata);
        else
            localssets:=ExtendedStartsetsNoSort(localssets,comps,Np,aim,Gdata,lambda);
        fi;
    elif ForAll(localssets,s->s[Size(s)] in cosetP)
      then                        #the above step seems already to be done.
    else                          # we do nothing here
        Error("these startsets look strange!");
    fi;
    localssets:=ReducedStartsets(localssets,autlist,partfunc,Gdata.diffTable);
            
    #now startsets are completed using the ordering of G
    # for <lambda>=1 there is a special function.
    
    if lambda=1
       then
        while localssets<>[] and Size(localssets[1])<aim
          do
            timetmp:=Runtime();
            localssets:=ExtendedStartsets(localssets,comps,Np,aim,Gdata);
            localssets:=ReducedStartsets(localssets,autlist,partfunc,Gdata.diffTable);
            Info(InfoRDS,1,"-->",Size(localssets)," @", StringTime(Runtime()-timetmp));
        od;
    else
        while localssets<>[] and Size(localssets[1])<aim
          do
            timetmp:=Runtime();
            localssets:=ExtendedStartsets(localssets,comps,Np,aim,Gdata,lambda);
            localssets:=ReducedStartsets(localssets,autlist,partfunc,Gdata.diffTable);
            Info(InfoRDS,1,"-->",Size(localssets)," @", StringTime(Runtime()-timetmp));
        od;
    fi;
    return localssets;
end);
        



#############################################################################
##
#F SignatureData(<Gdata>,<globalSigData>,<forbiddenSet>,k,lambda,maxtest)
##
InstallGlobalFunction("SignatureData",
        function(Gdata,forbiddenSet,k,lambda,maxtest)
    
    local   moretest,  discardedGlobalData,  normals;
    if not IsRecord(Gdata) and IsInt(k) and IsInt(lambda) and IsInt(maxtest)
       then
        Error("wrong type of parameters");
    fi;
    moretest:=true;
    discardedGlobalData:=[];
    normals:=Filtered(NormalSubgroups(Gdata.G),g->Size(g) in [RootInt(Size(Gdata.G))..Size(Gdata.G)-1]);
    return SignatureDataForNormalSubgroups(normals,discardedGlobalData,forbiddenSet,Gdata,[k,lambda,maxtest,moretest]);
end);


#############################################################################
##
#F NormalSgsHavingAtMostKSigs(<sigdata>,<n>,<lengthlist>)
##
InstallGlobalFunction("NormalSgsHavingAtMostNSigs",
        function(sigdat,n,lengthlist)
          
    return Set(Filtered(sigdat,s->Size(s.sigs)<=n and Size(s.sigs[1]) in lengthlist),i->rec(subgroup:=i.subgroup,sigs:=i.sigs));
end);


#############################################################################
##
#F SuitableAutomorphismsForReduction(<Gdata>,<normalsg>)
##
##
InstallGlobalFunction("SuitableAutomorphismsForReduction",
        function(Gdata,normalsg)
    local   cosets;
    
    cosets:=RightCosets(Gdata.G,normalsg);
    Apply(cosets,c->GroupList2PermList(Set(c),Gdata));
    return [Intersection(Set(cosets,c->Stabilizer(Gdata.Ai,c,OnSets)))];
end);


#############################################################################
##
#E  END
##