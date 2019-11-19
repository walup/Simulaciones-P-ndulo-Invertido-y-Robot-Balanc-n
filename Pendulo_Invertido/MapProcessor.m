%This class will create the neccesary maps 
classdef MapProcessor
   properties
      %The ranges and grids that will be plotted
      pRange;
      dRange;
      iValue;
      pGrid;
      dGrid;
      cart;
   end
   
   methods
       %The constructor
       function obj = MapProcessor(initialP,finalP,initialD,finalD,cart)
           %Create intervals of 200 points
           obj.pRange = linspace(initialP,finalP,200);
           obj.dRange = linspace(initialD,finalD,200);
           %Create the grids
           [obj.pGrid,obj.dGrid] = meshgrid(obj.pRange,obj.dRange);
           %Set the ivalue to 160
           obj.iValue = 160;
           obj.cart = cart;
       end
       
       %Gets a map for homeostatic parameter
       function [normAngleMap,normForceMap,homeostaticParameterMap] = getHomeostaticMap(obj,time,input)
           siz = size(obj.pGrid);
           n = siz(1);
           m = siz(2);
           %Create a matrix to store the points
           normAngleMap = zeros(n,m);
           normForceMap = zeros(n,m);
           homeostaticParameterMap = zeros(n,m);
           %Create a waitbar
           message = waitbar(0,'Obteniendo mapa homeostático');
           for i = 1:n
               waitbar(i*1/n,message);
               for j = 1:m
                   %Set the new PID
                   kp = obj.pGrid(i,j);
                   ki = obj.iValue;
                   kd = obj.dGrid(i,j);
                   obj.cart = obj.cart.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.cart,time,input);
                   %Get the parameter
                   [normAngle,normForce,alpha] = processor.homeostaticParameter();
                   %Add it to the maps
                   normAngleMap(i,j) = normAngle;
                   normForceMap(i,j) = normForce;
                   homeostaticParameterMap(i,j) = alpha;
                   disp(j);
               end
           end
           delete(message)
       end
       
       
       %Gets a map for the reduced homeostatic parameter
       function [sdAngleMap,sdForceMap,homeostaticParameterMap] = getReducedHomeostaticMap(obj,time,input)
           siz = size(obj.pGrid);
           n = siz(1);
           m = siz(2);
           %Create a matrix to store the points
           sdAngleMap = zeros(n,m);
           sdForceMap = zeros(n,m);
           homeostaticParameterMap = zeros(n,m);
           %Create a waitbar
           message = waitbar(0,'Obteniendo mapa homeostático reducido');
           for i = 1:n
               waitbar(i*1/n,message);
               for j = 1:m
                   %Set the new PID
                   kp = obj.pGrid(i,j);
                   ki = obj.iValue;
                   kd = obj.dGrid(i,j);
                   obj.cart = obj.cart.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.cart,time,input);
                   %Get the parameter
                   [sdAngle,sdForce,alpha] = processor.reducedHomeostaticParameter();
                   %Add it to the maps
                   sdAngleMap(i,j) = sdAngle;
                   sdForceMap(i,j) = sdForce;
                   homeostaticParameterMap(i,j) = alpha;
                   disp(j);
               end
           end
           delete(message)
       end
       
       %Gets the map of correlation between the force and 
       %the sngle
       function correlationMap = getCorrelationMap(obj,time,input)
           siz = size(obj.pGrid);
           n = siz(1);
           m = siz(2);
           %Create a matrix to store the points
           correlationMap = zeros(n,m);
           %Create a waitbar
           message = waitbar(0,'Obteniendo mapa de correlación');
           for i = 1:n
               waitbar(i*1/n,message);
               for j = 1:m
                   %Set the new PID
                   kp = obj.pGrid(i,j);
                   ki = obj.iValue;
                   kd = obj.dGrid(i,j);
                   obj.cart = obj.cart.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.cart,time,input);
                   %Get the parameter
                   correlation = processor.regCorrelation();
                   %Add it to the maps
                   correlationMap(i,j) = correlation;
                   disp(j);
               end
           end
           delete(message)
       end
       
           function correlationMap = getEnergyCorrelationMap(obj,time,input)
           siz = size(obj.pGrid);
           n = siz(1);
           m = siz(2);
           %Create a matrix to store the points
           correlationMap = zeros(n,m);
           %Create a waitbar
           message = waitbar(0,'Obteniendo mapa de correlación de energía');
           for i = 1:n
               waitbar(i*1/n,message);
               for j = 1:m
                   %Set the new PID
                   kp = obj.pGrid(i,j);
                   ki = obj.iValue;
                   kd = obj.dGrid(i,j);
                   obj.cart = obj.cart.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.cart,time,input);
                   %Get the parameter
                   correlation = processor.energyCorrelation();
                   %Add it to the maps
                   correlationMap(i,j) = correlation;
                   disp(j);
               end
           end
           delete(message)
       end
           
   end
    
    
    
end