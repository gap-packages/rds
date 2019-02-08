#############################################################################
##
#W startsets.gi 			 RDS Package		 Marc Roeder
##
##  Basic methods for startset generation
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
#O  PermutationRepForDiffsetCalculations(<group>) 
##
##
InstallMethod(PermutationRepForDiffsetCalculations,"for groups",
        [IsGroup],
        function(group)
    local   Glist,  gsize,  A,  achom,  Aac,  invlist,  invperm,  
            genset,  Ai,  diffTable,  i,  g,  line;
    
    Glist:=AsSet(group);
    gsize:=Size(Glist);
    if not Glist[1]=One(group)
       then
        Error("smallest element of group is not the identity. Try `IsomorphismPermGroup'");
    fi;
    A:=AutomorphismGroup(group);
    achom:=ActionHomomorphism(A,Glist);
    Aac:=ImagesSource(achom);
    invlist:=List([1..gsize],i->Inverse(Glist[i]));
    invperm:=PermList(List(invlist,i->PositionSet(Glist,i)));
    genset:=Set(GeneratorsOfGroup(Aac));
    UniteSet(genset,[invperm]);
    Ai:=Group(genset);
    diffTable:=NullMat(gsize,gsize);
    for i in [1..gsize]
      do
        g:=Glist[i];
        line:=List(g*invlist,p->PositionSet(Glist,p));
        diffTable[i]{[1..gsize]}:=line;
    od;
    return rec(G:=group,
               Glist:=Glist,
               A:=A,
               Aac:=Aac,
               Ahom:=achom,
               Ai:=Ai,
               diffTable:=diffTable);
end);

#############################################################################
##
#O  PermutationRepForDiffsetCalculations(<group>,<autgrp>) 
##
##
InstallMethod(PermutationRepForDiffsetCalculations,"for groups",
        [IsGroup,IsGroup],
        function(group,autgrp)
    local   Glist,  gsize,  A,  achom,  Aac,  invlist,  invperm,  
            genset,  Ai,  diffTable,  i,  g,  line;

    Glist:=AsSet(group);
    gsize:=Size(Glist);
    if not Glist[1]=One(group)
       then
        Error("Unable to generate <Glist>\n");
    fi;
    A:=autgrp;
    achom:=ActionHomomorphism(A,Glist);
    Aac:=ImagesSource(achom);
    invlist:=List([1..gsize],i->Inverse(Glist[i]));
    invperm:=PermList(List(invlist,i->PositionSet(Glist,i)));
    genset:=Set(GeneratorsOfGroup(Aac));
    UniteSet(genset,[invperm]);
    Ai:=Group(genset);
    diffTable:=NullMat(gsize,gsize);
    for i in [1..gsize]
      do
        g:=Glist[i];
        line:=List(g*invlist,p->PositionSet(Glist,p));
        diffTable[i]{[1..gsize]}:=line;
    od;
    return rec(G:=group,Glist:=Glist,A:=A,Aac:=Aac,Ahom:=achom,Ai:=Ai,diffTable:=diffTable);
end);

#############################################################################
##
#O  PermList2GroupList(<list>,<dat>) converts a list of integers into group elements according to the enumeration given in dat.Glist.
##
##
InstallMethod(PermList2GroupList,
        [IsDenseList,IsRecord],
        function(list,dat)
    return List(list,i->dat.Glist[i]);
end);

#############################################################################
##
#O  GroupList2PermList(<list>,<dat>) converts a list of group elements to integers according to the enumeration given in dat.Glist.
##
##
InstallMethod(GroupList2PermList,
        [IsDenseList,IsRecord],
        function(list,dat)
    return List(list,i->PositionSet(dat.Glist,i));
end);



#############################################################################
##
#O  NewPresentables( <list>,<newel>,<table> ) calculates quotients of a list and a given element.
##
InstallMethod(NewPresentables,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsInt,IsMatrix],
        function(list,newel,difftable) # berechnet die Elemente, die durch hinzunehmen von <newel> 
    # zu list zusaetzlich dargestellt werden koennen und gibt sie zurueck.
    local   tmplist,  i;

    tmplist:=[newel,difftable[1][newel]]; # hier wird 1\in list verwendet.
    for i in list 
      do
        Append(tmplist,[difftable[i][newel],difftable[newel][i]]);
    od;
    return tmplist;
end);

#############################################################################
##
#O  NewPresentables( <list>,<newel>,<dat> ) calculates quotients of a list and a given element.
##
##  <dat> must be a record conaining <dat.diffTable> as calculated by 'PermutationRepForDiffsetCalculations'
##
##
InstallMethod(NewPresentables,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsInt,IsRecord],
        function(list,newel,dat)
    return NewPresentables(list,newel,dat.diffTable);
end);

#############################################################################
##
#O  NewPresentables( <list>,<newlist>,<table> ) calculates the quotients of two lists. The quotients of the second list are also returned.
##
InstallMethod(NewPresentables,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsMatrix],
        function(list,newlist,difftable) # berechnet die Elemente, die durch hinzunehmen von <newel> 
    # zu list zusaetzlich dargestellt werden koennen und gibt sie zurueck.
    local   tmplist,  i;
    
    tmplist:=AllPresentables(newlist,difftable);
    for i in list 
      do
        Append(tmplist,List(newlist,newel->difftable[i][newel]));
        Append(tmplist,List(newlist,newel->difftable[newel][i]));
    od;
    return tmplist;
end);

#############################################################################
##
#O  NewPresentables( <list>,<newlist>,<dat> ) calculates the quotients of two lists. The quotients of the second list are also returned.
##
##  <dat> must be a record conaining <dat.diffTable> as calculated by 'PermutationRepForDiffsetCalculations'
##
##
InstallMethod(NewPresentables,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord],
        function(list,newlist,dat)
    return NewPresentables(list,newlist,dat.diffTable);
end);


#############################################################################
##
#O  AllPresentables( <list>,<table> ) calculates quotients of elements in <list>.
##
InstallMethod(AllPresentables,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsMatrix],
        function(list,difftable) 
    local   tmplist,  tmpset,  i;

    if 1 in list 
       then 
        Error("1 in diffset is assumed automatically. Don't add it to startsets explicitely");
    fi;
    if Size(list)<=1
       then
        return Concatenation(list,List(list,c->difftable[1][c]));
    else
        tmplist:=ShallowCopy(list);				# hier wird benutzt, dass 1 in jeder Differenzmenge ist...
        tmpset:=Combinations(tmplist,2);   # 2-Mengen aus tmplist ohne Wiederholungen.
        for i in tmpset
          do
            Append(tmplist,[difftable[i[1]][i[2]],difftable[i[2]][i[1]]]);
        od;
        Append(tmplist,difftable[1]{list}); #...und hier auch.
    fi;
    return tmplist; 
end);

#############################################################################
##
#O  AllPresentables( <list>,<dat> ) calculates quotients of elements in <list>.
##
##  <dat> must be a record conaining <dat.diffTable> as calculated by 'PermutationRepForDiffsetCalculations'
##
##
InstallMethod(AllPresentables,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsRecord],
        function(list,dat)
    return AllPresentables(list,dat.diffTable);
end);

#############################################################################
##
#O  RemainingCompletionsNoSort( <diffset>,<completions>,<forbidden>,<difftable>,<lambda> ) calculates all elemtns of <completions> which may be added to the partial difference set <diffset>.
##
##
InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix,IsPosInt],
        function(diffset,completions,forbidden,difftable,lambda)
    local   pres,  comps,  wrongels,  g,  newpres;
    if not IsSet(completions) 
       then 
        Error("\ncompletions must be a SET\n");
    fi;
    pres:=AllPresentables(diffset,difftable);
    #if pres=[] or ForAny(diffset,i-> i in forbidden)
    if ForAny(diffset,i->i in forbidden)
       then 
        Error("diffset is no partial diffset");
        return [];
    fi;
    comps:=Difference(completions,diffset);	# completions muessen SET sein!
#    dont:=Union2(pres,forbidden);
    wrongels:=[];
    RemoveSet(comps,1);
    for g in comps
      do
        newpres:=NewPresentables(diffset,g,difftable);
        if ForAny(newpres,i->i in forbidden) or 
           not Maximum(Set(Collected(Concatenation(pres,newpres)),c->c[2]))<=lambda
           then 
            Add(wrongels,g);
        fi;
    od;
    SubtractSet(comps,wrongels);
    return comps;
end);


#############################################################################
##
#O  RemainingCompletionsNoSort( <diffset>,<completions>,<forbidden>,<difftable> ) calculates all elemtns of <completions> which may be added to the partial difference set <diffset>.
##
##
InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix],
        function(diffset,completions,forbidden,difftable)
    local  pres,  maxel,  comps,  dont,  wrongels,  g;
    if not IsSet(completions) 
       then 
        Error("\ncompletions must be a SET\n");
    fi;
   pres:=AllPresentables(diffset,difftable);
    if pres=[] or ForAny(diffset,i->i in forbidden)
       then 
        Error("diffset is no partial diffset");
        return [];
    fi;
    comps:=Difference(completions,pres);	# completions muessen SET sein!
    
    dont:=Union2(pres,forbidden);
    wrongels:=[];
    for g in comps 
      do
        if not IsDuplicateFree(Concatenation(dont,NewPresentables(diffset,g,difftable)))
           then 
            Add(wrongels,g);
        fi;
    od;
    SubtractSet(comps,wrongels);
    return comps;
end);

InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord],
        function(diffset,completions,forbidden,dat)
    return RemainingCompletionsNoSort(diffset,completions,forbidden,dat.diffTable);
end);

InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,forbidden,dat,lambda)
    return RemainingCompletionsNoSort(diffset,completions,forbidden,dat.diffTable,lambda);
end);

#############################################################################
##
#O  RemainingCompletionsNoSort( <diffset>,<completions>,<dat> ) calculates all elemtns of <completions> which may be added to the partial difference set <diffset>.
##
##
InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord],
        function(diffset,completions,dat)
    return RemainingCompletionsNoSort(diffset,completions,[],dat.diffTable);
end);

InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,dat,lambda)
    return RemainingCompletionsNoSort(diffset,completions,[],dat.diffTable,lambda);
end);


#############################################################################
##
#O  RemainingCompletionsNoSort( <diffset>,<completions>,<dat> ) calculates all elemtns of <completions> which may be added to the partial difference set <diffset>.
##
InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord],
        function(diffset,completions,dat)
    return RemainingCompletionsNoSort(diffset,completions,[],dat.diffTable);
end);

InstallMethod(RemainingCompletionsNoSort,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,dat,lambda)
    return RemainingCompletionsNoSort(diffset,completions,[],dat.diffTable,lambda);
end);


##### NOW THE SORTED VERSIONS ####

#############################################################################
##
#O  RemainingCompletions( <diffset>,<completions>,<forbidden>,<dat>[,<lambda>]) calculates all elemtens of <completions> which may be added to the partial difference set <diffset>.
##
##
InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,forbidden,dat,lambda)
    local   comps;
    comps:=Filtered(completions,i->(i>diffset[Size(diffset)]));
    return RemainingCompletionsNoSort(diffset,comps,forbidden,dat.diffTable,lambda);
end);

InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord],
        function(diffset,completions,forbidden,dat)
    local   comps;
    comps:=Filtered(completions,i->(i>diffset[Size(diffset)]));
    return RemainingCompletionsNoSort(diffset,comps,forbidden,dat.diffTable);
end);


#############################################################################
##
#O  RemainingCompletions( <diffset>,<completions>,<forbidden>,<difftable>[,<lambda>]) calculates all elemtens of <completions> which may be added to the partial difference set <diffset>.
##
##
InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix,IsPosInt],
        function(diffset,completions,forbidden,difftable,lambda)
    local   comps;
    comps:=Filtered(completions,i->(i>diffset[Size(diffset)]));
    return RemainingCompletionsNoSort(diffset,comps,forbidden,difftable,lambda);
end);

InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsDenseList,IsMatrix],
        function(diffset,completions,forbidden,difftable)
    local   comps;
    comps:=Filtered(completions,i->(i>diffset[Size(diffset)]));
    return RemainingCompletionsNoSort(diffset,comps,forbidden,difftable);
end);


#############################################################################
##
#O  RemainingCompletions( <diffset>,<completions>,<dat>[,<lambda>] ) calculates all elemtns of <completions> which may be added to the partial difference set <diffset>.
##
InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord],
        function(diffset,completions,dat)
    return RemainingCompletions(diffset,completions,[],dat.diffTable);
end);

InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(diffset,completions,dat,lambda)
    return RemainingCompletions(diffset,completions,[],dat.diffTable,lambda);
end);


#############################################################################
##
#O  RemainingCompletions( <diffset>,<completions>,<difftable>[,<lambda>] ) calculates all elemtns of <completions> which may be added to the partial difference set <diffset>.
##
##
InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsMatrix],
        function(diffset,completions,difftable)
    return RemainingCompletions(diffset,completions,[],difftable);
end);

InstallMethod(RemainingCompletions,
        "for partial difference sets in permutation representation",
        [IsDenseList,IsDenseList,IsMatrix,IsPosInt],
        function(diffset,completions,difftable,lambda)
    return RemainingCompletions(diffset,completions,[],difftable,lambda);
end);


#############################################################################
##
#O  ExtendedStartsetsNoSort(<startsets>,<completions>,<forbiddenset>,<aim>,<Gdata>[,<lambda>]);
##
InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt],
        function(startsets,completions,forbiddenset,aim,Gdata,lambda)
    local   level,  returnlist,  set,  comps,  i;
    
    if startsets=[] or completions=[]
       then
        return [];
    fi;
    if lambda>1
       then
        if not IsSet(completions)
           then 
            Error("\ncompletions must be a SET\n");
        fi;
        
        level:=Size(startsets[1]);
        if ForAny(startsets,c->not Size(c)=level)
           then
            Error("Start sets are not of the same size");
        fi;
        if aim=level
           then
            Error("Aim already reached. This shouln't happen.\n It is save to say \"return;\" here, but you better check your program.\n");
                  return;
        fi;
        returnlist:=[];       
        for set in startsets
          do
            comps:=RemainingCompletionsNoSort(set,completions,forbiddenset,Gdata,lambda);
            # Zahl der Elemente, fuer die <comps> zu wenige Elemente enthaelt
            # zu einer part. Differenzenmengen muss es aim-level Elemente in comps geben.
            if Size(comps)>=aim-level
               then
                for i in comps
                  do
                    Add(returnlist,Concatenation(set,[i]));
                od;
            fi;
        od;
        return Set(returnlist);
    elif lambda=1
      then
        return ExtendedStartsetsNoSort(startsets,completions,forbiddenset,aim,Gdata);
    else
        Error("lambda must be a positive integer");
    fi;
end);    

#############################################################################
InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord],
        function(startsets,completions,forbiddenset,aim,Gdata)
    local   level,  returnlist,  set,  comps,  i;
    
    if startsets=[] or completions=[] then return [];fi;
    if not IsSet(completions) then Error("\ncompletions must be a SET\n");fi;
    
    level:=Size(startsets[1]);
    if ForAny(startsets,c->not Size(c)=level)
       then
        Error("Start sets are not of the same size");
    fi;
    if aim=level
       then
        Error("Aim already reached. This shouln't happen.\n It is save to say \"return;\" here, but you better check your program.\n");
              return;
    fi;
    returnlist:=[];
    for set in startsets
      do
        comps:=RemainingCompletionsNoSort(set,completions,forbiddenset,Gdata);
        # Zahl der Elemente, fuer die <comps> zu wenige Elemente enthaelt.
        # zu einer part. Differenzenmengen muss es aim-level Elemente in comps geben.
        if Size(comps)>=aim-level
           then
            for i in comps
              do
                Add(returnlist,Concatenation(set,[i]));
            od;
        fi;
    od;
    return Set(returnlist);
end);    
#############################################################################
InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsDenseList,IsRecord],
        function(startsets,completions,forbiddenset,Gdata)
    if startsets=[] or completions=[] then return [];fi;
    return ExtendedStartsetsNoSort(startsets,completions,forbiddenset,Size(startsets[1])+1,Gdata);
 end);
 
 InstallMethod(ExtendedStartsetsNoSort,
         [IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(startsets,completions,forbiddenset,Gdata,lambda)
     if startsets=[] or completions=[] then return [];fi;
     return ExtendedStartsetsNoSort(startsets,completions,forbiddenset,Size(startsets[1])+1,Gdata,lambda);
end);
#############################################################################
InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsRecord],
        function(startsets,completions,aim,Gdata)
     return ExtendedStartsetsNoSort(startsets,completions,[],aim,Gdata);
 end);
 
 InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt],
        function(startsets,completions,aim,Gdata,lambda)
     return ExtendedStartsetsNoSort(startsets,completions,[],aim,Gdata,lambda);
end);
#############################################################################
InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsRecord],
        function(startsets,completions,Gdata)
    if startsets=[] or completions=[] then return [];fi;
    return ExtendedStartsetsNoSort(startsets,completions,[],Size(startsets[1])+1,Gdata);
end);

InstallMethod(ExtendedStartsetsNoSort,
        [IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(startsets,completions,Gdata,lambda)
    if startsets=[] or completions=[] then return [];fi;
    return ExtendedStartsetsNoSort(startsets,completions,[],Size(startsets[1])+1,Gdata,lambda);
end);


#############################################################################
##
#O  ExtendedStartsets(<startsets>,<completions>,<forbiddenset>,<aim>,<Gdata>,<lambda);
## 
InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt],
        function(startsets,completions,forbiddenset,aim,Gdata,lambda)
    local   level,  returnlist,  set,  comps,  nrlastones,  attach,  
            i;
    
    if startsets=[] or completions=[] then return []; fi;
    if lambda>1
       then
        if not IsSet(completions) then Error("\ncompletions must be a SET\n");fi;
    
        level:=Size(startsets[1]);
        if ForAny(startsets,c->not Size(c)=level)
           then
            Error("Start sets are not of the same size");
        fi;
        if aim=level
           then
            Error("Aim already reached. This shouldn't happen.\n It is save to say \"return;\" here, but you better check your program.\n");
                  return;
        fi;
        
        returnlist:=[];
        for set in startsets
          do
            comps:=RemainingCompletions(set,completions,forbiddenset,Gdata,lambda);
            # Zahl der Elemente, fuer die <comps> zu wenige groessere Elemente enthaelt.
            # zu einer part. Differenzenmengen muss es aim-level Elemente in comps geben,
            # die groesser sind als das groessete Element in der Differenzenmenge.
            nrlastones:=aim-level-1;		
            attach:=comps{[1..(Size(comps)-nrlastones)]};
            for i in attach
              do
                Add(returnlist,Concatenation(set,[i]));
            od;
        od;
        return Set(returnlist); 
    elif lambda=1
      then
        return ExtendedStartsets(startsets,completions,forbiddenset,aim,Gdata);
    else
        Error("lambda must be a positive integer");
    fi;
end);    

InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsDenseList,IsInt,IsRecord],
        function(startsets,completions,forbiddenset,aim,Gdata)
    local   level,  returnlist,  set,  comps,  nrlastones,  attach,  
            i;
    
    if startsets=[] or completions=[] then return [];fi;
    if not IsSet(completions) then Error("\ncompletions must be a SET\n");fi;
    
    level:=Size(startsets[1]);
    if ForAny(startsets,c->not Size(c)=level)
       then
        Error("Start sets are not of the same size");
    fi;
    if aim=level
       then
        Error("Aim already reached. This shouln't happen.\n It is save to say \"return;\" here, but you better check your program.\n");
              return;
    fi;
    returnlist:=[];
    for set in startsets
      do
        comps:=RemainingCompletions(set,completions,forbiddenset,Gdata);
        # Zahl der Elemente, fuer die <comps> zu wenige groessere Elemente enthaelt.
        # zu einer part. Differenzenmengen muss es aim-level Elemente in comps geben,
        # die groesser sind als das groessete Element in der Differenzenmenge.
        nrlastones:=aim-level-1;		
        attach:=comps{[1..(Size(comps)-nrlastones)]};
        for i in attach
          do
            Add(returnlist,Concatenation(set,[i]));
        od;
    od;
    return Set(returnlist); 
end);    
#############################################################################
InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsDenseList,IsRecord],
        function(startsets,completions,forbiddenset,Gdata)
    if startsets=[] or completions=[] then return [];fi;
    return ExtendedStartsets(startsets,completions,forbiddenset,Size(startsets[1])+1,Gdata);
 end);
 
 InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(startsets,completions,forbiddenset,Gdata,lambda)
     if startsets=[] or completions=[] then return [];fi;
     return ExtendedStartsets(startsets,completions,forbiddenset,Size(startsets[1])+1,Gdata,lambda);
end);
#############################################################################
InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsInt,IsRecord],
        function(startsets,completions,aim,Gdata)
     return ExtendedStartsets(startsets,completions,[],aim,Gdata);
 end);
 
 InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsInt,IsRecord,IsPosInt],
        function(startsets,completions,aim,Gdata,lambda)
     return ExtendedStartsets(startsets,completions,[],aim,Gdata,lambda);
end);
#############################################################################
InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsRecord],
        function(startsets,completions,Gdata) 
    if startsets=[] or completions=[] then return [];fi;
    return ExtendedStartsets(startsets,completions,[],Size(startsets[1])+1,Gdata);
end);

InstallMethod(ExtendedStartsets,
        [IsDenseList,IsDenseList,IsRecord,IsPosInt],
        function(startsets,completions,Gdata,lambda)
    if startsets=[] or completions=[] then return [];fi;
    return ExtendedStartsets(startsets,completions,[],Size(startsets[1])+1,Gdata,lambda);
end);



#############################################################################
##
#E  THE END
##
