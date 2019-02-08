#############################################################################
##
#W designs.gi 			 RDS Package		 Marc Roeder
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
#O  DevelopmentOfRDS( <set>,<data> )  generate block design from difference set
##
##
InstallMethod(DevelopmentOfRDS,[IsDenseList,IsObject],
        function(set,data)
    local   Gdata,  group,  v,  diffset,  permgroup,  design;
    if  IsGroup(data)
        then
        Gdata:=rec(G:=data,Glist:=AsSet(data));
    elif 
      IsRecord(data) and 
      IsBound(data.Glist) and 
      IsBound(data.G)
      then 
        Gdata:=data;
    elif IsSet(data) and (IsListOfIntegers(set) or IsSubset(data,set))
      then
        group:=Group(data);
        if Set(group)=data
           then
            Gdata:=rec(G:=group,Glist:=data);
        else
            Error("Please give the group as a group or the list of its elements");
        fi;
    else
        Error("wrong input");
    fi;
    
    v:=Size(Gdata.Glist);
    if not IsListOfIntegers(set) and IsSubset(Gdata.Glist,set)
      then
        diffset:=Set(set,i->PositionSet(Gdata.Glist,i));
        AddSet(diffset,1);
    elif not IsSubset([1..v],set)
      then
        Error("Difference set and group don't fit");
    else
        diffset:=Union(set,[1]);
    fi;
    permgroup:=Action(Gdata.G,Gdata.Glist,OnRight);
    design:=BlockDesign(v,[diffset],permgroup);
    if IsMutable(Gdata.Glist)
       then
        design.pointNames:=Immutable(Gdata.Glist);
    else
        design.pointNames:=Gdata.Glist;
    fi;
    design.blockSizes:=Immutable([Size(diffset)]);
    design.blockNumbers:=Immutable([Size(Gdata.Glist)]);
    design.isSimple:=true;
    design.isBinary:=true;
    return design;
end);


##############################################################################
###
##O ProjectivePlane(blocks)
###
InstallMethod(ProjectivePlane,[IsMatrix],
        function(blocks)  
    local   points,  lines,  v,  plane;

    points:=AsSet(Flat(blocks));
    lines:=AsSet(blocks);
    v:=Size(points);
    if not v=Size(lines)
       then
        Error("Numbers of points and blocks are different. This is not a projective plane!");
    fi;    
    
    # convert points and blocks from whatever to integers:
    lines:=Set(blocks,i->Set(i,j->PositionSet(points,j)));
    points:=[1..v];
    plane:=BlockDesign(v,lines);
    if not IsRange(points)
       then
        plane.pointNames:=lines;
    fi;
    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    else
        return plane;
    fi;
end);
    
    
#############################################################################
##
#O IsProjectivePlane(plane)
##
## Calculates if <plane> is symmetric with every point meeting as many lines
## as every line has points.
##
InstallMethod(IsProjectivePlane,
        [IsRecord],
        function(plane)
    local   blocksize,  jblock,  blocknr,  block,  p1,  i,  
            blocksinpoint;
    
    if not IsBlockDesign(plane)
       then
        Error("The projective plane must be a block design");
    elif IsBound(plane.isProjectivePlane) 
      then
        if plane.isProjectivePlane=true
           then
            return true;
        else
            return false;
        fi;
    fi;
    if plane.v<>Size(plane.blocks) or plane.v<7 or Size(Set(plane.blocks,Size))<>1
       then
        plane.isProjectivePlane:=false;
        return false;
    fi;
    blocksize:=Size(plane.blocks[1]);
    jblock:=NullMat(plane.v,plane.v);
    for blocknr in [1..plane.v]
      do
        block:=plane.blocks[blocknr];
        for p1 in [1..blocksize]
          do
            for i in [p1+1..blocksize] 
              do
                if jblock[block[p1]][block[i]]<>0
                   then
                    plane.isProjectivePlane:=false;
                    return false;
                else
                    jblock[block[p1]][block[i]]:=blocknr;
                    jblock[block[i]][block[p1]]:=blocknr;
                fi;
            od;
        od;
    od;
    plane.jblock:=jblock;
    blocksinpoint:=Set(plane.jblock,i->Number(i,j->j<>0));
    if not Size(blocksinpoint)=1 and blocksinpoint[1]=blocksize
       then
        plane.isProjectivePlane:=false;
        return false;
    fi;
    plane.isProjectivePlane:=true;
    plane.tSubsetStructure:=Immutable(rec(t:=2,lambdas:=[1]));
    plane.isConnected:=true;
    plane.blockSizes:=Immutable([Size(plane.blocks[1])]);
    plane.blockNumbers:=Immutable([Size(plane.blocks[1])]);
    plane.isSimple:=true;
    plane.isBinary:=true;
    return true;
end);

#############################################################################
##
#O PointJoiningLinesProjectivePlane
##
InstallMethod(PointJoiningLinesProjectivePlane,
        [IsRecord],
        function(plane)
    local   blocksize,  jpoint,  point,  pblocks,  b,  entrylist;
    
    if not IsProjectivePlane(plane)
       then
        Error("This is only defined for projective planes");
    elif IsBound(plane.jpoint)
      then
        return plane.jpoint;
    else
        blocksize:=Size(plane.blocks[1]);
        jpoint:=NullMat(plane.v,plane.v);
        for point in [1..plane.v]
          do
            pblocks:=Set(plane.jblock[point]);
            RemoveSet(pblocks,0);
            if not Size(pblocks)=blocksize
               then
                plane.isProjectivePlane:=false;
                Error("this is not a projective plane!");
            fi;
            for b in [1..blocksize]
              do
                entrylist:=List([b+1..blocksize],i->point);
                jpoint[pblocks[b]]{pblocks{[b+1..blocksize]}}:=entrylist;
                jpoint{pblocks{[b+1..blocksize]}}[pblocks[b]]:=entrylist;
            od;
        od;  
        plane.jpoint:=jpoint;
        MakeImmutable(plane.jpoint);
        return plane.jpoint;
    fi;
end);


#############################################################################
##
#E  END
##