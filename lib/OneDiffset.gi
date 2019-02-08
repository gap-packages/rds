#############################################################################
##
#W OneDiffset.gi 			 RDS Package		 Marc Roeder
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
#O  OneDiffset(<partial>,<completions>,<aim>,<forbidden>,<Gdata>,<lambda>)  calculates ordinary difference sets containing the partial difference set <partial>.
##
InstallMethod(OneDiffset,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,k,forbidden,data,lambda)
    
    local   FindDiffsetsB,  FindDiffsetsLambda,  found,  
            allpres,  setcomps;
    
    #There are two recursive functions. One for lambda=1 and one for other
    # lambda.
    #First, the lambda=1 case:
    
    FindDiffsetsB:=function(diffset,allpres,completions,forbidden,k,diffTable)
        local   depth,  i,  diff2,  newdiff_i_pres,  diff2pres,  
                newcomps,  completions_for_diff_i,  pos,  c,  tmppres,  
                found;

        depth:=Size(diffset);
        if depth+1=k
           then
            if completions<>[]
               then
                return Concatenation(diffset,[completions[1]]);
            else
                return [];
            fi;
        else
            for i in completions{[1..Size(completions)-(k-depth-1)]}
              do
                diff2:=Concatenation(diffset,[i]);
                newdiff_i_pres:=NewPresentables(diffset,i,diffTable);
                diff2pres:=Union(allpres,newdiff_i_pres);
                newcomps:=[];
                completions_for_diff_i:=Difference(completions, newdiff_i_pres);
                pos:=PositionSorted(completions_for_diff_i,i);
                
                # note that completions_for_diff_i never contains i.
                # So pos always points to the next larger element (if existant)
                
                completions_for_diff_i:=completions_for_diff_i{[pos..Size(completions_for_diff_i)]};
                for c in completions_for_diff_i
                  do
                    tmppres:=NewPresentables(diff2,c,diffTable);
                    if IsDuplicateFree(tmppres) 
                       and ForAll(tmppres,p->not((p in diff2pres) or (p in forbidden)))
                       then
                        Add(newcomps,c);
                    fi;
                od;
                if (depth+1+Size(newcomps)>=k)
                   then
                    ## RECURSION !
                    found:=CallFuncList(FindDiffsetsB,
                            [diff2,diff2pres,AsSet(newcomps),
                             forbidden,k,diffTable]); 
                    if found<>[]
                       then
                        return found;
                    fi;
                fi;         ## in all other cases, the next i is processed
            od;
        fi;
        return [];    
    end;
    
    #######
    #And now for lambda>1.
    #######
    
    FindDiffsetsLambda:=function(diffset,allpres,completions,forbidden,k,diffTable,lambda)
        local   depth,  i,  diff2,  newdiff_i_pres,  diff2pres,  
                newcomps,  c,  tmppres,  found;
  
        depth:=Size(diffset);
        if depth+1=k
           then
            return Concatenation(diffset,[completions[1]]);
        else
            for i in completions{[1..Size(completions)-(k-depth-1)]}
              do
                diff2:=Concatenation(diffset,[i]); 
            
                # this is the new partial difference set
                # now we will calculate the parameters for recursion.
                
                newdiff_i_pres:=NewPresentables(diffset,i,diffTable);
                diff2pres:=AsSortedList(Concatenation(allpres,newdiff_i_pres));
                
                # the list of all quotients of <diff2> (not containing 1)
                
                newcomps:=[]; #the set of possible completions for <diff2>.
                for c in Filtered(completions,c->i<c) #completions_for_diff_i
                  do
                    tmppres:=NewPresentables(diff2,c,diffTable);
                    if Intersection(tmppres,forbidden)=[]
                       and Maximum(Set(Collected(Concatenation(tmppres,diff2pres)),c->c[2]))<=lambda
                       then
                        Add(newcomps,c);
                    fi;
                od;
                if (depth+1+Size(newcomps)>=k)
                   then
#                if not Maximum(Set(Collected(AllPresentables(diff2,diffTable)),i->i[2]))<=lambda
#                   then
#                    Error("Something is terribly wrong!");
#                fi;
                    found:=CallFuncList(FindDiffsetsLambda,
                            [diff2,diff2pres,AsSet(newcomps),
                             forbidden,k,diffTable,lambda]); ## RECURSION !
                    if found<>[]
                       then
                        return found;
                    fi;
                fi;  ## in all other cases, the next i is processed
            od;
        fi;
        return [];
    end;
    
    ### Initialize and decide which recursion should be used:
    if not IsPartialDiffset(diffset,forbidden,data,lambda)
       then
        return [];
    elif Size(diffset)=k
      then
        return diffset;
    fi;
    
    if Size(diffset)=k
       then
        if IsPartialDiffset(diffset,forbidden,data,lambda)
           then
            return diffset;
        else
            return [];
        fi;
    fi;
    
    allpres:=AllPresentables(diffset,data.diffTable);
    if lambda>1
       then
        setcomps:=RemainingCompletions(diffset,completions,forbidden,data.diffTable,lambda);
        found:=CallFuncList(FindDiffsetsLambda,[diffset,allpres,setcomps,forbidden,k,data.diffTable,lambda]);
    elif lambda=1
      then
        setcomps:=RemainingCompletions(diffset,completions,forbidden,data.diffTable);
        found:=CallFuncList(FindDiffsetsB,[diffset,allpres,setcomps,forbidden,k,data.diffTable]);
    else
        Error("lambda must be a positive integer");
    fi;
    return found;
end);

#############################################################################
#############################################################################


#############################################################################
##
#O OneDiffset(<group>,[<lambda>])
#O OneDiffset(<Gdata>,[<lambda>])
##
InstallMethod(OneDiffset,[IsGroup],
        function(group)
    local   iso,  inviso,  Gdata,  returnval;
    if Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnval:=OneDiffset([],[1],Gdata,1);
    return Image(inviso,PermList2GroupList(returnval,Gdata));
end);

InstallMethod(OneDiffset,[IsRecord],
        function(Gdata)
    return OneDiffset([],[1],Gdata,1);
end);

InstallMethod(OneDiffset,[IsGroup,IsPosInt],
        function(group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:=OneDiffset([],[1],Gdata,lambda);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);

InstallMethod(OneDiffset,[IsRecord,IsPosInt],
        function(Gdata,lambda)
    return OneDiffset([],[1],Gdata,lambda);
end);

#############################################################################
##
#O OneDiffset(<partial>,<group>,[<lambda>])
#O OneDiffset(<partial>,<Gdata>,[<lambda>])
##
InstallMethod(OneDiffset,[IsDenseList,IsGroup],
        function(partial,group)
    local   iso,  inviso,  Gdata,  returnset;
    if not IsSubset(group,partial)
       then
        Error("partial set must be subset of the group");
    fi;
    if partial=[] and Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:=OneDiffset(GroupList2PermList(Image(iso,partial),Gdata),
                   [],
                   Gdata,
                   1);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);

InstallMethod(OneDiffset,[IsDenseList,IsRecord],
        function(partial,Gdata)
    return OneDiffset(partial,[1],Gdata,1);
end);

InstallMethod(OneDiffset,[IsDenseList,IsGroup,IsPosInt],
        function(partial,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not IsSubset(group,partial)
       then
        Error("partial set must be subset of the group");
    fi;
    if partial=[] and Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:=OneDiffset(GroupList2PermList(Image(iso,partial),Gdata),
                   [],
                   Gdata,
                   lambda);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);

InstallMethod(OneDiffset,[IsDenseList,IsRecord,IsPosInt],
        function(partial,Gdata,lambda)
    return OneDiffset(partial,[1],Gdata,lambda);
end);


#############################################################################
##
#O OneDiffset(<partial>,<forbidden>,<group>,[<lambda>])
#O OneDiffset(<partial>,<forbidden>,<Gdata>,[<lambda>])
##
InstallMethod(OneDiffset,[IsDenseList,IsDenseList,IsGroup],
        function(partial,forbidden,group)
    return OneDiffset(partial,forbidden,group,1);
end);

InstallMethod(OneDiffset,[IsDenseList,IsDenseList,IsGroup,IsPosInt],
        function(partial,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not (IsSubset(group,partial) and IsSubset(group,forbidden))
       then
        Error("partial set and forbidden set must be subsets of the group");
    fi;    
    if partial=[] and Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));    
    returnset:= OneDiffset(GroupList2PermList(Image(iso,partial),Gdata),
                        GroupList2PermList(Image(iso,forbidden),Gdata),
                        Gdata,
                        lambda);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);

InstallMethod(OneDiffset,[IsDenseList,IsDenseList,IsRecord],
        function(partial,forbidden,Gdata)
    return OneDiffset(partial,forbidden,Gdata,1);
end);

InstallMethod(OneDiffset,[IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(partial,forbidden,Gdata,lambda)
    local   aim;
    if not 1 in forbidden
       then
        Add(forbidden, 1);
    fi;
    aim:=Sqrt(lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4)-1/2;
    if not IsPosInt(aim)
       then
        Info(InfoRDS,1,"group order of the wrong form");
        return [];
    else
        return OneDiffset(partial,aim, forbidden,Gdata,lambda);
    fi;
end);



#############################################################################
##
#O OneDiffset(<partial>, <aim>, <forbidden>, <group>, [<lambda>])
#O OneDiffset(<partial>, <aim>, <forbidden>, <Gdata>, [<lambda>])
##
InstallMethod(OneDiffset,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup],
        function(partial,aim,forbidden,group)
    return OneDiffset(partial,aim,forbidden,group,1);
end);
InstallMethod(OneDiffset,[IsDenseList,IsPosInt,IsDenseList,IsRecord],
        function(partial,aim,forbidden,Gdata)
    return OneDiffset(partial,aim,forbidden,Gdata,1);
end);

InstallMethod(OneDiffset,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt],
        function(partial,aim,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not (IsSubset(group,partial) and IsSubset(group,forbidden))
       then
        Error("partial set and forbidden set must be subsets of the group");
    fi;    
    if partial=[] and Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));    
    returnset:= OneDiffset(GroupList2PermList(Image(iso,partial),Gdata),
                        aim,
                        Set(GroupList2PermList(Image(iso,forbidden),Gdata)),
                        Gdata,
                        lambda);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);

InstallMethod(OneDiffset,[IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(partial,aim,forbidden,Gdata,lambda)
    local  square, completions,  returnset,  list,  i;
    if not 1 in forbidden
       then
        Add(forbidden, 1);
    fi;
    square:=lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4;
    if aim>RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2
# if aim>Sqrt(lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4)-1/2
       then
        Info(InfoRDS,1,"<aim> too large. No difference sets");
        return [];
    fi;
    if partial<>[]
       then
        completions:=RemainingCompletionsNoSort(partial,[1..Size(Gdata.Glist)],forbidden,Gdata,lambda);
        return OneDiffset(partial,completions,aim,forbidden,Gdata,lambda);
    else
        returnset:=[];
        list:=Reversed(Difference([2..Size(Gdata.Glist)],forbidden));
        while returnset=[] and list<>[]
          do
            i:=Remove(list);
            returnset:=OneDiffset([i],
                               [3..Size(Gdata.Glist)],aim,forbidden,Gdata,lambda);
        od;
        return returnset;    
    fi;
end);



#############################################################################
## Here are the NoSort versions:
#############################################################################


#############################################################################
##
#O OneDiffsetNoSort(<partial>,<group>,[<lambda>])
#O OneDiffsetNoSort(<partial>,<Gdata>,[<lambda>])
##
InstallMethod(OneDiffsetNoSort,[IsDenseList,IsGroup],
        function(partial,group)
    return OneDiffsetNoSort(partial,group,1);
end);
InstallMethod(OneDiffsetNoSort,[IsDenseList,IsRecord],
        function(partial,Gdata)
    return OneDiffsetNoSort(partial,Gdata,1);
end);

InstallMethod(OneDiffsetNoSort,[IsDenseList,IsGroup,IsPosInt],
        function(partial,group,lambda)
    local   square, aim;
    square:=lambda*(Size(group)-1+1/4);
    aim:=RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2;
#    aim:=Sqrt(lambda*(Size(group)-1+1/4))-1/2;
    return OneDiffsetNoSort(partial,Set(group),aim,[],group,lambda);
end);
    
InstallMethod(OneDiffsetNoSort,[IsDenseList,IsRecord,IsPosInt],
        function(partial,Gdata,lambda)
    local   square, aim;
    square:=lambda*(Size(Gdata.Glist)-1+1/4);
    aim:=RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2;
#    aim:=Sqrt(lambda*(Size(Gdata.Glist)-1+1/4))-1/2;
    return OneDiffsetNoSort(partial,[1..Size(Gdata.Glist)],aim,[],Gdata,lambda);
end);


#############################################################################
##
#O OneDiffsetNoSort(<partial>,[<completions>],<aim>,[<forbidden>],<group>,[<lambda>])
#O OneDiffsetNoSort(<partial>,[completions],<aim>,[<forbidden>],<Gdata>,[<lambda>])
##
#############################################################################
## first (<partial>,<aim>,G/Gdata,[<lambda>]):
##
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsGroup],
        function(partial,aim,group)
    return OneDiffsetNoSort(partial,aim,[],group,1);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsRecord],
        function(partial,aim,Gdata)
    return OneDiffsetNoSort(partial,aim,[],Gdata,1);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsGroup,IsPosInt],
        function(partial,aim,group,lambda)
    return OneDiffsetNoSort(partial,aim,[],group,lambda);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsRecord,IsPosInt],
        function(partial,aim,Gdata,lambda)
    return OneDiffsetNoSort(partial,aim,[],Gdata,lambda);
end);

#############################################################################
## now (<partial>,<aim>,<forbidden>,G/Gdata,[<lambda>])
##
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup],
        function(partial,aim,forbidden,group)
    return OneDiffsetNoSort(partial,aim,forbidden,group,1);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsRecord],
        function(partial,aim,forbidden,Gdata)
    return OneDiffsetNoSort(partial,aim,forbidden,Gdata,1);
end);

InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt],
        function(partial,aim,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not (IsSubset(group,partial) and IsSubset(group,forbidden))
       then
        Error("partial set and forbidden set must be subsets of the group");
    fi;
    if Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:= OneDiffsetNoSort(GroupList2PermList(Image(iso,partial),Gdata),
                        aim,
                        GroupList2PermList(Image(iso,forbidden),Gdata),
                        Gdata,lambda);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);

InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(partial,aim,forbidden,Gdata,lambda)
    return OneDiffsetNoSort(partial,[2..Size(Gdata.Glist)],aim,forbidden,Gdata,lambda);
end);



#############################################################################
## now (<partial>,<completions>,aim,G/Gdata,[<lambda>]
##
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsGroup],
        function(partial,completions,aim,group)
    return OneDiffsetNoSort(partial,completions,aim,[],group,1);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsGroup,IsPosInt],
        function(partial,completions,aim,group,lambda)
    return OneDiffsetNoSort(partial,completions,aim,[],group,lambda);
end);

InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsRecord],
        function(partial,completions,aim,Gdata)
    return OneDiffsetNoSort(partial,completions,aim,[],Gdata,1);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsRecord,IsPosInt],
        function(partial,completions,aim,Gdata,lambda)
    return OneDiffsetNoSort(partial,completions,aim,[],Gdata,lambda);
end);
    
#############################################################################
## finally (<partial>,<completions>,aim,<forbidden>,G/Gdata,[<lambda>])
## 
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup],
        function(partial,completions,aim,forbidden,group)
    return OneDiffsetNoSort(partial,completions,aim,forbidden,group,1);
end);
InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord],
        function(partial,completions,aim,forbidden,Gdata)
    return OneDiffsetNoSort(partial,completions,aim,forbidden,Gdata,1);
end);

InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt],
        function(partial,completions,aim,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not (IsSubset(group,completions) and IsSubset(group,forbidden))
       then
        Error("partial set, forbidden set and completions must be subsets of the group");
    fi;
    if Set(group)[1]<>One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:= OneDiffsetNoSort(GroupList2PermList(Image(iso,partial),Gdata),
                        GroupList2PermList(Image(iso,completions),Gdata),
                        aim,
                        GroupList2PermList(Image(iso,forbidden),Gdata),
                        Gdata,lambda);
    return Image(inviso,PermList2GroupList(returnset,Gdata));
end);
    

InstallMethod(OneDiffsetNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(partial,completions,aim,forbidden,Gdata,lambda)
    local   square,  comps,  returnlist,  list,  c;
    if not (IsSubset([1..Size(Gdata.Glist)],completions) and IsSubset([1..Size(Gdata.Glist)],forbidden))
       then
        Error("forbidden set and completions must be subsets of the group");
    fi;
    if not IsPartialDiffset(partial,forbidden,Gdata,lambda)
       then
        return [];
    fi;
    square:=lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4;
    if aim>RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2
       then
        Info(InfoRDS,1,"<aim> too large. No difference sets");
        return [];
    fi;
    if partial=[]
       then
        comps:=Difference([2..Size(Gdata.Glist)],forbidden);
    else
        comps:=RemainingCompletionsNoSort(partial,completions,forbidden,Gdata,lambda);
    fi;
    returnlist:=[];
    list:=Reversed(Set(comps));
    while returnlist=[] and list<>[]
      do
        c:=Remove(list);
        returnlist:= OneDiffset(Concatenation(partial,[c]),comps,aim,forbidden,Gdata,lambda);
    od;
    return returnlist;
end);



#############################################################################
##
#E END
##
