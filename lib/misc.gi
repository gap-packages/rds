#############################################################################
##
#W misc.gi 			 RDS Package		 Marc Roeder
##
##  Some methods for general use
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
#F  IsComputableFilter( <filter> )     test if a filter is computable
##
##  This was posted to the \GAP forum by Thomas Breuer at June 17,2005
##
InstallGlobalFunction("IsComputableFilter",
        function(filt)
    return IsFilter( filt )
           and FLAG2_FILTER( filt ) <> 0
           and (    IsInt( FLAG1_FILTER( filt ) )
                   or IsComputableFilter( FLAG1_FILTER( filt ) )
                   or IsComputableFilter( FLAG2_FILTER( filt ) ) );
end);

#############################################################################
##
#F  OnSubgroups(<subgroup>,<aut>)  Action on subgroups
##
InstallGlobalFunction("OnSubgroups",
        function(subgroup,aut)
    if IsTrivial(subgroup) then
        return subgroup;
    fi;
    return Group(Image(aut,GeneratorsOfGroup(subgroup)));
end);

#############################################################################
##
#F  OnSubgroups(<subgroupset>,<aut>)  Action on sets of subgroups
##
InstallGlobalFunction("OnSubgroupsSet",
        function(x,g)
    return Set(x,i->OnSubgroups(i,g));
end);


#############################################################################
##
#O  CartesianIterator( <tuplelist> )     returns an iterator for the cartesian product of <tuplelist>
##
InstallMethod(CartesianIterator,
        [IsList],
        function(tuplelists)
    local   position,  nextIterator,  isDoneIterator,  shallowCopy,  
            tuple_iterator;
    
    if Size(tuplelists)=0 or ForAny(tuplelists,i->Size(i)=0)
       then
        return Iterator([]);
    fi;
    position:=List([1..Size(tuplelists)],i->1);
    position[Size(position)]:=0;
    ##
    nextIterator:=function(iter)
        local depthcounter, sizes;
        depthcounter:=Size(iter!.data);
        sizes:=List(iter!.data,i->Size(i));
        while iter!.position[depthcounter]=Size(iter!.data[depthcounter]) and depthcounter>1 and not iter!.position=sizes
          do
            iter!.position[depthcounter]:=1;
            depthcounter:=depthcounter-1;
        od;
        if depthcounter=1 and iter!.position[1]<Size(iter!.data[1])
           then
            iter!.position[1]:=iter!.position[1]+1;
        elif iter!.position=sizes
          then
            return fail;
        else 
            iter!.position[depthcounter]:=iter!.position[depthcounter]+1;
        fi;
        return List([1..Size(iter!.data)],i->iter!.data[i][iter!.position[i]]);
    end;
    ##
    isDoneIterator:=function(iter)
        if iter!.position=List(iter!.data,Size)
           then 
            return true;
        else
            return false;
        fi;
    end;
    ##
    shallowCopy:=function(iter)
        local position,idata;
        idata:=ShallowCopy(iter!.data);
        position:=ShallowCopy(iter!.position);
        position[Size(position)]:=0;
        return rec(data:=idata,
                   position:=position,
                   ShallowCopy:=iter!.ShallowCopy,
                   IsDoneIterator:=iter!.IsDoneIterator,
                   NextIterator:=iter.NextIterator);
    end;
    tuple_iterator:=rec(data:=tuplelists,position:=position,
                        NextIterator:=nextIterator,
                        IsDoneIterator:=isDoneIterator,
                        ShallowCopy:=shallowCopy);
    return IteratorByFunctions(tuple_iterator);
end);

#############################################################################
##
#F  ConcatenationOfIterators(<iterlist>)   returns an iterator which is the concatenation of all iterators in <iterlist>.
##
InstallGlobalFunction("ConcatenationOfIterators",
        function(iterlist)
    local   iters,  nextIterator,  isDoneIterator,  shallowCopy;
    if iterlist=[] or ForAll(iterlist,IsDoneIterator)
       then
        return Iterator([]);
    fi;
    iters:=List(iterlist,i->ShallowCopy(i));
    iters:=Filtered(iters,i->not IsDoneIterator(i));
    ##
    nextIterator:=function(iter)
        local position;
        position:=iter!.position;
        while IsDoneIterator(iter!.iters[position]) and position<Size(iter!.iters)
          do
            position:=position+1;
        od;
        if IsDoneIterator(iter!.iters[position])
           then
            return fail;
        fi;
        iter!.position:=position;
        return NextIterator(iter!.iters[position]);
    end;
    ##
    isDoneIterator:=function(iter)
        if iter!.position=Size(iter!.iters) and IsDoneIterator(iter!.iters[iter!.position])
           then
            return true;
        else 
            return false;
        fi;
    end;
    ##
    shallowCopy:=function(iter)
        if ForAll(iter!.iters,IsDoneIterator)
           then
            return Iterator([]);
        else
            return rec(iters:=List(iter!.iters,i->ShallowCopy(i)),
                       position:=iter!.position,
                       IsDoneIterator:=iter!.IsDoneIterator,
                       NextIterator:=iter!.NextIterator,
                       ShallowCopy:=iter!.ShallowCopy);
        fi;
    end;
    ##
    return IteratorByFunctions(rec(iters:=iters,position:=1,IsDoneIterator:=isDoneIterator,NextIterator:=nextIterator,ShallowCopy:=shallowCopy));
end);

#############################################################################

InstallGlobalFunction("Pointwiseleq",
        function(list1,list2)
    local indices;
    if Size(list1)<>Size(list2)
       then 
        Error("Can't compare lists of different Size");
    fi;
    indices:=[1..Size(list1)];
    if ForAny(indices,i->list1[i]>list2[i])
       then
        return false;
    else 
        return true;
    fi;
end);


#############################################################################

InstallMethod(RemovedSublist,
        [IsList,IsList],
        function(list,sublist)
    local   llist,  lslist,  i;
    if not IsSubset(Set(list),Set(sublist))
       then 
        Error("sublist must be a SUBLIST of list ");
    fi;
    llist:=StructuralCopy(list);
    lslist:=StructuralCopy(sublist);
    for i in [1..Size(lslist)]
      do
        Unbind(llist[Position(llist,lslist[i])]);
        Unbind(lslist[i]);
    od;
    if (not Size(Compacted(llist))+Size(sublist)=Size(list))
       then 
        return fail;
    fi;
    return Compacted(llist);
end);


#############################################################################

InstallMethod(PartitionByFunctionNF,"for finite lists",
        [IsSmallList,IsFunction],
        function(list,func)
    local   vallist,  llist,  valset,  failpos,  ad,  valad,  
            return_list;

    vallist:=List(list,l->func(l));
    llist:=StructuralCopy(list);
    SortParallel(vallist,llist);
    valset:=Set(vallist);

    if Size(valset)=1 and valset<>[fail]
       then 
        return [llist];
    fi;

    if fail in valset
       then
        Error("function returned <fail>");
    fi; 
    ## erste Position, auf der val erscheint ##
    valad:=List(valset,val->PositionSorted(vallist,val));
    return_list:=[];

    for ad in [2..Size(valad)]
      do
        Add(return_list,llist{[valad[ad-1]..valad[ad]-1]});
    od;
    Add(return_list,llist{[valad[Size(valad)]..Size(llist)]});

    return return_list;
end);

#############################################################################

InstallMethod(PartitionByFunction,
        [IsDenseList,IsFunction],
        function(list,func)
    local   vallist,  llist,  valset,  failpos,  ad,  valad,  
            return_list;
    
    vallist:=List(list,l->func(l));
    llist:=List(list);
    SortParallel(vallist,llist);
    valset:=Set(vallist);
    if Size(valset)=1 and valset<>[fail]
       then 
        return [llist];
    fi;
    
    if fail in valset
       then
        if Size(valset)=1
           then
            return [];
        else
            RemoveSet(valset,fail);
            failpos:=Filtered([1..Size(vallist)],i->vallist[i]=fail);
            Info(InfoRDS,2,"-",Size(failpos),"-\c");
            for ad in failpos
              do
                Unbind(llist[ad]);
                Unbind(vallist[ad]);
            od;
            llist:=Compacted(llist);
            vallist:=Compacted(vallist);
            if Size(valset)=1
               then
                return [llist];
            fi;
        fi;
    fi; 
    
    ## erste Position, auf der val erscheint ##
    valad:=List(valset,val->PositionSorted(vallist,val));
    return_list:=[];
    
    for ad in [2..Size(valad)]
      do
        Add(return_list,llist{[valad[ad-1]..valad[ad]-1]});
    od;
    Add(return_list,llist{[valad[Size(valad)]..Size(llist)]});

    return return_list;
end);


#############################################################################
##
#O RepsCClassesGivenOrder( group, order ) find all elements of given order up to conjugacy.
##
##
InstallMethod(RepsCClassesGivenOrder,
        "for groups",
        [IsMagmaWithInverses,IsInt],
        function(group,order)
    local   groupset,  returnlist,  g,  gorder,  addg,  removeset;
    
    groupset:=Set(group);
    returnlist:=[];
    while groupset<>[]
      do
        g:=groupset[1];
        gorder:=Order(g);
        if gorder mod order=0
           then
            if order=gorder
               then
                Add(returnlist,g);
            else
                addg:=g^(gorder/order);
                if addg in groupset
                   then
                    Add(returnlist,addg);
                fi;
            fi;
        fi;
        removeset:=Set(ConjugacyClassSubgroups(group,SubgroupNC(group,[g])));
        Apply(removeset,Set);
        removeset:=Set(Flat(removeset));
        SubtractSet(groupset,removeset);
    od;
    return Set(returnlist);
end
);

#############################################################################
##
#O MatTimesTransMat(<mat>)
##
InstallMethod(MatTimesTransMat,
        [IsMatrix],
        function(mat)
    local   matdims,  rownumber,  colnumber,  returnmat,  row,  i,  
            mati,  j;

    matdims:=DimensionsMat(mat);
    rownumber:=matdims[1];
    colnumber:=matdims[2];
    returnmat:=NullMat(rownumber,rownumber);
    row:=ListWithIdenticalEntries(rownumber,0);
    for i in [1..rownumber-1]
      do
        mati:=mat[i];
        row[i]:=mati^2;
        for j in [i+1..rownumber]
          do
            row[j]:=mati*mat[j];
        od;
        returnmat[i]{[i..rownumber]}:=row{[i..rownumber]};
        returnmat{[i+1..rownumber]}[i]:=row{[i+1..rownumber]};
    od;
    returnmat[rownumber][rownumber]:=mat[rownumber]^2;
    return returnmat;
end);


#############################################################################
##
#E  END
##