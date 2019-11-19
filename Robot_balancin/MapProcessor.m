%This class will create the neccesary maps 
classdef MapProcessor
   properties
      %The ranges and grids that will be plotted
      pRange;
      dRange;
      iValue;
      pGrid;
      dGrid;
      robot;
   end
   
   methods
       %The constructor
       function obj = MapProcessor(initialP,finalP,initialD,finalD,robot)
           %Create intervals of 200 points
           obj.pRange = linspace(initialP,finalP,200);
           obj.dRange = linspace(initialD,finalD,200);
           %Create the grids
           [obj.pGrid,obj.dGrid] = meshgrid(obj.pRange,obj.dRange);
           %Set the ivalue to 160
           obj.iValue = 160;
           obj.robot = robot;
       end
       
       %Gets a map for homeostatic parameter
       function [normAngleMap,normTorqueMap,homeostaticParameterMap] = getHomeostaticMap(obj,time,input)
           siz = size(obj.pGrid);
           n = siz(1);
           m = siz(2);
           %Create a matrix to store the points
           normAngleMap = zeros(n,m);
           normTorqueMap = zeros(n,m);
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
                   obj.robot = obj.robot.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.robot,time,input);
                   %Get the parameter
                   [normAngle,normTorque,alpha] = processor.homeostaticParameter();
                   %Add it to the maps
                   normAngleMap(i,j) = normAngle;
                   normTorqueMap(i,j) = normTorque;
                   homeostaticParameterMap(i,j) = alpha;
                   disp(j);
               end
           end
           delete(message)
       end
       
       
       %Gets a map for the reduced homeostatic parameter
       function [sdAngleMap,sdTorqueMap,homeostaticParameterMap] = getReducedHomeostaticMap(obj,time,input)
           siz = size(obj.pGrid);
           n = siz(1);
           m = siz(2);
           %Create a matrix to store the points
           sdAngleMap = zeros(n,m);
           sdTorqueMap = zeros(n,m);
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
                   obj.robot = obj.robot.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.robot,time,input);
                   %Get the parameter
                   [sdAngle,sdTorque,alpha] = processor.reducedHomeostaticParameter();
                   %Add it to the maps
                   sdAngleMap(i,j) = sdAngle;
                   sdTorqueMap(i,j) = sdTorque;
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
                   obj.robot = obj.robot.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.robot,time,input);
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
                   obj.robot = obj.robot.setPID(kp,ki,kd);
                   %The processor
                   processor = DataProcessor(obj.robot,time,input);
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