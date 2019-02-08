#############################################################################
##
#W AllDiffsets.gi 			 RDS Package		 Marc Roeder
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
#O  AllDiffsets(<partial>,<completions>,<aim>,<forbidden>,<Gdata>,<lambda>)  calculates ordinary difference sets containing the partial difference set <partial>.
##
InstallMethod(AllDiffsets,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,k,forbidden,data,lambda)
    local   FindDiffsetsB,  FindDiffsetsLambda,  founddiffsets,  
            allpres,  allpres_collpair,  setcomps;
    
    #There are two recursive functions. One for lambda=1 and one for other
    # lambda.
    #First, the lambda=1 case:
    
    FindDiffsetsB:=function(diffset,allpres,completions,forbidden,k,founddiffsets,diffTable)
        local   depth,  i,  diff2,  newdiff_i_pres,  diff2pres,  
                newcomps,  completions_for_diff_i,  pos,  c,  tmppres;
        
        depth:=Size(diffset);
        if depth+1=k
           then
            Append(founddiffsets,List(completions,i->Concatenation(diffset,[i])));
        else
            for i in completions{[1..Size(completions)-(k-depth-1)]}
              do
                diff2:=Concatenation(diffset,[i]);
                newdiff_i_pres:=NewPresentables(diffset,i,diffTable);
                diff2pres:=AsSet(Concatenation(allpres,newdiff_i_pres));#Union(allpres,newdiff_i_pres);
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
                    #if not IsDuplicateFree(AllPresentables(diff2,diffTable))
                    #then
                    #Error("Something is terribly wrong!");
                    #fi;
                    ## RECURSION !
                    CallFuncList(FindDiffsetsB,
                            [diff2,diff2pres,AsSet(newcomps),
                              forbidden,k,founddiffsets,diffTable]); 
                fi;         ## in all other cases, the next i is processed
            od;
        fi;
    end;
    
    #######
    #And now for lambda>1.
    #######
    
    FindDiffsetsLambda:=function(diffset,allpres_collpair,completions,forbidden,k,founddiffsets,diffTable,lambda)
        local   updatedCollectedPair,  isCompatible,  depth,  i,  
                diff2,  newdiff_i_pres,  diff2pres_collpair,  
                newcomps,  ipos,  completions_for_diff_i,  c,  
                tmppres,  diff2pres,  pointer,  multiplicity;
        
        ## take [List(coll,i->i[1]), List(coll,i->i[2])]
        ## of coll=Collected(something)
        ## and a list <list> and return [Aelts2,Amult2] if no element
        ##  of Amult is larger then lambda and fail otherwise
        updatedCollectedPair:=function(collpair,list,lambda)
            local   listcoll,  newelts,  newmult,  mult_updated,  
                    newpair,  el,  mult,  pos,  updatedmult,  
                    returnelts,  returnmult;

            listcoll:=Collected(list);
            newelts:=[];
            newmult:=[];
            mult_updated:=ShallowCopy(collpair[2]);
            for newpair in listcoll
              do
                el:=newpair[1];
                mult:=newpair[2];
                if mult>lambda
                   then
                    return fail;
                fi;
                pos:=PositionSet(collpair[1],el);
                if pos<>fail
                   then
                    updatedmult:=collpair[2][pos]+mult;
                    if updatedmult>lambda
                       then
                        return fail;
                    else
                        mult_updated[pos]:=updatedmult;
                    fi;
                else
                    Add(newelts,el);
                    Add(newmult,mult);
                fi;
            od;
            returnelts:=Concatenation(collpair[1],newelts);
            returnmult:=Concatenation(mult_updated,newmult);
            SortParallel(returnelts,returnmult);
            return [returnelts,returnmult];
        end;
        
        ####################
        # just check if collecting would give false or not:
        
        isCompatible:=function(collected_pair,list,lambda)
            local   listcoll,  newpair,  el,  mult,  Apos;
            
            listcoll:=Collected(list);
            for newpair in listcoll
              do
                el:=newpair[1];
                mult:=newpair[2];
                if mult>lambda
                   then
                    return false;
                else
                    Apos:=PositionSet(collected_pair[1],el);
                    if Apos<>fail and collected_pair[2][Apos]+mult>lambda
                       then
                        return false;
                    fi;
                fi;
            od;
            return true;
        end;
        
        ####################
        
        depth:=Size(diffset);
        if depth+1=k
           then
            Append(founddiffsets,List(completions,i->Concatenation(diffset,[i])));
        else
            for i in completions{[1..Size(completions)-(k-depth-1)]}
              do
                diff2:=Concatenation(diffset,[i]); 
            
                # this is the new partial difference set
                # now we will calculate the parameters for recursion.
                
                newdiff_i_pres:=NewPresentables(diffset,i,diffTable);
                #diff2pres:=AsSortedList(Concatenation(allpres,newdiff_i_pres));
                
                diff2pres_collpair:=updatedCollectedPair(allpres_collpair,
                                            newdiff_i_pres,lambda
                                            );
                # the list of all quotients of <diff2> (not containing 1)
                
                newcomps:=[]; #the set of possible completions for <diff2>.
                
                ipos:=PositionSorted(completions,i);
                completions_for_diff_i:=completions{[ipos..Size(completions)]};
                for c in completions_for_diff_i
                  do
                    tmppres:=NewPresentables(diff2,c,diffTable);
                    if Intersection(tmppres,forbidden)=[]
                       and 
                       isCompatible(diff2pres_collpair,tmppres,lambda)
                       then
                        Add(newcomps,c);
                    fi;
                od;
                if (depth+1+Size(newcomps)>=k)
                   then
                if not Maximum(Set(Collected(AllPresentables(diff2,diffTable)),i->i[2]))<=lambda
                   then
                    Error("Something is terribly wrong!");
                fi;
                    
                    CallFuncList(FindDiffsetsLambda,
                            [diff2,diff2pres_collpair,AsSet(newcomps),
                             forbidden,k,founddiffsets,diffTable,lambda]); ## RECURSION !
                fi;  ## in all other cases, the next i is processed
            od;
        fi;
    end;
    
    ### Initialize and decide which recursion should be used:
    if not IsPartialDiffset(diffset,forbidden,data,lambda)
       then
        Info(InfoRDS,1,"given set is not a partial difference set");
        return [];
    elif Size(diffset)=k
      then
        return diffset;
    fi;
    
    founddiffsets:=[];
    allpres:=AllPresentables(diffset,data.diffTable);
    if lambda>1
       then
        allpres_collpair:=[List(Collected(allpres),i->i[1]),
                           List(Collected(allpres),i->i[2])
                           ];
        setcomps:=RemainingCompletions(diffset,completions,forbidden,data.diffTable,lambda);
        CallFuncList(FindDiffsetsLambda,[diffset,allpres_collpair,setcomps,forbidden,k,founddiffsets,data.diffTable,lambda]);
    elif lambda=1
      then
        setcomps:=RemainingCompletions(diffset,completions,forbidden,data.diffTable);
        CallFuncList(FindDiffsetsB,[diffset,allpres,setcomps,forbidden,k,founddiffsets,data.diffTable]);
    else
        Error("lambda must be a positive integer");
    fi;
    return founddiffsets;
end);



#############################################################################
##
#O AllDiffsets(<group>,[<lambda>])
#O AllDiffsets(<Gdata>,[<lambda>])
##
InstallMethod(AllDiffsets,[IsGroup],
        function(group)
    local   iso,  inviso,  Gdata,  returnset;
    if not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:=AllDiffsets([],[1],Gdata,1);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsets,[IsRecord],
        function(Gdata)
    return AllDiffsets([],[1],Gdata,1);
end);

InstallMethod(AllDiffsets,[IsGroup,IsPosInt],
        function(group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:=AllDiffsets([],[1],Gdata,lambda);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsets,[IsRecord,IsPosInt],
        function(Gdata,lambda)
    return AllDiffsets([],[1],Gdata,lambda);
end);

#############################################################################
##
#O AllDiffsets(<partial>,<group>,[<lambda>])
#O AllDiffsets(<partial>,<Gdata>,[<lambda>])
##
InstallMethod(AllDiffsets,[IsDenseList,IsGroup],
        function(partial,group)
    local   iso,  inviso,  Gdata,  returnset;
    if partial=[] and not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));

    if not IsSubset(Gdata.Glist,Image(iso,partial))
       then
        Error("partial set must be subset of the group");
    fi;
    returnset:=AllDiffsets(GroupList2PermList(Image(iso,partial),Gdata),
                   [],
                   Gdata,
                   1);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsets,[IsDenseList,IsRecord],
        function(partial,Gdata)
    return AllDiffsets(partial,[],Gdata,1);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsGroup,IsPosInt],
        function(partial,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;

    if partial=[] and not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));    
    if not IsSubset(Gdata.Glist,Image(iso,partial))
       then
        Error("partial set must be subset of the group");
    fi;    
    returnset:= AllDiffsets(GroupList2PermList(Image(iso,partial),Gdata),
                   [],
                   Gdata,
            lambda);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsets,[IsDenseList,IsRecord,IsPosInt],
        function(partial,Gdata,lambda)
    return AllDiffsets(partial,[],Gdata,lambda);
end);


#############################################################################
##
#O AllDiffsets(<partial>,<forbidden>,<group>,[<lambda>])
#O AllDiffsets(<partial>,<forbidden>,<Gdata>,[<lambda>])
##
InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsGroup],
        function(partial,forbidden,group)
    return AllDiffsets(partial,forbidden,group,1);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsGroup,IsPosInt],
        function(partial,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if partial=[] and not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));    
    if not (IsSubset(Gdata.Glist,Image(iso,partial)) and IsSubset(Gdata.Glist,Image(iso,forbidden)))
       then
        Error("partial set and forbidden set must be subsets of the group");
    fi;    
    returnset:= AllDiffsets(GroupList2PermList(Image(iso,partial),Gdata),
                        GroupList2PermList(Image(iso,forbidden),Gdata),
                        Gdata,
                        lambda);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsRecord],
        function(partial,forbidden,Gdata)
    return AllDiffsets(partial,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(partial,forbidden,Gdata,lambda)
    local   square,aim;
    if not 1 in forbidden
       then
        Add(forbidden, 1);
    fi;
    square:=lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4;
    aim:=RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2;
#    aim:=Sqrt(lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4)-1/2;
    if not IsPosInt(aim)
       then
        Info(InfoRDS,1,"group order of the wrong form");
        return [];
    else
        return AllDiffsets(partial,aim, forbidden,Gdata,lambda);
    fi;
end);



#############################################################################
##
#O AllDiffsets(<partial>, <aim>, <forbidden>, <group>, [<lambda>])
#O AllDiffsets(<partial>, <aim>, <forbidden>, <Gdata>, [<lambda>])
##
InstallMethod(AllDiffsets,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup],
        function(partial,aim,forbidden,group)
    return AllDiffsets(partial,aim,forbidden,group,1);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsPosInt,IsDenseList,IsRecord],
        function(partial,aim,forbidden,Gdata)
    return AllDiffsets(partial,aim,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsets,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt],
        function(partial,aim,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not IsSubset(group,Union(forbidden,partial))
       then
        Error("partial set and forbidden set  must be subsets of the group");
    fi;
    if partial=[] and not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;    
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:= AllDiffsets(GroupList2PermList(Image(iso,partial),Gdata),
                        aim,
                        Set(GroupList2PermList(Image(iso,forbidden),Gdata)),
                        Gdata,
                        lambda);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsets,[IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(partial,aim,forbidden,Gdata,lambda)
    local   square,  completions;
    if not 1 in forbidden
       then
        Add(forbidden, 1);
    fi;
    square:=lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4;
    if aim>RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2
#    if aim>Sqrt(lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4)-1/2
       then
        Info(InfoRDS,1,"<aim> too large. No difference sets");
        return [];
    fi;
    if partial<>[]
       then
        completions:=RemainingCompletionsNoSort(partial,[1..Size(Gdata.Glist)],forbidden,Gdata,lambda);
        return AllDiffsets(partial,completions,aim,forbidden,Gdata,lambda);
    else
        completions:=Difference([2..Size(Gdata.Glist)],forbidden);
        return Union(List(completions,i->AllDiffsets([i],
                       [3..Size(Gdata.Glist)],aim,forbidden,Gdata,lambda))
                     );
    fi;
end);



#############################################################################
## Here are the NoSort versions:
#############################################################################


#############################################################################
##
#O AllDiffsetsNoSort(<partial>,<group>,[<lambda>])
#O AllDiffsetsNoSort(<partial>,<Gdata>,[<lambda>])
##
InstallMethod(AllDiffsetsNoSort,[IsDenseList,IsGroup],
        function(partial,group)
    return AllDiffsetsNoSort(partial,group,1);
end);
InstallMethod(AllDiffsetsNoSort,[IsDenseList,IsRecord],
        function(partial,Gdata)
    return AllDiffsetsNoSort(partial,Gdata,1);
end);

InstallMethod(AllDiffsetsNoSort,[IsDenseList,IsGroup,IsPosInt],
        function(partial,group,lambda)
    local   square,aim;
    square:=lambda*(Size(group)-1+1/4);
    aim:=RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2;
#    aim:=Sqrt(lambda*(Size(group)-1+1/4))-1/2;
    return AllDiffsetsNoSort(partial,Set(group),aim,[],group,lambda);
end);
    
InstallMethod(AllDiffsetsNoSort,[IsDenseList,IsRecord,IsPosInt],
        function(partial,Gdata,lambda)
    local   square,aim;
    square:=lambda*(Size(Gdata.Glist)-1+1/4);
    aim:=RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2;
#    aim:=Sqrt(lambda*(Size(Gdata.Glist)-1+1/4))-1/2;
    return AllDiffsetsNoSort(partial,[1..Size(Gdata.Glist)],aim,[],Gdata,lambda);
end);


#############################################################################
##
#O AllDiffsetsNoSort(<partial>,[<completions>],<aim>,[<forbidden>],<group>,[<lambda>])
#O AllDiffsetsNoSort(<partial>,[completions],<aim>,[<forbidden>],<Gdata>,[<lambda>])
##
#############################################################################
## first (<partial>,<aim>,G/Gdata,[<lambda>]):
##
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsGroup],
        function(partial,aim,group)
    return AllDiffsetsNoSort(partial,aim,[],group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsRecord],
        function(partial,aim,Gdata)
    return AllDiffsetsNoSort(partial,aim,[],Gdata,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsGroup,IsPosInt],
        function(partial,aim,group,lambda)
    return AllDiffsetsNoSort(partial,aim,[],group,lambda);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsRecord,IsPosInt],
        function(partial,aim,Gdata,lambda)
    return AllDiffsetsNoSort(partial,aim,[],Gdata,lambda);
end);

#############################################################################
## now (<partial>,<aim>,<forbidden>,G/Gdata,[<lambda>])
##
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup],
        function(partial,aim,forbidden,group)
    return AllDiffsetsNoSort(partial,aim,forbidden,group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsRecord],
        function(partial,aim,forbidden,Gdata)
    return AllDiffsetsNoSort(partial,aim,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt],
        function(partial,aim,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not (IsSubset(group,partial) and IsSubset(group,forbidden))
       then
        Error("partial set and forbidden set must be subsets of the group");
    fi;
    if not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:= AllDiffsetsNoSort(GroupList2PermList(Image(iso,partial),Gdata),
                        aim,
                        GroupList2PermList(Image(iso,forbidden),Gdata),
                        Gdata,lambda);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(partial,aim,forbidden,Gdata,lambda)
    return AllDiffsetsNoSort(partial,[1..Size(Gdata.Glist)],aim,forbidden,Gdata,lambda);
end);



#############################################################################
## now (<partial>,<completions>,aim,G/Gdata,[<lambda>]
##
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsGroup],
        function(partial,completions,aim,group)
    return AllDiffsetsNoSort(partial,completions,aim,[],group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsGroup,IsPosInt],
        function(partial,completions,aim,group,lambda)
    return AllDiffsetsNoSort(partial,completions,aim,[],group,lambda);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsRecord],
        function(partial,completions,aim,Gdata)
    return AllDiffsetsNoSort(partial,completions,aim,[],Gdata,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsRecord,IsPosInt],
        function(partial,completions,aim,Gdata,lambda)
    return AllDiffsetsNoSort(partial,completions,aim,[],Gdata,lambda);
end);
    
#############################################################################
## finally (<partial>,<completions>,aim,<forbidden>,G/Gdata,[<lambda>])
## 
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup],
        function(partial,completions,aim,forbidden,group)
    return AllDiffsetsNoSort(partial,completions,aim,forbidden,group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord],
        function(partial,completions,aim,forbidden,Gdata)
    return AllDiffsetsNoSort(partial,completions,aim,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsGroup,IsPosInt],
        function(partial,completions,aim,forbidden,group,lambda)
    local   iso,  inviso,  Gdata,  returnset;
    if not (IsSubset(group,completions) and IsSubset(group,forbidden))
       then
        Error("partial set, forbidden set and completions must be subsets of the group");
    fi;
    if not Set(group)[1]=One(group)
       then
        iso:=IsomorphismPermGroup(group);
        inviso:=InverseGeneralMapping(iso);
    else
        iso:=IdentityMapping(group);
        inviso:=iso;
    fi;
    Gdata:=PermutationRepForDiffsetCalculations(Image(iso));
    returnset:= AllDiffsetsNoSort(GroupList2PermList(Image(iso,partial),Gdata),
                        GroupList2PermList(Image(iso,completions),Gdata),
                        aim,
                        GroupList2PermList(Image(iso,forbidden),Gdata),
                        Gdata,lambda);
    Apply(returnset,i->PermList2GroupList(i,Gdata));
    return Set(returnset,i->Image(inviso,i));
end);
    

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsPosInt,IsDenseList,IsRecord,IsPosInt],
        function(partial,completions,aim,forbidden,Gdata,lambda)
    local   square,  comps,  returnlist;
    if not (IsSubset([1..Size(Gdata.Glist)],completions) and IsSubset([1..Size(Gdata.Glist)],forbidden))
       then
        Error("forbidden set and completions must be subsets of the group");
    fi;
    if not IsPartialDiffset(partial,forbidden,Gdata,lambda)
       then
        Info(InfoRDS,1,"given set is not a partial difference set");
        return [];
    elif partial=aim
      then
        return [partial];
    fi;
    square:=lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4;
    if aim>RootInt(NumeratorRat(square))/RootInt(DenominatorRat(square))-1/2
#    if aim>Sqrt(lambda*(Size(Gdata.Glist)-Size(Set(forbidden)))+1/4)-1/2
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
    returnlist:=Union(List(comps,c->
                   AllDiffsets(Concatenation(partial,[c]),comps,aim,forbidden,Gdata,lambda))
                      );
    return Set(returnlist);
end);



#############################################################################
##
#E END
##
