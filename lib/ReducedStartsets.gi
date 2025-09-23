#############################################################################
##
#W ReducedStartsets.gi 			 RDS Package		 Marc Roeder
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
InstallMethod(ReducedStartsets,
        "for partial relative difference sets",
        [IsDenseList,IsDenseList,IsFunction,IsMatrix],
        function(startsets,autlist,func,difftable)	
    local   Translates,  allConjugatesOrbit,  allConjugatesRep,  
            oneReductionStep,  timetmp,  partition,  
            partitionpos,  partitionElt,  autgrp,  userep;
    
    ####################    
    Translates:=function(set,difftable)
        local   returnlist,  g,  trans;

        returnlist:=[];
        for g in set
          do
            trans:=difftable{set}[g];                 
            Add(trans,difftable[1][g]); 
            Sort(trans);
            RemoveSet(trans,1);
            Add(returnlist,trans);
        od;
        Add(returnlist,AsSet(set));
        return AsSortedList(returnlist);
    end;
    ####################
    
    allConjugatesOrbit:=function(set,transgraph,autgrp)
        local   orbit;
        orbit:=AsSortedList(Orbit(autgrp,set.sorted,OnSets));;
        if Size(set.trans)>Size(orbit)
           then
            return Filtered(transgraph,t->
                           ForAny(orbit,o->o in t.trans)
                           );
            
        else
            return Filtered(transgraph,t->
                          ForAny(t.trans,s->s in orbit)
                          );
       fi;
    end;
    
    ####################
    
    allConjugatesRep:=function(set,transgraph,autgrp)
        return Filtered(transgraph,t->
                       set.sorted in t.trans 
                       or
                       ForAny(t.trans,s->RepresentativeAction(autgrp,s,set.sorted,OnSets)<>fail)
                       );
    end;

    
    ####################
    ## this will return a reduced version of <transgraph> 
    ## 
    oneReductionStep:=function(transgraph,autgrp,userep)
        local   representatives,  reduceme,  set,  conjugates,  
                conjugate_indices,  index,  minrep,  pos;
        representatives:=[];
        reduceme:=ShallowCopy(transgraph);
        while reduceme<>[]
          do
            set:=Remove(reduceme);
            if userep
               then
                conjugates:=allConjugatesRep(set,reduceme,autgrp);
            else
                conjugates:=allConjugatesOrbit(set,reduceme,autgrp);
            fi;
            if conjugates<>[]
               then
                conjugate_indices:=List(conjugates,c->PositionSet(reduceme,c));
                for index in conjugate_indices
                  do
                    Unbind(reduceme[index]);
                od;
                reduceme:=Compacted(reduceme);
                minrep:=Reversed(Minimum(List(conjugates,i->Reversed(i.pds))));
                if Reversed(set.pds)<minrep
                   then
                    Add(representatives,set);
                else
                    pos:=PositionSet(Set(conjugates,i->i.pds),minrep);
                    Add(representatives,conjugates[pos]);
                fi;
            else
                Add(representatives,set);
            fi;
        od;
        return Set(representatives);
    end;
    
    ##############################
    
    #    if not IsSet(startsets) then Error("\nThe set of startsets must be a SET\n");fi;
    #check if necessary!
    Info(InfoRDS,1,"Size ",Size(startsets));
    if startsets=[] then return [];fi;
    
    timetmp:=Runtime();
    partition:=PartitionByFunction(Set(startsets),func);
    Info(InfoRDS,1,Size(partition),"/ ",Number(partition,p->Size(p)=1)," @",StringTime(Runtime()-timetmp));
    Apply(partition,SortedList);
    
    
    for partitionpos in [1..Size(partition)]
      do
        partitionElt:=partition[partitionpos];
        Apply(partitionElt,i->rec(pds:=i,sorted:=AsSet(i),trans:=Translates(i,difftable)));
        Sort(partitionElt);
        if Size(partitionElt)>1
           then
            for autgrp in autlist
              do
                userep:=Size(autgrp)>RDS_MaxAutsizeForOrbitCalculation;
 #               if not partitionElt=partition[partitionpos]
 #                  then
 #                   Error("wer nicht programmieren kann, soll's lassen!");
 #               fi;
                partition[partitionpos]:=oneReductionStep(partition[partitionpos],autgrp,userep);
            od;
        fi;
    od;
   return Set(Concatenation(partition),i->i.pds);
end);
                
#############################################################################
##
InstallMethod(ReducedStartsets,
        "for partial relative difference sets",
        [IsDenseList,IsDenseList,IsDenseList,IsRecord],
        function(startsets,autlist,csdata,data)
    return ReducedStartsets(startsets,autlist,csdata,data.diffTable);
end);

#############################################################################
##
InstallMethod(ReducedStartsets,
        "for partial relative difference sets",
        [IsDenseList,IsDenseList,IsFunction,IsRecord],
        function(startsets,autlist,func,data)
    return ReducedStartsets(startsets,autlist,func,data.diffTable);
end);

    