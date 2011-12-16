#############################################################################
##
#W force.gd 			 RDS Package		 Marc Roeder
##
##  Brute force methods for finding relative differnece sets
##
#H @(#)$Id: force.gd, v 0.9beta21 15/11/2006 19:33:30 gap Exp $
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
Revision.("rds/lib/force_gd"):=
	"@(#)$Id: force.gd, v 0.9beta21 15/11/2006   19:33:30  gap Exp $";
#############################################################################
##
#O AllDiffsets(<diffset>,<completions>,<aim>,<forbidden>,<Gdata>,<lambda>)
##
##  Let <diffset> be partial relative difference set and <completions> a list
##  of possible completions and <forbidden> the forbidden set. Then
##  `AllDiffsets' returns a list of (partial) difference sets which contain
##  diffset. <Gdata> is the record as always and <lambda> is the parameter
##  of the relative difference set. <forbidden> and <completions> have to be
##  lists of integers.
##
DeclareOperation("AllDiffsets",
        [IsDenseList,IsDenseList,IsInt,IsDenseList,IsRecord,IsPosInt]);