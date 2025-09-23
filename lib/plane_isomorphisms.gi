#############################################################################
##
#W plane_isomorphisms.gi 			 RDS Package		 Marc Roeder
##
##  Methods for calculations with projective planes
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
##############################################################################
###
##O  DualPlane( <plane> )  generate dual plane
###
#InstallMethod(DualPlane,
#        "for projective planes",
#        [IsRecord],
#        function(plane)
#    local   points,  returnblocks,  image,  p,  locblocks,  dualblock;
#    if not IsBlockDesign(plane)
#       then
#        Error("projective plane must be a block design");
#    fi;
#    points:=[1..plane.v];
#    returnblocks:=[];
#    image:=ListWithIdenticalEntries(Size(points),0);;
#    for p in points
#      do
#        locblocks:=Filtered(blocks,b->p in b);
#        dualblock:=Set(locblocks,b->Position(blocks,b));
#        Add(returnblocks,dualblock);
#        image[p]:=dualblock;
#    od;
#    return rec(blocks:=Set(returnblocks),image:=image);;
#end);
#
#############################################################################
##
#O ProjectiveClosureOfPointSet(<points>,<plane>)
##
InstallMethod(ProjectiveClosureOfPointSet,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(points,plane)
    return ProjectiveClosureOfPointSet(points,0,plane);
end);
    
#############################################################################
##
#O ProjectiveClosureOfPointSet(<points>,<maxsize>,<plane>)
##
InstallMethod(ProjectiveClosureOfPointSet,
        "for projective planes",
        [IsDenseList,IsInt,IsRecord],
        function(points,maxsize,plane)
    local   newpoints,  oldpoints,  newblocks,  oldblocks,  
            returnplane,  embedding,  invemb;

    if not IsProjectivePlane(plane)
       then
        TryNextMethod();
    fi;
    newpoints:=[];
    oldpoints:=Set(points);
    newblocks:=Set(Combinations(oldpoints,2),i->plane.jblock[i[1]][i[2]]);
    oldblocks:=[];
    if maxsize=0
       then
        maxsize:=plane.v-1;
    fi;
    repeat
        newpoints:=Set(Cartesian(oldblocks,newblocks),i->Intersection(plane.blocks[i[1]],plane.blocks[i[2]])[1]);
        UniteSet(newpoints,List(Combinations(newblocks,2),i->Intersection(plane.blocks[i[1]],plane.blocks[i[2]])[1]));
        SubtractSet(newpoints,oldpoints);
        UniteSet(oldblocks,newblocks);
        newblocks:=Set(Cartesian(oldpoints,newpoints),i->plane.jblock[i[1]][i[2]]);
        UniteSet(newblocks,List(Combinations(newpoints,2),i->plane.jblock[i[1]][i[2]]));
        SubtractSet(newblocks,oldblocks);
        UniteSet(oldpoints,newpoints);
    until newpoints=[] or newblocks=[] or Size(oldpoints)>maxsize;   
    
    if Size(oldpoints)>maxsize
       then
        oldpoints:=[1..plane.v];
    fi;
    if oldpoints=[1..plane.v]
       then 
        returnplane:=plane;
        embedding:=();
    elif Size(oldpoints)=1
      then
        embedding:=(1,oldpoints[1]);
        returnplane:=BlockDesign(1,[[1]]);
    else
        newblocks:=Set(plane.blocks,i->Intersection(i,oldpoints));
        newblocks:=Filtered(newblocks,i->Size(i)>1);
        embedding:=MappingPermListList([1..Size(oldpoints)],Set(oldpoints));
        invemb:=embedding^-1;
        Apply(newblocks,i->OnSets(i,invemb));
        if Number(newblocks,b->Size(b)>2)<7
           then
            returnplane:=BlockDesign(Size(oldpoints),newblocks);
        else
            newblocks:=Filtered(newblocks,i->Size(i)>2);
            returnplane:=ProjectivePlane(newblocks);
            if IsBound(plane.jpoint)
               then
                PointJoiningLinesProjectivePlane(returnplane);
            fi;
        fi;             
    fi;
    if IsBound(plane.pointNames)
       then
        returnplane.pointNames:=Immutable(List([1..returnplane.v],i->
                                        plane.pointNames[i^embedding]));
    fi;
    return rec(closure:=returnplane,embedding:=embedding);
end);


#############################################################################
##
#O  IsIsomorphismOfProjectivePlanes( <perm>,<plane1>,<plane2> )  test for isomorphism of projective planes.
##
InstallMethod(IsIsomorphismOfProjectivePlanes,
        "for projective planes",
        [IsPerm,IsRecord,IsRecord],
        function(perm,plane1,plane2)
    local   points,  point,  pointblocks,  pointblocks_image;
    
    if not IsBlockDesign(plane1) and IsBlockDesign(plane2)
       then
        Error("this does just work for block designs");
    fi;
    points:=[1..plane1.v];
    return ForAll(plane1.blocks,b->OnSets(b,perm) in plane2.blocks);
end);


#############################################################################
##
#O  IsCollineationOfProjectivePlane( <perm>,<plane> )  test if a permutation is a collineation of a projective plane
##
InstallMethod(IsCollineationOfProjectivePlane,
        "for projective planes",
        [IsPerm,IsRecord],
        function(perm,plane)
    return IsIsomorphismOfProjectivePlanes(perm,plane,plane);
end);


#############################################################################
##
#O  ElationByPair( <centre>,<axis>,<pair>,<plane>)  calculate elations of projective planes.
##
InstallMethod(ElationByPair,
        "for projective planes",
        [IsInt,IsVector,IsVector,IsRecord],
        function(centre,axis,pair,plane)
    local   points,  blockslist,  axispos,  init_cblocks,  axispoints,  
            returnlist,  permlist,  cblocks,  projpairs,  pairblock,  
            point,  pblock1,  pblock2,  cblock,  x,  y,  cblockpair,  
            nogood,  ppair,  perm;
    
    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    
    if not IsBound(plane.jpoint)
       then
        TryNextMethod();
    fi;
    
    points:=[1..plane.v];
    
    if not IsSubset(points,pair)
       then
        Error("<pair> must be a pair of points");
    fi;

    if not axis in plane.blocks
       then 
        Error("The axis must be a block");
    fi;
    blockslist:=[1..plane.v];    
    axispos:=Position(plane.blocks,axis);
    
    init_cblocks:=Difference(Set(plane.jblock[centre]),[0]);
    RemoveSet(init_cblocks,axispos);

    axispoints:=Difference(axis,[centre]);

    returnlist:=[];

    if Intersection(pair,axis)<>[] 
       then 
        Error("The axis must be fixed pointwise");
    fi;
    permlist:=[1..plane.v];
    cblocks:=ShallowCopy(init_cblocks);
    projpairs:=[];
    pairblock:=plane.jblock[pair[1]][pair[2]];
    
    if not centre in plane.blocks[pairblock] 
       then 
        Error("The centre must be fixed blockwise");
    fi;
    RemoveSet(cblocks,pairblock);
    
    for point in axispoints 
      do
        pblock1:=plane.jblock[point][pair[1]];
        pblock2:=plane.jblock[point][pair[2]];
        for cblock in cblocks
          do
            x:=plane.jpoint[cblock][pblock1];
            y:=plane.jpoint[cblock][pblock2];
            Add(projpairs,[x,y]);
        od;
    od;            
    cblockpair:=Representative(projpairs);
    cblock:=plane.jblock[cblockpair[1]][cblockpair[2]];
    
    for point in axispoints
      do
        pblock1:=plane.jblock[point][cblockpair[1]];
        pblock2:=plane.jblock[point][cblockpair[2]];
        x:=plane.jpoint[pblock1][pairblock];
        y:=plane.jpoint[pblock2][pairblock];
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
        if IsCollineationOfProjectivePlane(perm,plane)
           then
            return perm;
        else
            Error("Unable to generate elation");
        fi;
    else
        Error("Unable to generate elation");
    fi;
end);


#############################################################################
##
#O  ElationByPair( <centre>,<axis>,<pair>,<plane>)  calculate elations of projective planes.
##  This is the "small" implementation. It does not use .jpoint 
##
InstallMethod(ElationByPair,
        "for projective planes",
        [IsInt,IsVector,IsVector,IsRecord],
        function(centre,axis,pair,plane)
    local   blockslist,  axispos,  init_cblocks,  axispoints,  
            permlist,  cblocks,  projpairs,  pairblock,  point,  
            pblock1,  pblock2,  cblock,  x,  y,  cblockpair,  nogood,  
            ppair,  perm;

    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    if IsBound(plane.jpoint)
       then
        TryNextMethod();
    fi;
    
    if not IsSubset([1..plane.v],pair)
       then
        Error("<pair> must be a pair of points");
    fi;
              
    # die Punkte muessen integers sein!
    if not axis in plane.blocks
       then 
        Error("The axis must be a block");
    fi;
    if not centre in axis
       then
        Error("The centre must lie on the axis");
    fi;
    blockslist:=[1..plane.v];    
    axispos:=PositionSet(plane.blocks,axis);

    init_cblocks:=Set(Filtered(plane.blocks,b->centre in b));
    RemoveSet(init_cblocks,axis);

    axispoints:=Difference(axis,[centre]);
    
    if pair[1]=pair[2]
       then
        Error("There can only be one axis. <pair> must contain two different points.");
    fi;
    if Intersection(pair,axis)<>[] 
       then 
        Error("The axis must be fixed pointwise");
    fi;
    permlist:=[1..plane.v];
    cblocks:=ShallowCopy(init_cblocks);
    projpairs:=[];
    pairblock:=plane.blocks[plane.jblock[pair[1]][pair[2]]];
    
    if not centre in pairblock 
       then 
        Error("The centre must be fixed blockwise");
    fi;
    RemoveSet(cblocks,pairblock);
    
    for point in axispoints 
      do
        pblock1:=plane.blocks[plane.jblock[point][pair[1]]];
        pblock2:=plane.blocks[plane.jblock[point][pair[2]]];
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
    cblock:=plane.blocks[plane.jblock[cblockpair[1]][cblockpair[2]]];
    for point in axispoints
      do
        pblock1:=plane.blocks[plane.jblock[point][cblockpair[1]]];
        pblock2:=plane.blocks[plane.jblock[point][cblockpair[2]]];
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
        fi;
    od;
    
    if not nogood
       then
        perm:=PermList(permlist);
        if IsCollineationOfProjectivePlane(perm,plane)
           then
            return perm;
        else
            Error("Unable to generate elation");
        fi;
    else
        Error("Unable to generate elation");
    fi;
end);


#############################################################################
##
#O  AllElationsCentAx( <centre>,<axis>,<plane>)  calculate group of elations
#O  AllElationsCentAx( <centre>,<axis>,<plane>,"generators")  calculate all elations
##
InstallMethod(AllElationsCentAx,
        "for projective planes",
        [IsInt,IsVector,IsRecord],
        function(centre,axis,plane)
    return Group(AllElationsCentAx(centre,axis,plane,"generators"));
end);

InstallMethod(AllElationsCentAx,
        "for projective planes",
        [IsInt,IsVector,IsRecord,IsString],
        function(centre,axis,plane,genstring)
    local   blocks,  ellist,  pairs,  block,  pointset,  point,  
            genset,  pointsetsize,  newelation;

    if not genstring="generators"
       then
        Error("please pass >generators< as an option");
    fi;
    if not IsProjectivePlane(plane)
       then 
        Error("<plane> must be a projective plane");
    fi;
    
    blocks:=plane.blocks;
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
        newelation:=ElationByPair(centre,axis,[point,pointset[pointsetsize]],plane);
        Unbind(pointset[pointsetsize]);
        Add(genset,newelation);
        SubtractSet(pointset,Orbit(Group(genset),point));
    od;
    return genset;
end);


#############################################################################
##
#O  AllElationsAx(<axis>,<plane>)  calcualte group of elations with given axis.
#O  AllElationsAx(<axis>,<plane>,"generators")  calcualte generators of the gorup of elations with given axis.
##
InstallMethod(AllElationsAx,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(axis,plane)
    return Group(AllElationsAx(axis,plane,"generators"));
end);

InstallMethod(AllElationsAx,
        "for projective planes",
        [IsDenseList,IsRecord,IsString],
        function(axis,plane,genstring)
    local   points,  ellist,  centre;

    if not genstring="generators"
       then
        Error("please pass >generators< as an option");
    fi;
    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    
    points:=Difference([1..plane.v],axis);
    ellist:=[];
    for centre in axis
      do
        if ellist<>[] and IsTransitive(Group(ellist),points)
           then 
            return Set(ellist);
        else
            Append(ellist,AllElationsCentAx(centre,axis,plane,"generators"));
        fi;
    od;
    return Set(ellist);
end);



#############################################################################
##
#O IsTranslationPlane(<infline>,<plane>)
##
InstallMethod(IsTranslationPlane,
        "for projective planes",
        [IsRecord],
        function(plane)
    if not IsProjectivePlane(plane)
       then
        return false;
    fi;
    return ForAny(plane.blocks,b->IsTranslationPlane(b,plane));
end);


#############################################################################
##
#O IsTranslationPlane(<infline>,<plane>)
##
InstallMethod(IsTranslationPlane,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(infline,plane)
    local   cent1,  t1gens,  cent2,  t2gens;
    cent1:=Random(infline);
    t1gens:=AllElationsCentAx(cent1,infline,plane,"generators");
    if t1gens=[] or Size(Group(t1gens))<>Size(infline)-1
       then 
        return false;
    else
        cent2:=Random(Difference(infline,[cent1]));
        t2gens:=AllElationsCentAx(cent2,infline,plane,"generators");
    fi;
    if Size(Group(Concatenation(t2gens,t1gens)))=plane.v-Size(infline)
       then
        return true;
    else
        return false;
    fi;
end);

#############################################################################
##
#O GroupOfHomologies(<cetre>,<axis>,<plane>) 
##
InstallMethod(GroupOfHomologies,
        "for projective planes",
        [IsInt,IsDenseList,IsRecord],
        function(centre,axis,plane)
    local   line,  pointset,  point,  genlist,  
            pointsetsize,  newhomology;
    
    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    line:=plane.blocks[plane.jblock[centre][axis[1]]];
    pointset:=Difference(line,[centre,axis[1]]);
    point:=pointset[1];
    RemoveSet(pointset,point);
    genlist:=[];
    while pointset<>[]
      do
        pointsetsize:=Size(pointset);
        newhomology:=HomologyByPair(centre,axis,[point,pointset[pointsetsize]],plane);
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
#O HomologyByPair(<centre>,<axis>,<pair>,<plane>);
##

InstallMethod(HomologyByPair,
        "for projective planes",
        [IsInt,IsDenseList,IsDenseList,IsRecord],
        function(centre,axis,pair,plane)
    local   points,  blocks,  jblock,  blockslist,  axispos,  cblocks,  
            returnlist,  permlist,  projpairs,  pairblock,  axpoint,  
            plineSource,  plineDest,  line,  ppoint,  point,  perm;
    
    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    points:=[1..plane.v];
    blocks:=plane.blocks;
    jblock:=plane.jblock;
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
    if IsCollineationOfProjectivePlane(perm,plane)
       then
        return perm;
    else 
        return fail;
    fi;
end);

#############################################################################
##
#O InducedCollineation(<baerplane>,<baercoll>,<point>,<image>,<plane>,<embedding>)
##
InstallMethod(InducedCollineation,
        "for projective planes",
        [IsRecord,IsPerm,IsInt,IsInt,IsRecord,IsPerm],
        function(baerplane,baercoll,point,image,plane,liftingperm)
    local   blocks,  jblock,  jpoint,  baerindices,  
            liftedcollineation,  pointtangents,  pointsecant,  
            pointsecantnr,  imagesecant,  fixpoint,  imagetangents,  
            shortimagesecant,  shortpointsecant,  baerblocks,  
            permlist,  tpoint,  tangent,  tangentimage,  secant,  p,  
            shortsecant,  secantimage,  ppoint,  ppointimage,  
            linepoint,  pline,  pointinbetween,  plineimage,  perm;

    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    
    if not IsProjectivePlane(baerplane)
       then
        Error("the Baer plane is not a projective plane");
    fi;
    
    if not IsBound(plane.jpoint)
       then
       PointJoiningLinesProjectivePlane(plane);; 
    fi;
    blocks:=plane.blocks;
    jblock:=plane.jblock;
    jpoint:=plane.jpoint;
    baerindices:=OnSets([1..baerplane.v],liftingperm);
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
    baerblocks:=List(baerplane.blocks,b->OnSets(b,liftingperm));
    baerblocks:=Set(baerblocks,b->blocks[jblock[b[1]][b[2]]]);
    RemoveSet(baerblocks,pointsecant);
    permlist:=List(OnTuples([1..plane.v],liftedcollineation));
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
    ppoint:=Representative(Difference([1..plane.v],Concatenation(baerindices,pointsecant)));
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
    elif IsCollineationOfProjectivePlane(perm,plane)
      then
        return perm;
    else 
        return fail;
    fi;
end);

#############################################################################
##
#O  NrFanoPlanesAtPoints(<points>,<plane>)  invariant for projective planes
##
InstallMethod(NrFanoPlanesAtPoints,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(pointlist,plane)
    local   returnlist,  points,  jblock,  jpoint,  blocks,  x,  
            nrfanos,  localblocks,  localblockssize,  points1size,  
            block1number,  block1,  points1,  block2number,  block2,  
            points2,  block3number,  block3,  point2number,  point2,  
            point3,  point4,  b24,  p24,  b34,  p34,  b324,  b234;
    if not IsProjectivePlane(plane)
       then
        Error("<plane> is not a projective plane");   
    fi;
    if not IsBound(plane.jpoint)
       then
        TryNextMethod();
    fi;
    
    returnlist:=[];
    points:=[1..plane.v];
    jblock:=plane.jblock;
    jpoint:=plane.jpoint;
    blocks:=plane.blocks;
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
#O  NrFanoPlanesAtPoints(<pointlist>,<plane>)  invariant for projective planes
##
## This is the "small" version
##
InstallMethod(NrFanoPlanesAtPoints,
        "for projective planes",
        [IsDenseList,IsRecord],
        function(pointlist,plane)
    local   returnlist,  points,  jblock,  blocks,  x,  nrfanos,  
            localblocks,  localblockssize,  points1size,  
            block1number,  block1,  points1,  block2number,  block2,  
            points2,  block3number,  block3,  points3,  point2number,  
            point2,  point3,  point4,  b24,  p24,  b34,  p34,  b324,  
            b234;
    if not IsProjectivePlane(plane)
       then
        Error("<plane> is not a projective plane");   
    fi;
    
    if IsBound(plane.jpoint)
       then
        TryNextMethod();
    fi;
    
    returnlist:=[];
    points:=[1..plane.v];
    jblock:=plane.jblock;
    blocks:=plane.blocks;

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
#O IncidenceMatrix(<design>)
##
InstallMethod(IncidenceMatrix,
        [IsRecord],
        function(plane)
    local   blocknumber,  mat,  blocknr,  blocksize;
    
    if not IsBlockDesign(plane)
       then
        Error("This is not a block design");
    fi;
    blocknumber:=Size(plane.blocks);
    mat:=NullMat(plane.v,blocknumber);
    for blocknr in [1..blocknumber]
      do
        blocksize:=Size(plane.blocks[blocknr]);
        mat{plane.blocks[blocknr]}[blocknr]:=List([1..blocksize],i->1);
    od; 
    return mat;    
end);

#############################################################################
##
#O pRank(<plane>,<p>)
##
InstallMethod(RDS_PRank,
        "for projective planes",
        [IsRecord,IsInt],
        function(plane,p)
    local   pointlist;
    
    if not IsProjectivePlane(plane)
       then
        Error("This is not projective plane");
    fi;
    if not Size(Set(FactorsInt(p)))=1
       then
        Error("<p> must be a primepower or 0");
    fi;
    if p=0
       then 
        return RankMatDestructive(IncidenceMatrix(plane));
    else
        return RankMatDestructive(IncidenceMatrix(plane)*Z(p));
    fi;
end);

#############################################################################
##
#O FingerprintAntiFlag(<point>,<linenr>,<plane>)
##
InstallMethod(FingerprintAntiFlag,
        [IsInt,IsInt,IsRecord],
        function(point,linenr,plane)
    local   infline,  lblocks,  mat,  lpoint,  projlines,  lblock,  
            permlist,  pointnr,  lblockpoint;

    if not IsProjectivePlane(plane)
       then
        Error("this is not a projective plane");
    fi;
    if point in plane.blocks[linenr]
       then
        Error("This is not an anti- flag!");
    fi;
    infline:=plane.blocks[linenr];
    lblocks:=Set(plane.jblock[point]);
    RemoveSet(lblocks,0);
    Apply(lblocks,i->plane.blocks[i]);

    mat:=NullMat(Size(infline),Size(infline));;
    for lpoint in infline
      do
        projlines:=Set(plane.jblock[lpoint]);
        RemoveSet(projlines,0);
        Apply(projlines,i->plane.blocks[i]);
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
#O FingerprintProjPlane(<plane>)
##
InstallMethod(FingerprintProjPlane,
        [IsRecord],
        function(plane)
    local   nrOfBlocks,  mat,  points,  point,  lblocks,  
            lblocksindex,  linenr,  line,  permlist,  pointnr;
    
    if not IsProjectivePlane(plane)
      then
        Error("this is not a projective plane");
    fi;
    mat:=NullMat(plane.v,plane.v);
    for point in [1..plane.v]
      do
        lblocks:=Set(Filtered(plane.blocks,b->point in b));
        lblocksindex:=Set(lblocks,b->PositionSet(plane.blocks,b));
        for linenr in Difference([1..plane.v],lblocksindex)
          do
            line:=plane.blocks[linenr];
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
#O IsomorphismProjPlanesByGenerators(<gens1>,<plane1>,<gens2>,<plane2>)
##
InstallMethod(IsomorphismProjPlanesByGenerators,
        "for projective planes",
        [IsDenseList,IsRecord,IsDenseList,IsRecord],
        function(gens1,plane1,gens2,plane2)
    local   N,  hasfailed;
    
    if Size(gens1)<>Size(gens2)
       then
        Error("<gens1> and <gens2> must be of the same length!");
    fi;
    if not IsProjectivePlane(plane1) and IsProjectivePlane(plane2)
       then
        Error("plane1 and plane2 must be projective planes");
    fi;
    N:=plane1.v;
    hasfailed:=false;
    if not plane2.v=N
       then
        Error("The planes must be of the same size");
        hasfailed:=true;
    fi;
    if ProjectiveClosureOfPointSet(gens1,0,plane1).closure.v<>N
       or ProjectiveClosureOfPointSet(gens2,0,plane2).closure.v<>N
      then
        hasfailed:=true;
    fi;
    if not hasfailed 
       then
        return IsomorphismProjPlanesByGeneratorsNC(gens1,plane1,gens2,plane2);
    else 
        return fail;
    fi;
end);
      
#############################################################################
##
#O IsomorphismProjPlanesByGeneratorsNC(<gens1>,<plane1>,<gens2>,<plane2>)
##
InstallMethod(IsomorphismProjPlanesByGeneratorsNC,
        "for projective planes",
        [IsDenseList,IsRecord,IsDenseList,IsRecord],
        function(gens1,plane1,gens2,plane2)
    local   newpoints,  oldpoints,  newblocks,  pointimagelist,  
            blockimagelist,  pair,  oldblocks,  x,  iso;
    
    if Size(gens1)<>Size(gens2)
       then
        Error("<gens1> and <gens2> must be of the same length!");
    fi;
    if not (IsProjectivePlane(plane1) and IsProjectivePlane(plane2))
       then
        Error("plane1 and plane2 must be projective planes");
    fi;
    
    newpoints:=[];
    oldpoints:=Set(gens1);
    newblocks:=[];
    pointimagelist:=ListWithIdenticalEntries(plane2.v,0);
    pointimagelist{gens1}:=gens2;
    blockimagelist:=ListWithIdenticalEntries(plane2.v,0);
    newblocks:=Set(Combinations(oldpoints,2),i->
                   [plane1.jblock[i[1]][i[2]],
                    plane2.jblock[pointimagelist[i[1]]][pointimagelist[i[2]]]]);
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
                       [Intersection(plane1.blocks[i[1]],plane1.blocks[i[2]])[1],
                        Intersection(plane2.blocks[blockimagelist[i[1]]],plane2.blocks[blockimagelist[i[2]]])[1]]);
        UniteSet(newpoints,List(Combinations(newblocks,2),i->
                [Intersection(plane1.blocks[i[1]],plane1.blocks[i[2]])[1],
                 Intersection(plane2.blocks[blockimagelist[i[1]]],plane2.blocks[blockimagelist[i[2]]])[1]]));
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
                           [plane1.jblock[i[1]][i[2]],
                            plane2.jblock[pointimagelist[i[1]]][pointimagelist[i[2]]]]
                           );
            UniteSet(newblocks,List(Combinations(newpoints,2),i->
                    [plane1.jblock[i[1]][i[2]],
                     plane2.jblock[pointimagelist[i[1]]][pointimagelist[i[2]]]
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
    iso:=PermListList([1..plane1.v],pointimagelist);
    if IsPerm(iso) and IsIsomorphismOfProjectivePlanes(iso,plane1,plane2)
       then
        return iso;
    else 
        return fail;
    fi;
end);

#############################################################################
##
#E  END
##
