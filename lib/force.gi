#############################################################################
##
#W force.gi 			 RDS Package		 Marc Roeder
##
##  Brute force methods for finding relative differnece sets
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
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,k,forbidden,data,lambda)
    
    local   FindDiffsetsB,  FindDiffsetsLambda,  founddiffsets,  
            allpres,  setcomps;
    
    #There are two recursive functions. One for lambda=1 and one for other
    # lambda.
    #First, the lambda=1 case:
    
    FindDiffsetsB:=function(diffset,allpres,completions,forbidden,k,founddiffsets,diffTable)
        local   depth,  i,  diff2,  newdiff_i_pres,  diff2pres,  
                newcomps,  completions_for_diff_i,  c,  tmppres;
        
        depth:=Size(diffset);
        if depth+1=k
           then
            Append(founddiffsets,List(completions,i->Concatenation(diffset,[i])));
#            for i in completions
#              do
#                locadd:=Concatenation([diffset,[i]]);    #without  1.
#                Add(founddiffsets,locadd);
#            od;
#            return;
        else
            for i in completions{[1..Size(completions)-(k-depth-1)]}
              do
                diff2:=Concatenation(diffset,[i]);
                newdiff_i_pres:=NewPresentables(diffset,i,diffTable);
                diff2pres:=AsSet(Concatenation(allpres,newdiff_i_pres));
                newcomps:=[];
                completions_for_diff_i:=Difference(completions, newdiff_i_pres);
                for c in Filtered(completions_for_diff_i,c->i<c)
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
    
    FindDiffsetsLambda:=function(diffset,allpres,completions,forbidden,k,founddiffsets,diffTable,lambda)
        local   depth,  i,  diff2,  newdiff_i_pres,  diff2pres,  
                newcomps,  c,  tmppres;

        depth:=Size(diffset);
        if depth+1=k
           then
            Append(founddiffsets,List(completions,i->Concatenation(diffset,[i])));
#            for i in completions
#              do
#                locadd:=Concatenation([diffset,[i]]);    #without  1.
#                Add(founddiffsets,locadd);
#            od;
#            return;
            #        fi;
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
                    CallFuncList(FindDiffsetsLambda,
                            [diff2,diff2pres,AsSet(newcomps),
                             forbidden,k,founddiffsets,diffTable,lambda]); ## RECURSION !
                fi;  ## in all other cases, the next i is processed
            od;
        fi;
    end;
    
    ### Initialize and decide which recursion should be used:
    
    founddiffsets:=[];
    allpres:=AllPresentables(diffset,data.diffTable);
    if lambda>1
       then
        setcomps:=RemainingCompletions(diffset,completions,forbidden,data.diffTable,lambda);
        CallFuncList(FindDiffsetsLambda,[diffset,allpres,setcomps,forbidden,k,founddiffsets,data.diffTable,lambda]);
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
#O AllDiffsets(<group>)
#O AllDiffsets(<Gdata>)
##
InstallMethod(AllDiffsets,[IsGroup],
        function(group)
    local   Gdata;
    Gdata:=PermutationRepForDiffsetCalculations(group);
    return AllDiffsets([],[1],Gdata,1);
end);

InstallMethod(AllDiffsets,[IsRecord],
        function(Gdata)
    return AllDiffsets([],[1],Gdata,1);
end);

#############################################################################
##
#O AllDiffsets(<start>,<group>)
#O AllDiffsets(<start>,<Gdata>)
##
InstallMethod(AllDiffsets,[IsDenseList,IsGroup],
        function(start,group)
    local   Gdata;
    Gdata:=PermutationRepForDiffsetCalculations(group);    
    return AllDiffsets(GroupList2PermList(start,Gdata),
                   []
                   Gdata,
                   1);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsRecord,IsInt],
        function(start,Gdata,lambda)
    return AllDiffsets(start,[],Gdata,1);
end);


#############################################################################
##
#O AllDiffsets(<start>,<group>,<lambda>)
#O AllDiffsets(<start>,<Gdata>,<lambda>)
##
InstallMethod(AllDiffsets,[IsDenseList,IsGroup,IsInt],
        function(start,group,lambda)
    local   Gdata;
    Gdata:=PermutationRepForDiffsetCalculations(group);    
    return AllDiffsets(GroupList2PermList(start,Gdata),
                   []
                   Gdata,
                   lambda);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsRecord,IsInt],
        function(start,Gdata,lambda)
    return AllDiffsets(start,[],Gdata,lambda);
end);


#############################################################################
##
#O AllDiffsets(<start>,<forbidden>,<group>)
#O AllDiffsets(<start>,<forbidden>,<Gdata>)
#O AllDiffsets(<start>,<forbidden>,<group>,<lambda>)
#O AllDiffsets(<start>,<forbidden>,<Gdata>,<lambda>)
##
InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsGroup],
        function(start,forbidden,group)
    return AllDiffsets(star,forbidden,group,1);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsGroup,IsInt],
        function(start,forbidden,group,lambda)
    local   Gdata;
    Gdata:=PermutationRepForDiffsetCalculations(group);    
    return AllDiffsets(GroupList2PermList(start,Gdata),
                   GroupList2PermList(forbidden,Gdata),
                   Gdata,
                   lambda);
end);

InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsRecord],
        function(start,forbidden,Gdata)
    return AllDiffsets(star,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsets,[IsDenseList,IsDenseList,IsRecord,IsInt],
        function(start,forbidden,Gdata,lambda)
    local   aim;
    if not 1 in forbidden
       then
        Add(forbidden, 1);
    fi;
    aim:=Sqrt(lambda*(Size(group)-Size(Set(forbidden)))+1/4)-1/2;
    if not IsInt(aim)
       then
        Info(InfoRDS,1,"group order of the wrong form");
        return [];
    else
        return AllDiffsets([],aim, forbidden,Glist,lambda);
    fi;
end);



#############################################################################
##
#O AllDiffsets(<start>, <aim>, <forbidden>, <group>)
#O AllDiffsets(<start>, <aim>, <forbidden>, <Gdata>)
#O AllDiffsets(<start>, <aim>, <forbidden>, <group>, <lambda>)
#O AllDiffsets(<start>, <aim>, <forbidden>, <Gdata>, <lambda>)
##
InstallMethod(AllDiffsets,
        [IsDenseList,IsInt,IsDenseList,IsGroup],
        function(start,aim,forbidden,group)
    return AllDiffsets(start,aim,forbidden,group,1);
end);
InstallMethod(AllDiffsets,[IsDenseList,IsInt,IsDenseList,IsRecord],
        function(start,aim,forbidden,Gdata)
    return AllDiffsets(start,aim,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsets,
        [IsDenseList,IsInt,IsDenseList,IsGroup,IsInt],
        function(start,aim,forbidden,group,lamdba)
    local   Gdata;
    Gdata:=PermutationRepForDiffsetCalculations(group);
    return AllDiffsets(GroupList2PermList(start,Gdata),
                   aim,
                   Set(GroupList2PermList(forbidden)),
                   Gdata,
                   lambda);
end);

InstallMethod(AllDiffsets,[IsDenseList,IsInt,IsDenseList,IsRecord,IsInt],
        function(start,aim,forbidden,Gdata,lambda)
    local   completions;
    if not 1 in forbidden
       then
        Add(forbidden, 1);
    fi;
    if aim>Sqrt(lambda*(Size(group)-Size(Set(forbidden)))+1/4)-1/2
       then
        Info(InfoRDS,1,"<aim> too large. No difference sets");
        return [];
    fi;
    completions:=RemainingCompletionsNoSort(start,[1..Size(Gdata.Glist)],forbidden,Gdata,lambda);
    return AllDiffsets(start,completions,aim,forbidden,Gdata,lambda);
end);



#############################################################################
## Here are the NoSort versions:
#############################################################################



#############################################################################
##
#O AllDiffsetsNoSort(<start>,<aim>,[<forbidden>],<group>,[<lambda>])
#O AllDiffsetsNoSort(<start>,<aim>,[<forbidden>],<Gdata>,[<lambda>])
##
#############################################################################
## first (<start>,<aim>,G/Gdata,[<lambda>]):
##
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsGroup],
        function(start,aim,group)
    return AllDiffsetsNoSort(start,aim,[],group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsRecord],
        function(start,aim,Gdata)
    return AllDiffsetsNoSort(start,aim,[],Gdata,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsGroup,IsInt],
        function(start,aim,group,lambda)
    return AllDiffsetsNoSort(start,aim,[],group,lambda);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsRecord,IsInt],
        function(start,aim,Gdata,lambda)
    return AllDiffsetsNoSort(start,aim,[],Gdata,lambda);
end);

#############################################################################
## now (<start>,<aim>,<forbidden>,G/Gdata,[<lambda>])
##
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsDenseList,IsGroup],
        function(start,aim,forbidden,group)
    return AllDiffsetsNoSort(start,aim,forbidden,group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsDenseList,IsRecord],
        function(start,aim,forbidden,Gdata)
    return AllDiffsetsNoSort(start,aim,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsDenseList,IsGroup,IsInt],
        function(start,aim,forbidden,group,lambda)
    local   Gdata,  completions;
    Gdata:=PermutationRepForDiffsetCalculations(group);
    return AllDiffsetsNoSort(GroupList2PermList(start,Gdata),
                   aim,
                   GroupList2PermList(forbidden,Gdata),
                   Gdata,lambda);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsInt,IsDenseList,IsRecord,IsInt],
        function(start,aim,forbidden,Gdata,lambda)
    return AllDiffsetsNoSort(start,Gdata.Glist,aim,forbidden,Gdata,lambda);
end);



#############################################################################
## now (<start>,<completions>,aim,G/Gdata,[<lambda>]
##
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsGroup],
        function(start,completions,aim,group)
    return AllDiffsetsNoSort(start,completions,aim,[],group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsGroup,IsInt],
        function(start,completions,aim,group,lambda)
    return AllDiffsetsNoSort(start,completions,aim,[],group,lambda);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsRecord],
        function(start,completions,aim,Gdata,lambda)
    return AllDiffsetsNoSort(start,completions,aim,[],Gdata,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsRecord,IsInt],
        function(start,completions,aim,Gdata,lambda)
    return AllDiffsetsNoSort(start,completions,aim,[],Gdata,lambda);
end);
    
#############################################################################
## finally (<start>,<completions>,aim,<forbidden>,G/Gdata,[<lambda>])
## 
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsGroup],
        function(start,completions,aim,forbidden,group)
    return AllDiffsetsNoSort(start,completions,aim,forbidden,group,1);
end);
InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsRecord],
        function(start,completions,aim,forbidden,Gdata)
    return AllDiffsetsNoSort(start,completions,aim,forbidden,Gdata,1);
end);

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsGroup,IsInt],
        function(start,completions,aim,forbidden,group,lambda)
    Gdata:=PermutationRepForDiffsetCalculations(group);
    return AllDiffsetsNoSort(GroupList2PermList(start,Gdata),
                   GroupList2PermList(completions,Gdata),
                   aim,
                   GroupList2PermList(forbidden,Gdata),
                   Gdata,lambda);
end);
    

InstallMethod(AllDiffsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsRecord,IsInt],
        function(start,completions,aim,forbidden,Gdata,lambda)
    local comps;
    if aim>Sqrt(lambda*(Size(group)-Size(Set(forbidden)))+1/4)-1/2
       then
        Info(InfoRDS,1,"<aim> too large. No difference sets");
        return [];
    fi;
    comps:=RemainingCompletionsNoSort(start,[1..Size(Gdata.Glist)],forbidden,Gdata,lambda);
    return Union(List(comps,c->
                   AllDiffsets(Concatenation(start,[c]),comps,aim,forbidden,Gdata,lambda))
                 );
end);



#############################################################################
##
#E END
##