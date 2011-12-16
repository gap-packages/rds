#############################################################################
##
#W plane_isomorphisms.gi 			 RDS Package		 Marc Roeder
##
##  Methods for calculations with projective planes
##
#H @(#)$Id: plane_isomorphisms.gi, v 0.9beta21 15/11/2006 19:33:30 gap Exp $
##
#Y	 Copyright (C) 2006 Marc Roeder 
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
Revision.("rds/lib/plane_isomorphisms_gi"):=
	"@(#)$Id: plane_isomorphisms.gi, v 0.9beta21 15/11/2006   19:33:30  gap Exp $";
#############################################################################
##
#O  DualPlane( <blocks> )  generate dual plane
##
InstallMethod(DualPlane,
        "for projective planes",
        [IsDenseList],
        function(blocks)
    local   points,  returnblocks,  image,  p,  locblocks,  dualblock;
    points:=[1..Size(Set(Flat(blocks)))];
    returnblocks:=[];
    image:=ListWithIdenticalEntries(Size(points),0);;
    for p in points
      do
        locblocks:=Filtered(blocks,b->p in b);
        dualblock:=Set(locblocks,b->Position(blocks,b));
        Add(returnblocks,dualblock);
        image[p]:=dualblock;
    od;
    return rec(blocks:=Set(returnblocks),image:=image);;
end);

#############################################################################
##
#O ProjectiveClosureOfPointSet(<points>,<maxsize>,<data>)
##
InstallMethod(ProjectiveClosureOfPointSet,
        "for projective planes",
        [IsDenseList,IsInt,IsRecord],
        function(points,maxsize,data)
    local   newpoints,  oldpoints,  newblocks,  oldblocks;
    newpoints:=[];
    oldpoints:=Set(points);
    newblocks:=Set(Combinations(oldpoints,2),i->data.jblock[i[1]][i[2]]);
    oldblocks:=[];
    if maxsize=0
       then
        maxsize:=Size(data.points)-1;
    fi;
    repeat
        newpoints:=Set(Cartesian(oldblocks,newblocks),i->Intersection(data.blocks[i[1]],data.blocks[i[2]])[1]);
        UniteSet(newpoints,List(Combinations(newblocks,2),i->Intersection(data.blocks[i[1]],data.blocks[i[2]])[1]));
        SubtractSet(newpoints,oldpoints);
        UniteSet(oldblocks,newblocks);
        newblocks:=Set(Cartesian(oldpoints,newpoints),i->data.jblock[i[1]][i[2]]);
        UniteSet(newblocks,List(Combinations(newpoints,2),i->data.jblock[i[1]][i[2]]));
        SubtractSet(newblocks,oldblocks);
        UniteSet(oldpoints,newpoints);
    until newpoints=[] or newblocks=[] or Size(oldpoints)+Size(newpoints)>maxsize;   
    if newpoints=[]
       then
        return oldpoints;
    else 
        return data.points;
    fi;
end);


#############################################################################
##
#O  IsIsomorphismOfProjectivePlanes( <perm>,<blocks1>,<blocks2> )  test for isomorphism of projective planes on the same points
##
InstallMethod(IsIsomorphismOfProjectivePlanes,
        "for projective planes",
        [IsPerm,IsDenseList,IsDenseList],
        function(perm,blocks1,blocks2)
    local   points,  point,  pointblocks,  pointblocks_image;

    points:=Set(Flat(blocks1));
    if not points=Set(Flat(blocks2))
       then
        Error("isomorphisms can only be tested for planes which have the same points");
    fi;
    return ForAll(blocks1,b->OnSets(b,perm) in blocks2);
end);


#############################################################################
##
#O  IsCollineationOfProjectivePlane( <perm>,<blocks> )  test if a permutation is a collineation of a projective plane
##
InstallMethod(IsCollineationOfProjectivePlane,
        "for projective planes",
        [IsPerm,IsDenseList],
        function(perm,blocks)
    return ForAll(blocks,b->OnSets(b,perm) in blocks);
end);

InstallMethod(IsCollineationOfProjectivePlane,
        "for projective planes",
        [IsPerm,IsRecord],
        function(perm,data)
    return IsCollineationOfProjectivePlane(perm,data.blocks);
end);


#############################################################################
##
#F  ElationPrecalc( <blocks> )  generate data for calculating elations
##
InstallGlobalFunction("ElationPrecalc",
        function(blocks)
    local   points,  lines,  strange,  jblock,  jpoint,  blocknr,  p,  
            i,  point,  pointblocks,  b,  blocksize,  block,  p1,  
            entrylist,  pblocks;

    points:=AsSet(Flat(blocks));
    lines:=AsSet(blocks);
    if not Size(points)=Size(lines)
       then
        Error("Numbers of points and blocks are different. You may proceed, but be warned!");
        strange:=true;
    else 
        strange:=false;
    fi;    
    jblock:=NullMat(Maximum(points),Maximum(points));
    jpoint:=NullMat(Size(lines),Size(lines));

    if strange
       then
        for blocknr in [1..Size(lines)]
          do
            for p in block
              do
                jblock[p]{block}:=List([1..Size(block)],i->blocknr);
            od;
        od;
        for i in [1..Size(lines)]
          do
            jblock[i][i]:=0;
        od;
            
        for point in points
          do
            pointblocks:=Filtered(lines,i->point in i);
            pointblocks:=Set(pointblocks,i->PositionSet(lines,i));
            for b in pointblocks
              do
                jpoint[b]{pointblocks}:=List([1..Size(pointblocks)],i->point);
            od;
        od;
        for i in [1..Size(jpoint)]
          do
            jpoint[i][i]:=0;
        od;
    else
        blocksize:=Size(lines[1]);
        for blocknr in [1..Size(lines)]
          do
            block:=lines[blocknr];
            for p1 in [1..blocksize]
              do
                entrylist:=List([p1+1..blocksize],i->blocknr);
                jblock[block[p1]]{block{[p1+1..blocksize]}}:=entrylist;
                jblock{block{[p1+1..blocksize]}}[block[p1]]:=entrylist;
            od;
        od;
        for point in points
          do
            pblocks:=Set(jblock[point]);
            RemoveSet(pblocks,0);
            blocksize:=Size(pblocks);
            for b in [1..blocksize]
              do
                entrylist:=List([b+1..blocksize],i->point);
                jpoint[pblocks[b]]{pblocks{[b+1..blocksize]}}:=entrylist;
                jpoint{pblocks{[b+1..blocksize]}}[pblocks[b]]:=entrylist;
            od;
        od;
    fi;
    return rec(jpoint:=jpoint,jblock:=jblock,points:=points,blocks:=lines);
end);


#############################################################################
##
#F  ElationPrecalcSmall( <blocks> )  generate data for calculating elations
##
InstallGlobalFunction("ElationPrecalcSmall",
        function(blocks)
    local   points,  lines,  nrofblocks,  jblock,  blocksize,  
            blocknr,  block,  p1,  entrylist;

    points:=AsSet(Flat(blocks));
    lines:=AsSet(blocks);
    nrofblocks:=Size(lines);
    if not Size(points)=nrofblocks
       then
        Error("Numbers of points and blocks are different. This is not permitted");
    fi;    
    jblock:=NullMat(nrofblocks,nrofblocks);
    blocksize:=Size(lines[1]);
    for blocknr in [1..nrofblocks]
      do
        block:=lines[blocknr];
        for p1 in [1..blocksize]
          do
            entrylist:=List([p1+1..blocksize],i->blocknr);
            jblock[block[p1]]{block{[p1+1..blocksize]}}:=entrylist;
            jblock{block{[p1+1..blocksize]}}[block[p1]]:=entrylist;
        od;
    od;
    return rec(jblock:=jblock,points:=points,blocks:=lines);
end);


#############################################################################
##
#O  ElationsByPairs( <centre>,<axis>,<pairs>,<data>)  calculate elations of projective planes.
#O  ElationsByPairs( <centre>,<axis>,<pairs>,<blocks>)  calculate elations of projective planes.
##
InstallMethod(ElationsByPairs,
        "for projective planes",
        [IsInt,IsDenseList,IsDenseList,IsRecord],
        function(centre,axis,pairs,data)
    local   blocks,  points,  jpoint,  jblock,  blockslist,  axispos,  
            init_cblocks,  axispoints,  returnlist,  pair,  permlist,  
            cblocks,  projpairs,  pairblock,  point,  pblock1,  
            pblock2,  cblock,  x,  y,  cblockpair,  nogood,  ppair,  
            perm;


    blocks:=data.blocks;
    points:=data.points;
    jpoint:=data.jpoint;
    jblock:=data.jblock;

    # die Punkte muessen integers sein!
    if not axis in blocks
       then 
        Error("The axis must be a block");
        return fail;
    fi;
    blockslist:=[1..Size(blocks)];    
    axispos:=Position(blocks,axis);

    init_cblocks:=Difference(Set(jblock[centre]),[0]);
    RemoveSet(init_cblocks,axispos);

    axispoints:=Difference(axis,[centre]);

    returnlist:=[];

    for pair in pairs
      do
        if Intersection(pair,axis)<>[] 
           then 
            Error("The axis must be fixed pointwise");
            return fail;
        fi;
        permlist:=[1..Maximum(points)];
        cblocks:=ShallowCopy(init_cblocks);
        projpairs:=[];
        pairblock:=jblock[pair[1]][pair[2]];

        if not centre in blocks[pairblock] 
           then 
            Error("The centre must be fixed blockwise");
            return fail;
        fi;
        RemoveSet(cblocks,pairblock);

        for point in axispoints 
          do
            pblock1:=jblock[point][pair[1]];
            pblock2:=jblock[point][pair[2]];
            for cblock in cblocks
              do
                x:=jpoint[cblock][pblock1];
                y:=jpoint[cblock][pblock2];
                Add(projpairs,[x,y]);
            od;
        od;            
        cblockpair:=Representative(projpairs);
        cblock:=jblock[cblockpair[1]][cblockpair[2]];

        for point in axispoints
          do
            pblock1:=jblock[point][cblockpair[1]];
            pblock2:=jblock[point][cblockpair[2]];
            x:=jpoint[pblock1][pairblock];
            y:=jpoint[pblock2][pairblock];
            Add(projpairs,[x,y]);
        od;
        nogood:=false;

        for ppair in projpairs
          do
            if permlist[ppair[1]] in [ppair[1],ppair[2]] 
               then
                permlist[ppair[1]]:=ppair[2];
            else
                nogood:=true;
            fi;
        od;

        if not nogood
           then
            perm:=PermList(permlist);
            if IsCollineationOfProjectivePlane(perm,data)
               then
                Add(returnlist,perm);
            fi;
        fi;
    od;
    return Set(returnlist);
end);


#############################################################################
##
#O  ElationsByPairsSmall( <centre>,<axis>,<pairs>,<data>)  calculate elations of projective planes.
##
InstallMethod(ElationsByPairsSmall,
        "for projective planes",
        [IsInt,IsDenseList,IsDenseList,IsRecord],
        function(centre,axis,pairs,data)
    local   blocks,  points,  jblock,  blockslist,  axispos,  
            init_cblocks,  axispoints,  returnlist,  pair,  permlist,  
            cblocks,  projpairs,  pairblock,  point,  pblock1,  
            pblock2,  cblock,  x,  y,  cblockpair,  nogood,  ppair,  
            perm;


    blocks:=data.blocks;
    points:=data.points;
    jblock:=data.jblock;
    
    # die Punkte muessen integers sein!
    if not axis in blocks
       then 
        Error("The axis must be a block");
        return fail;
    fi;
    if not centre in axis
       then
        Error("The centre must lie on the axis");
        return fail;
    fi;
    blockslist:=[1..Size(blocks)];    
    axispos:=PositionSet(blocks,axis);

    init_cblocks:=Set(Filtered(blocks,b->centre in b));
    RemoveSet(init_cblocks,axis);

    axispoints:=Difference(axis,[centre]);
    
    returnlist:=[];

    for pair in pairs
      do
        if pair[1]=pair[2]
           then
            Error("There can only be one axis.");
        fi;
        if Intersection(pair,axis)<>[] 
           then 
            Error("The axis must be fixed pointwise");
            return fail;
        fi;
        permlist:=[1..Maximum(points)];
        cblocks:=ShallowCopy(init_cblocks);
        projpairs:=[];
        pairblock:=blocks[jblock[pair[1]][pair[2]]];

        if not centre in pairblock 
           then 
            Error("The centre must be fixed blockwise");
            return fail;
        fi;
        RemoveSet(cblocks,pairblock);

        for point in axispoints 
          do
            pblock1:=blocks[jblock[point][pair[1]]];
            pblock2:=blocks[jblock[point][pair[2]]];
            for cblock in cblocks
              do
#                x:=First(cblock,i->i in pblock1);
#                y:=First(cblock,i->i in pblock2);
                x:=Intersection2(cblock,pblock1)[1];
                y:=Intersection2(cblock,pblock2)[1];
                Add(projpairs,[x,y]);
            od;
        od;            
        cblockpair:=Representative(projpairs);
        cblock:=blocks[jblock[cblockpair[1]][cblockpair[2]]];
        for point in axispoints
          do
            pblock1:=blocks[jblock[point][cblockpair[1]]];
            pblock2:=blocks[jblock[point][cblockpair[2]]];
#            x:=First(pblock1,i->i in pairblock);
#            y:=First(pblock2,i->i in pairblock);
            x:=Intersection2(pblock1,pairblock)[1];
            y:=Intersection2(pblock2,pairblock)[1];
            Add(projpairs,[x,y]);
        od;
        nogood:=false;

        for ppair in projpairs
          do
            if permlist[ppair[1]] in [ppair[1],ppair[2]] 
               then
                permlist[ppair[1]]:=ppair[2];
            else
                nogood:=true;
                Error("panik");
            fi;
        od;

        if not nogood
           then
            perm:=PermList(permlist);
            if IsCollineationOfProjectivePlane(perm,data)
               then
                Add(returnlist,perm);
            fi;
        fi;
    od;
    return Set(returnlist);
end);


#############################################################################
##
#O  AllElationsCentAx( <centre>,<axis>,<data>)  calculate all elations
#O  AllElationsCentAx( <centre>,<axis>,<blocks>)  calculate all elations
#O  AllElationsCentAx( <centre>,<axis>,<blocks>,"generators")  calculate all elations
##
InstallMethod(AllElationsCentAx,
        "for projective planes",
        [IsInt,IsDenseList,IsRecord],
        function(centre,axis,data)
    return Set(Group(AllElationsCentAx(centre,axis,data,"generators")));
end);

InstallMethod(AllElationsCentAx,
        "for projective planes",
        [IsInt,IsDenseList,IsRecord,IsString],
        function(centre,axis,data,genstring)
    local   blocks,  ellist,  pairs,  block,  pointset,  point,  
            genset,  pointsetsize,  newelations;

    if not genstring="generators"
       then
        Error("please pass >generators< as an option");
    fi;
    blocks:=data.blocks;
    ellist:=[];
    pairs:=[];

    block:=First(blocks,b->centre in b and not b=axis);
    pointset:=Difference(block,[centre]);
    point:=Representative(pointset);
    RemoveSet(pointset,point);

    genset:=[];       
    while pointset<>[]
      do
        pointsetsize:=Size(pointset);
        newelations:=ElationsByPairs(centre,axis,[[point,pointset[pointsetsize]]],data);
        Unbind(pointset[pointsetsize]);
        if newelations<>[]
           then
            Append(genset,newelations);
            SubtractSet(pointset,Orbit(Group(genset),point));
        fi;
    od;

    return genset;
end);




#############################################################################
##
#O  AllElationsCentAxSmall( <centre>,<axis>,<data>)  calculate all elations
#O  AllElationsCentAxSmall( <centre>,<axis>,<data>,"generators")  calculate all elations
##
InstallMethod(AllElationsCentAxSmall,
        "for projective planes",
        [IsInt,IsDenseList,IsRecord],
        function(centre,axis,data)
    return Set(Group(AllElationsCentAxSmall(centre,axis,data,"generators")));
end);

InstallMethod(AllElationsCentAxSmall,
        "for projective planes",
        [IsInt,IsDenseList,IsRecord,IsString],
        function(centre,axis,data,genstring)
    local   blocks,  ellist,  pairs,  block,  pointset,  point,  
            genset,  pointsetsize,  newelations;

    if not genstring="generators"
       then
        Error("please pass >generators< as an option");
    fi;
    blocks:=data.blocks;
    ellist:=[];
    pairs:=[];

    block:=First(blocks,b->(centre in b and not b=axis));
    pointset:=Difference(block,[centre]);
    point:=Representative(pointset);
    RemoveSet(pointset,point);

    genset:=[];       
    while pointset<>[]
      do
        pointsetsize:=Size(pointset);
        newelations:=ElationsByPairsSmall(centre,axis,[[point,pointset[pointsetsize]]],data);
        Unbind(pointset[pointsetsize]);
        if newelations<>[]
           then
            Append(genset,newelations);
            SubtractSet(pointset,Orbit(Group(genset),point));
        fi;
    od;
    return genset;
end);


#############################################################################
##
#O  AllElationsAx(<axis>,<data>)  calcualte all elations with given axis.
#O  AllElationsAxSmall(<axis>,<data>,"generators")  calcualte all elations with given axis.
#O  AllElationsAx(<axis>,<blocks>)  calcualte all elations with given axis.
#O  AllElationsAx(<axis>,<blocks>,"generators")  calcualte all elations with given axis.
InstallMethod(AllElationsAx,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(axis,data)
    return Set(Group(AllElationsAx(axis,data,"generators")));
end);

InstallMethod(AllElationsAx,
        "for projective planes",
        [IsDenseList,IsRecord,IsString],
        function(axis,data,genstring)
    local   points,  ellist,  centre;

    if not genstring="generators"
       then
        Error("please pass >generators< as an option");
    fi;
    points:=Difference(data.points,axis);
    ellist:=[];
    for centre in axis
      do
        if ellist<>[] and IsTransitive(Group(ellist),points)
           then 
            return Set(ellist);
        else
            Append(ellist,AllElationsCentAx(centre,axis,data,"generators"));
        fi;
    od;
    return Set(ellist);
end);


InstallMethod(AllElationsAxSmall,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(axis,data)
    return Set(Group(AllElationsAxSmall(axis,data,"generators")));
end);


InstallMethod(AllElationsAxSmall,
        "for projective planes",
        [IsDenseList,IsRecord,IsString],
        function(axis,data,genstring)
    local   ellist,  points,  centre;

    ellist:=[];
    if not genstring="generators"
       then
        Error("please pass >generators< as an option");
    fi;

    points:=Difference(data.points,axis);
    ellist:=[];
    for centre in axis
      do
        if ellist<>[] and IsTransitive(Group(ellist),points)
           then 
            return Set(ellist);
        else
            Append(ellist,AllElationsCentAxSmall(centre,axis,data,"generators"));
        fi;
    od;
    return Set(ellist);
end);

#############################################################################
##
#O IsTranslationPlane(<infline>,<planedata>)
##
InstallMethod(IsTranslationPlane,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(infline,data)
    local   cent1,  t1gens,  cent2,  t2gens;
    cent1:=Random(infline);
    t1gens:=AllElationsCentAx(cent1,infline,data,"generators");
    if t1gens=[] or Size(Group(t1gens))<>Size(infline)-1
       then 
        return false;
    else
        cent2:=Random(Difference(infline,[cent1]));
        t2gens:=AllElationsCentAx(cent2,infline,data,"generators");
    fi;
    #affpoints:=Difference(data.points,infline);
    #if IsTransitive(Group(Concatenation(t2gens,t1gens)),affpoints)
    if Size(Group(Concatenation(t2gens,t1gens)))=Size(data.points)-Size(infline)
       then
        return true;
    else
        return false;
    fi;
end);

#############################################################################
##
#O IsTranslationPlaneSmall(<infline>,<planedata>)
##
InstallMethod(IsTranslationPlaneSmall,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(infline,data)
    local   cent1,  t1gens,  cent2,  t2gens;
    cent1:=Random(infline);
    t1gens:=AllElationsCentAxSmall(cent1,infline,data,"generators");
    if t1gens=[] or Size(Group(t1gens))<>Size(infline)-1
       then 
        return false;
    else
        cent2:=Random(Difference(infline,[cent1]));
        t2gens:=AllElationsCentAxSmall(cent2,infline,data,"generators");
    fi;
    #affpoints:=Difference(data.points,infline);
    #if IsTransitive(Group(Concatenation(t2gens,t1gens)),affpoints)
    if Size(Group(Concatenation(t2gens,t1gens)))=Size(data.points)-Size(infline)
       then
        return true;
    else
        return false;
    fi;
end);

#############################################################################
##
#O GroupOfHomologiesSmall(<cetre>,<axis>,<planedata>) 
##
InstallMethod(GroupOfHomologiesSmall,
        "for projective planes",
        [IsInt,IsDenseList,IsRecord],
        function(centre,axis,data)
    local   line,  pointset,  point,  genlist,  
            pointsetsize,  newhomology;

    line:=data.blocks[data.jblock[centre][axis[1]]];
    pointset:=Difference(line,[centre,axis[1]]);
    point:=pointset[1];
    RemoveSet(pointset,point);
    genlist:=[];
    while pointset<>[]
      do
        pointsetsize:=Size(pointset);
        newhomology:=HomologyByPairSmall(centre,axis,[point,pointset[pointsetsize]],data);
        Unbind(pointset[pointsetsize]);                
        if not newhomology=fail
           then
            Add(genlist,newhomology);
            SubtractSet(pointset,Set(Orbit(Group(genlist),point)));
        fi;
    od;
    if genlist=[]
       then 
        return Group(());
    else 
        return Group(genlist);
    fi;
end);

#############################################################################
##
#O HomologyByPairSmall(<centre>,<axis>,<pair>,<data>);
##

InstallMethod(HomologyByPairSmall,
        "for projective planes",
        [IsInt,IsDenseList,IsDenseList,IsRecord],
        function(centre,axis,pair,data)
    local   points,  blocks,  jblock,  blockslist,  axispos,  cblocks,  
            returnlist,  permlist,  projpairs,  pairblock,  axpoint,  
            plineSource,  plineDest,  line,  ppoint,  point,  perm;
    points:=data.points;
    blocks:=data.blocks;
    jblock:=data.jblock;
    if  not axis in blocks
        then 
        Error("The axis must be a block");
        return fail;
    fi;
    blockslist:=[1..Size(blocks)];    
    axispos:=PositionSet(blocks,axis);
    cblocks:=Set(Filtered(blocks,b->centre in b));
    if axis in cblocks
       then
        Error("The axis must not contain the centre");
        return fail;
    fi;
    returnlist:=[];
    if Intersection(pair,axis)<>[] 
       then 
        Error("The axis must be fixed pointwise");
        return fail;
    fi;
    permlist:=[1..Maximum(points)];
    permlist[pair[1]]:=pair[2];
    projpairs:=[];
    pairblock:=blocks[jblock[pair[1]][pair[2]]];
    if not centre in pairblock 
       then 
        Error("The centre must be fixed blockwise");
        return fail;
    fi;
    RemoveSet(cblocks,pairblock);

    for axpoint in Difference(axis,pairblock)
      do
        plineSource:=blocks[jblock[pair[1]][axpoint]];
        plineDest:=blocks[jblock[pair[2]][axpoint]];
        for line in cblocks
          do
            if not axpoint in line 
               then
                permlist[Intersection2(plineSource,line)[1]]:=Intersection2(plineDest,line)[1];
            fi;
        od;
    od;
    #and now the line <pair> lives on.
    line:=cblocks[1];
    ppoint:=First(axis,p->not (p in line or p in pairblock));
    for point in Difference(pairblock,Union(axis,[pair[1]],[centre]))
      do
        plineSource:=blocks[jblock[point][ppoint]];
        plineDest:=blocks[jblock[ppoint][permlist[Intersection(plineSource,line)[1]]]];
        permlist[point]:=Intersection(plineDest,pairblock)[1];
    od;
    perm:=PermList(permlist);
    if IsCollineationOfProjectivePlane(perm,data)
       then
        return perm;
    else 
        return fail;
    fi;
end);

#############################################################################
##
#O InducedCollineation(<baerdata>,<baercoll>,<point>,<image>,<planedata>,<liftingperm>)
##
InstallMethod(InducedCollineation,
        "for projective planes",
        [IsRecord,IsPerm,IsInt,IsInt,IsRecord,IsPerm],
        function(baerdata,baercoll,point,image,planedata,liftingperm)
    local   blocks,  jblock,  jpoint,  baerindices,  
            liftedcollineation,  pointtangents,  pointsecant,  
            pointsecantnr,  imagesecant,  fixpoint,  imagetangents,  
            shortimagesecant,  shortpointsecant,  baerblocks,  
            permlist,  tpoint,  tangent,  tangentimage,  secant,  p,  
            shortsecant,  secantimage,  ppoint,  ppointimage,  
            linepoint,  pline,  pointinbetween,  plineimage,  perm;

    blocks:=planedata.blocks;
    jblock:=planedata.jblock;
    jpoint:=planedata.jpoint;
    baerindices:=OnSets(baerdata.points,liftingperm);
    liftedcollineation:=RestrictedPerm(baercoll^liftingperm,baerindices);
    if (point in baerindices) or (image in baerindices)
       then
        Error("point and image must not lie in the Baer subplane");
        return fail;
    fi;
    pointtangents:=Set(blocks{Set(jblock[point]{baerindices})});
    pointsecant:=First(pointtangents,b->Size(Intersection(b,baerindices))>1);
    pointsecantnr:=PositionSet(blocks,pointsecant);

    if image in pointsecant
       then
        imagesecant:=pointsecant;
        if point=image
           then
            fixpoint:=true;
        else 
            fixpoint:=false;
        fi;
    else
        fixpoint:=false;
        imagetangents:=Set(blocks{Set(jblock[image]{baerindices})});
        imagesecant:=First(imagetangents,b->Size(Intersection(b,baerindices))>1);
        shortimagesecant:=Set(Intersection(imagesecant,baerindices));
        shortpointsecant:=Set(Intersection(pointsecant,baerindices));
        if OnSets(shortimagesecant,liftedcollineation)=shortimagesecant
           then
            Info(DebugRDS,1,"Wrong:point and image define different secants and image secant is fixed");
            return fail;
        fi;
        if 1 in OrbitLengths(Group(liftedcollineation),shortimagesecant)
           then
            #here a tangent would be mapped to a secant.
            #This is impossible.
            Info(DebugRDS,1,"Wrong:image secant contains a fixed point");
            return fail;
        fi;
    fi;
    shortimagesecant:=Set(Intersection(imagesecant,baerindices));
    shortpointsecant:=Set(Intersection(pointsecant,baerindices));
    if not OnSets(shortpointsecant,liftedcollineation)=shortimagesecant
       then
        Info(DebugRDS,1,"point secant is not mapped to image secant");
        return fail;    
    fi;
    baerblocks:=List(baerdata.blocks,b->OnSets(b,liftingperm));
    baerblocks:=Set(baerblocks,b->blocks[jblock[b[1]][b[2]]]);
    RemoveSet(baerblocks,pointsecant);
    permlist:=List(OnTuples(planedata.points,liftedcollineation));
    permlist[point]:=image;
    for tpoint in Difference(baerindices,pointsecant)
      do
        tangent:=blocks[jblock[tpoint][point]];
        tangentimage:=jblock[permlist[tpoint]][image];
        for secant in baerblocks
          do
            p:=Intersection(secant,tangent)[1];
            shortsecant:=Intersection(secant,baerindices);
            secantimage:=jblock[permlist[shortsecant[1]]][permlist[shortsecant[2]]];
            permlist[p]:=jpoint[secantimage][tangentimage];
        od;
    od;
    ppoint:=Representative(Difference(planedata.points,Concatenation(baerindices,pointsecant)));
    ppointimage:=permlist[ppoint];
    for linepoint in Difference(pointsecant,Concatenation(baerindices,[point]))
      do
        pline:=blocks[jblock[linepoint][ppoint]];
        pointinbetween:=First(pline,i->not i in [ppoint,linepoint]);
        plineimage:=jblock[permlist[pointinbetween]][ppointimage];
        permlist[linepoint]:=jpoint[pointsecantnr][plineimage];
    od;
    perm:=PermList(permlist);
    if perm=fail and not IsSubset(pointsecant,Set(Filtered(Collected(permlist),i->i[2]>1),j->j[1]))
       then
        Error("da gibt's noch ein Problem...");
    elif perm=fail
      then
        return fail;
    elif IsCollineationOfProjectivePlane(perm,planedata)
      then
        return perm;
    else 
        return fail;
    fi;
end);

#############################################################################
##
#O  NrFanoPlanesAtPoints(<points>,<data>)  invariant for projective planes
##
InstallMethod(NrFanoPlanesAtPoints,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(pointlist,data)
    local   returnlist,  points,  jblock,  jpoint,  blocks,  x,  
            nrfanos,  localblocks,  localblockssize,  points1size,  
            block1number,  block1,  points1,  block2number,  block2,  
            points2,  block3number,  block3,  point2number,  point2,  
            point3,  point4,  b24,  p24,  b34,  p34,  b324,  b234;
    
    
    returnlist:=[];
    points:=data.points;
    jblock:=data.jblock;
    jpoint:=data.jpoint;
    blocks:=data.blocks;
    ## Mal ein Bildchen, sonst verstehst Du es nie!
    for x in pointlist
      do
        nrfanos:=0;
        localblocks:=Difference(Set(jblock[x]),[0]);
        localblockssize:=Size(localblocks);
        points1size:=localblockssize-1;
        for block1number in [1..localblockssize-2]
          do
            block1:=localblocks[block1number];
            points1:=Difference(blocks[block1],[x]);
            for block2number in [block1number+1..localblockssize-1]
              do
                block2:=localblocks[block2number];
                points2:=Difference(blocks[block2],[x]);
                for block3number in [block2number+1..localblockssize]
                  do
                    block3:=localblocks[block3number];
                    for point2number in [1..points1size-1]
                      do
                        point2:=points1[point2number];
                        for point3 in points1{[point2number+1..points1size]}
                          do
                            for point4 in points2
                              do
                                b24:=jblock[point2][point4];
                                p24:=jpoint[block3][b24];
                                
                                b34:=jblock[point3][point4];
                                p34:=jpoint[block3][b34];
                                
                                b324:=jblock[point3][p24];
                                b234:=jblock[point2][p34];

                                if jpoint[block2][b234]=jpoint[block2][b324]
                                   then
                                    nrfanos:=nrfanos+1;
                                fi;
                            od;
                        od;
                    od;
                od;
            od;
        od;
        Add(returnlist,[x,nrfanos]);
    od;
    return returnlist;
end);


#############################################################################
##
#O  NrFanoPlanesAtPointsSmall(<pointlist>,<data>)  invariant for projective planes
##
InstallMethod(NrFanoPlanesAtPointsSmall,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(pointlist,data)
    local   returnlist,  points,  jblock,  blocks,  x,  nrfanos,  
            localblocks,  localblockssize,  points1size,  
            block1number,  block1,  points1,  block2number,  block2,  
            points2,  block3number,  block3,  points3,  point2number,  
            point2,  point3,  point4,  b24,  p24,  b34,  p34,  b324,  
            b234;
   
    returnlist:=[];
    points:=data.points;
    jblock:=data.jblock;
    blocks:=data.blocks;
    ## Mal ein Bildchen, sonst verstehst Du es nie!
    for x in pointlist
      do
        nrfanos:=0;
        localblocks:=Difference(Set(jblock[x]),[0]);
        localblockssize:=Size(localblocks);
        points1size:=localblockssize-1;
        for block1number in [1..localblockssize-2]
          do
            block1:=localblocks[block1number];
            points1:=AsSet(Difference(blocks[block1],[x]));
            for block2number in [block1number+1..localblockssize-1]
              do
                block2:=localblocks[block2number];
                points2:=AsSet(Difference(blocks[block2],[x]));
                for block3number in [block2number+1..localblockssize]
                  do
                    block3:=localblocks[block3number];
                    points3:=AsSet(blocks[block3]);
                    for point2number in [1..points1size-1]
                      do
                        point2:=points1[point2number];
                        for point3 in points1{[point2number+1..points1size]}
                          do
                            for point4 in points2
                              do
                                b24:=jblock[point2][point4];
                                p24:=Intersection(points3,blocks[b24])[1];
                                
                                b34:=jblock[point3][point4];
                                p34:=Intersection(points3,blocks[b34])[1];
                                
                                b324:=jblock[point3][p24];
                                b234:=jblock[point2][p34];

                                if Intersection(points2,blocks[b234])=Intersection(points2,blocks[b324])
                                   then
                                    nrfanos:=nrfanos+1;
                                fi;
                            od;
                        od;
                    od;
                od;
            od;
        od;
        Add(returnlist,[x,nrfanos]);
    od;
    return returnlist;
end);


#############################################################################
##
#O IncidenceMatrix(<points>,<blocks>)
#O IncidenceMatrix(<planedata>)
##
InstallMethod(IncidenceMatrix,
        [IsDenseList,IsDenseList],
        function(pointlist,blocklist)
    local   pointnumber,  blocknumber,  mat,  blocksize,  blocknr;

    if not IsListOfIntegers(pointlist) and ForAll(blocklist,b->IsListOfIntegers(b))
       then
        Error("the points are assumed to be integers");
    fi;
    pointnumber:=Size(pointlist);
    blocknumber:=Size(blocklist);
    mat:=NullMat(pointnumber,blocknumber);
    blocksize:=Size(blocklist[1]);
    for blocknr in [1..blocknumber]
      do
        mat{blocklist[blocknr]}[blocknr]:=List([1..blocksize],i->1);
    od; 
    return mat;    
end);

InstallMethod(IncidenceMatrix,
        [IsRecord],
        function(planedata)
    return IncidenceMatrix(planedata.points,planedata.blocks);
end);

#############################################################################
##
#O pRank(<blocklist>,<p>)
#O pRank(<planedata>,<p>)
##
InstallMethod(pRank,
        "for projective planes",
        [IsDenseList,IsInt],
        function(blocklist,p)
    local   pointlist;

    if not Size(FactorsInt(p))=1
       then
        Error("<p> must be a primepower");
    fi;
    if not (Set(blocklist,Size)=[Size(blocklist[1])] and Size(Set(Flat(blocklist)))=Size(blocklist))
       then
        Error("not a projective plane");
    fi;
    pointlist:=Set(Flat(blocklist));
    return RankMatDestructive(IncidenceMatrix(pointlist,blocklist)*Z(p));
end);

InstallMethod(pRank,
        "for projective planes",
        [IsRecord,IsInt],
        function(planedata,p)
    return pRank(planedata.blocks,p);
end);

#############################################################################
##
#O FingerprintAntiFlag(<point>,<linenr>,<data>)
##
InstallMethod(FingerprintAntiFlag,
        [IsInt,IsInt,IsRecord],
        function(point,linenr,data)
    local   infline,  lblocks,  mat,  lpoint,  projlines,  lblock,  
            permlist,  pointnr,  lblockpoint;

    if point in data.blocks[linenr]
       then
        Error("This is not an anti- flag!");
    fi;
    infline:=data.blocks[linenr];
    lblocks:=Set(data.jblock[point]);
    RemoveSet(lblocks,0);
    Apply(lblocks,i->data.blocks[i]);

    mat:=NullMat(Size(infline),Size(infline));;
    for lpoint in infline
      do
        projlines:=Set(data.jblock[lpoint]);
        RemoveSet(projlines,0);
        Apply(projlines,i->data.blocks[i]);
        for lblock in Filtered(lblocks,b->not lpoint in b)
          do
            permlist:=[1..Size(lblock)];
            for pointnr in [1..Size(lblock)]
              do
                lblockpoint:=lblock[pointnr];
                permlist[pointnr]:=PositionProperty(projlines,b->lblockpoint in b);
            od;
            mat[PositionSet(infline,lpoint)][PositionSet(lblocks,lblock)]:= SignPerm(PermList(permlist));

        od;
    od;
    #    return Collected(List(Concatenation(mat*TransposedMat(mat)),AbsoluteValue));    
    return Collected(List(Concatenation(MatTimesTransMat(mat)),AbsoluteValue));    
end);

#############################################################################
##
#O FingerprintProjPlane(<data>)
##
InstallMethod(FingerprintProjPlane,
        [IsRecord],
        function(data)
    return FingerprintProjPlane(data.blocks);
end);

#############################################################################
##
#O FingerprintProjPlane(<blocks>)
##
InstallMethod(FingerprintProjPlane,
        [IsDenseList],
        function(blocks)
    local   nrOfBlocks,  mat,  points,  point,  lblocks,  
            lblocksindex,  linenr,  line,  permlist,  pointnr;
    
    if not IsSet(blocks) and ForAll(blocks,IsSet)
      then
        Error("blocklist must be a set of sets");
    fi;
    nrOfBlocks:=Size(blocks);
    mat:=NullMat(nrOfBlocks,nrOfBlocks);
    points:=Set(Flat(blocks));
    for point in points
      do
        lblocks:=Set(Filtered(blocks,b->point in b));
        lblocksindex:=Set(lblocks,b->PositionSet(blocks,b));
        for linenr in Difference([1..nrOfBlocks],lblocksindex)
          do
            line:=blocks[linenr];
            permlist:=[1..Size(line)];
            for pointnr in [1..Size(line)]
              do
                permlist[pointnr]:=PositionProperty(lblocks,b->line[pointnr] in
 b);
            od;
            mat[point][linenr]:=SignPerm(PermList(permlist));
        od;
    od;
    return Collected(List(Concatenation(MatTimesTransMat(mat)),AbsoluteValue));    
end);

#############################################################################
##
#O IsomorphismProjPlanesByGenerators(<gens1>,<data1>,<gens2>,<data2>)
##
InstallMethod(IsomorphismProjPlanesByGenerators,
        "for projective planes",
        [IsDenseList,IsRecord,IsDenseList,IsRecord],
        function(gens1,data1,gens2,data2)
    local   N,  hasfailed;
    
    N:=Size(data1.points);
    hasfailed:=false;
    if not Size(data2.points)=N
       then
        Error("The planes must be of the same size");
        hasfailed:=true;
    fi;
    if not data1.points=data2.points
       then 
        Error("The planes must live on the same points");
        hasfailed:=true;
    fi;
    if (not Size(ProjectiveClosureOfPointSet(gens1,0,data1))=N)
       or (not Size(ProjectiveClosureOfPointSet(gens2,0,data2))=N)
      then
        hasfailed:=true;
    fi;
    if not hasfailed 
       then
        return IsomorphismProjPlanesByGeneratorsNC(gens1,data1,gens2,data2);
    else 
        return fail;
    fi;
end);
      
#############################################################################
##
#O IsomorphismProjPlanesByGeneratorsNC(<gens1>,<data1>,<gens2>,<data2>)
##
InstallMethod(IsomorphismProjPlanesByGeneratorsNC,
        "for projective planes",
        [IsDenseList,IsRecord,IsDenseList,IsRecord],
        function(gens1,data1,gens2,data2)
    local   newpoints,  oldpoints,  newblocks,  pointimagelist,  
            blockimagelist,  pair,  oldblocks,  x,  iso;
    
    if Size(gens1)<>Size(gens2)
       then
        Error("<gens1> and <gens2> must be of the same length!");
    fi;
    newpoints:=[];
    oldpoints:=Set(gens1);
    newblocks:=[];
    pointimagelist:=ListWithIdenticalEntries(Size(data2.points),0);
    pointimagelist{gens1}:=gens2;
    blockimagelist:=ListWithIdenticalEntries(Size(data2.blocks),0);
    newblocks:=Set(Combinations(oldpoints,2),i->
                   [data1.jblock[i[1]][i[2]],
                    data2.jblock[pointimagelist[i[1]]][pointimagelist[i[2]]]]);
    if Size(Set(newblocks,i->i[1]))<>Size(Set(newblocks,i->i[1]))
       then
        Info(DebugRDS,2,"bad generators");
        return fail;
    fi;
    for pair in newblocks
      do
        blockimagelist[pair[1]]:=pair[2];
    od;
    newblocks:=Set(newblocks,i->i[1]);
    oldblocks:=[];
    repeat
        newpoints:=Set(Cartesian(oldblocks,newblocks),i->
                       [Intersection(data1.blocks[i[1]],data1.blocks[i[2]])[1],
                        Intersection(data2.blocks[blockimagelist[i[1]]],data2.blocks[blockimagelist[i[2]]])[1]]);
        UniteSet(newpoints,List(Combinations(newblocks,2),i->
                [Intersection(data1.blocks[i[1]],data1.blocks[i[2]])[1],
                 Intersection(data2.blocks[blockimagelist[i[1]]],data2.blocks[blockimagelist[i[2]]])[1]]));
        for pair in newpoints
          do
            x:=pair[1];
            if pointimagelist[x]<>0 and pair[2]<>pointimagelist[x]
               then 
                return fail;
            elif pointimagelist[x]=0
              then
                pointimagelist[x]:=pair[2];
            fi;
        od;           
        
        if Number(pointimagelist,i->i=0)<>0
           then
            newpoints:=Difference(Set(newpoints,i->i[1]),oldpoints);
            UniteSet(oldblocks,newblocks);
            newblocks:=Set(Cartesian(oldpoints,newpoints),i->
                           [data1.jblock[i[1]][i[2]],
                            data2.jblock[pointimagelist[i[1]]][pointimagelist[i[2]]]]
                           );
            UniteSet(newblocks,List(Combinations(newpoints,2),i->
                    [data1.jblock[i[1]][i[2]],
                     data2.jblock[pointimagelist[i[1]]][pointimagelist[i[2]]]
                     ]
                    ));
            for pair in newblocks
              do
                x:=pair[1];
                if blockimagelist[x]<>0 and pair[2]<>blockimagelist[x]
                   then 
                    return fail;
                elif blockimagelist[x]=0
                  then
                    blockimagelist[x]:=pair[2];
                fi;
            od;           
            newblocks:=Difference(Set(newblocks,i->i[1]),oldblocks);
            UniteSet(oldpoints,newpoints);
        else 
            newpoints:=[];
        fi;
    until newpoints=[];    
    iso:=PermListList(data1.points,pointimagelist);
    if IsPerm(iso) and IsIsomorphismOfProjectivePlanes(iso,data1.blocks,data2.blocks)
       then
        return iso;
    else 
        return fail;
    fi;
end);

##############################################################################
##
#E