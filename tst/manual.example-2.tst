gap> G:=CyclicGroup(7);;
gap> AllDiffsets(G);
[ [ f1, f1^3 ], [ f1, f1^5 ], [ f1^2, f1^3 ], [ f1^2, f1^6 ], [ f1^4, f1^5 ], 
  [ f1^4, f1^6 ] ]
gap> OneDiffset(G);
[ f1, f1^3 ]
gap> AllDiffsets([Set(G)[7]],G);
[  ]
gap> G:=ElementaryAbelianGroup(81);
<pc group of size 81 with 4 generators>
gap> N:=Subgroup(G,GeneratorsOfGroup(G){[1,2]});
Group([ f1, f2 ])
gap> OneDiffset([],Set(N),G);
[ f3, f4, f1*f3^2, f2*f3*f4, f1^2*f4^2, f2*f3^2*f4^2, f1*f2^2*f3^2*f4, 
  f1^2*f2^2*f3*f4^2 ]
gap> G:=SmallGroup(24,3);
<pc group of size 24 with 4 generators>
gap> N:=First(NormalSubgroups(G),i->Size(i)=2);
Group([ f4 ])
gap> OneDiffset([],Set(N),G,6);
[ f1, f2, f3, f1^2, f1*f2, f1*f3, f2*f3, f1*f2*f3, f1^2*f2*f4, f1^2*f3*f4, 
  f1^2*f2*f3*f4 ]
gap> a:=(1,2,3,4,5,6,7);
(1,2,3,4,5,6,7)
gap> IsDiffset([a,a^3],Group(a));  #an ordinary difference set
true
gap> IsDiffset([a,a^2,a^4],Group(a));  #no ordinary difference set
false
gap> IsDiffset([a,a^2,a^4],Group(a),2);   #diffset with <lambda>=2
true
