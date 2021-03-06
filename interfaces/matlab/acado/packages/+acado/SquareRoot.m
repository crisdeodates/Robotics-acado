%Square Root of an acado Expression
%
%  Usage:
%    >> sqrt(e);
%
%  Parameters:
%    e          [Expression]
%
%  Licence:
%    This file is part of ACADO Toolkit  - (http://www.acadotoolkit.org/)
%
%    ACADO Toolkit -- A Toolkit for Automatic Control and Dynamic Optimization.
%    Copyright (C) 2008-2009 by Boris Houska and Hans Joachim Ferreau, K.U.Leuven.
%    Developed within the Optimization in Engineering Center (OPTEC) under
%    supervision of Moritz Diehl. All rights reserved.
%
%    ACADO Toolkit is free software; you can redistribute it and/or
%    modify it under the terms of the GNU Lesser General Public
%    License as published by the Free Software Foundation; either
%    version 3 of the License, or (at your option) any later version.
%
%    ACADO Toolkit is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%    Lesser General Public License for more details.
%
%    You should have received a copy of the GNU Lesser General Public
%    License along with ACADO Toolkit; if not, write to the Free Software
%    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
%
%    Author: Rien Quirynen
%    Date: 2012
% 
classdef SquareRoot < acado.UnaryOperator
    properties(SetAccess='private')

    end
    
    methods
        function obj = SquareRoot(obj1)
            if nargin > 0
                if (isa(obj1, 'numeric'))
                    obj1 = acado.DoubleConstant(obj1);
                end
                obj1 = getExpression(obj1);
                obj.obj1 = obj1;
                obj.zero = obj1.zero;
                obj.one = obj1.one;
            end
        end
        
        function out = copy(obj)
            out = acado.SquareRoot(copy(obj.obj1));
        end
        
        function s = toString(obj)
            if obj.zero
                s = '0';
            elseif obj.one
                s = '1';
            else
                s = sprintf('sqrt(%s)', obj.obj1.toString); 
            end
        end
        
        function jac = jacobian(obj, var)
            if ~isvector(obj)
                error('A jacobian can only be computed of a vector function.');
            end
            for i = 1:length(obj)
                if obj(i).obj1.zero || obj(i).obj1.one || isa(obj(i).obj1, 'acado.DoubleConstant')
                    jac(i,:) = zeros(1,length(var));
                else
                    jac(i,:) = jacobian(obj(i).obj1,var)/(2*obj(i));
                end
            end
        end
    end
    
end
