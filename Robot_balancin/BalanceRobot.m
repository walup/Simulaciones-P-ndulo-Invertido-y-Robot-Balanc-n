classdef BalanceRobot
    
   properties
      %Physical parameters
      l;
      massChasis;
      massWheels;
      widthChasis;
      heightChasis;
      radiusWheels;
      inertiaWheels;
      inertiaChasis;
      g;
      
      %Control parameters
      kp;
      ki;
      kd;
      
      %Transfer functions
      openPositionFunction;
      openAngleFunction;
      positionFunction;
      angleFunction;
      
      T;
   end
   
   methods
      %Constructor will create a BalanceRobot object with the given
      %physical parameters. 
      function obj = BalanceRobot(massChasis,massWheels,widthChasis, heightChasis,radiusWheels)
          %Set the masses and the radius
          obj.massChasis = massChasis;
          obj.massWheels = massWheels;
          obj.radiusWheels = radiusWheels;
          obj.widthChasis = widthChasis;
          obj.heightChasis = heightChasis;
          obj.g = 9.81;
          obj.l = heightChasis/2;
          %Set the inertia moments of inertia for the wheels and the chasis
          obj.inertiaWheels = (1/2)*obj.massWheels*obj.radiusWheels^2;
          obj.inertiaChasis = (1/12)*(widthChasis^2 +heightChasis^2);
          %Set the open loop functions for the position and angle plants
          s = tf('s');
          obj.openPositionFunction =(obj.radiusWheels*((obj.massChasis*obj.l^2 +obj.inertiaChasis)*s^2-obj.g*obj.l*obj.massChasis))/((2*obj.massChasis*(obj.massWheels*obj.radiusWheels^2 +obj.inertiaWheels)*obj.l^2 +obj.inertiaChasis*(obj.massChasis+2*obj.massWheels)*obj.radiusWheels^2+2*obj.inertiaWheels*obj.inertiaChasis)*s^4 -obj.g*obj.l*obj.massChasis*((obj.massChasis+2*obj.massWheels)*obj.radiusWheels^2+2*obj.inertiaWheels)*s^2);
          obj.openAngleFunction = (obj.l*obj.massChasis*obj.radiusWheels)/((2*obj.massChasis*(obj.massWheels*obj.radiusWheels^2 +obj.inertiaWheels)*obj.l^2 +obj.inertiaChasis*(obj.massChasis+2*obj.massWheels)*obj.radiusWheels^2+2*obj.inertiaWheels*obj.inertiaChasis)*s^2 -obj.g*obj.l*obj.massChasis*((obj.massChasis+2*obj.massWheels)*obj.radiusWheels^2+2*obj.inertiaWheels));
          obj.T = 2*pi*sqrt((obj.inertiaChasis+obj.massChasis*obj.l^2)/(obj.massChasis*obj.g*obj.l));
      end
      
      %Set the PID controller of the function and the closed loop functions
      
      function obj = setPID(obj,kp,ki,kd)
         %Set the PID parameters 
         obj.kp = kp;
         obj.ki = ki;
         obj.kd = kd;
         s = tf('s');
         pidFunc = kp+kd*s+ki/s;
         obj.angleFunction = minreal(obj.openAngleFunction/(1+pidFunc*obj.openAngleFunction));
         obj.positionFunction = minreal(obj.openPositionFunction/(1+pidFunc*obj.openAngleFunction));
      end
      
       %Function to see if the system is stable
       function val = isStable(obj)
          val = true;
          arr = real(pole(obj.angleFunction))<0;
          for i = 1:length(arr)
             if(arr(i) == 0)
                 val = false;
             end
          end
       end
       
       %Function to obtain an order 2 form of the transfer function
       function reducedTransf = getReducedTransf(obj)
           reducedTransf = balred(obj.angleFunction,2);
       end
       
       function [behaviorType,poles] = getStabilityType(obj)
          %Pole precision
          prec = 1*10^-2;
          %First we get the reduced transfer function 
          redTransf = obj.getReducedTransf();
          %Then we get the poles 
          poles = pole(redTransf);
          pole1 = poles(1);
          pole2 = poles(2);
          pole1(abs(imag(pole1))<prec)= real(pole1);
          pole2(abs(imag(pole2))<prec) = real(pole2);
          %Now select which type of stability we have
          %Overdamped
          if(isreal(pole1) && isreal(pole2) && abs(pole1 - pole2)>=prec)
              behaviorType = StabilityType.OVERDAMPED;
          %Critically damped
          elseif(isreal(pole1) && isreal(pole2) && abs(pole1-pole2)<prec)
              behaviorType = StabilityType.CRITICALLY_DAMPED;
          %Underdamped
          elseif(~isreal(pole1) && ~isreal(pole2) && conj(pole1) == pole2)
             behaviorType = StabilityType.UNDERDAMPED;
          else
             behaviorType = StabilityType.NONE;                  
          end        
       end
       
       %Now here goes the function to get the parabola
       function par = computeParabola(obj,startD, endD)
          %Set an initial value for the integral control
          KI = 160;
          delta = 1;
          %Scan the y axis (derivative)
          yScanRange = linspace(startD,endD,20);
          %Cap
          CAP = 1000;
          robot = BalanceRobot(obj.massChasis,obj.massWheels,obj.widthChasis, obj.heightChasis,obj.radiusWheels);
          points = zeros(length(yScanRange),2);
              
          %Create a waitbar
          message = waitbar(0,'Obteniendo parabola');
          for i = 1:length(yScanRange)
              waitbar(i*1/length(yScanRange),message);
              type1 = 0;
              type2 = 0;
              %Now we will scan the x axis (proportional) until we find
              %a change in type, at most we will reach a cap of 5000
              x = 0;
              while(x < CAP)
                  if(x == 0)
                      %Set a new PID
                      robot = robot.setPID(x,KI,yScanRange(i));
                      %Get the stability type
                      [type1,~] = robot.getStabilityType();
                      type2 = type1;
                      x = x+delta;
                        
                  else
                      %Set a new PID 
                      robot = robot.setPID(x,KI,yScanRange(i));
                      %Get the stability type
                      [type1,~] = robot.getStabilityType();
                      %Compare it with the last type and
                      %if it is different we will scan a finer 
                      %interval
                      if(type1 ~= type2)
                         disp('Broke');
                         xPoint = (2*x-delta)/2;
                         yPoint = yScanRange(i);
                             
                         %Add it to the points
                         points(i,:) = [xPoint,yPoint];
                         disp("Last type "+string(type2))
                         disp("New type "+string(type1));
                         break;
                      end
                          
                      type2 = type1;
                      x = x+delta;
                  end
              end
          end
          xVals = points(:,1);
          yVals = points(:,2);
          par = polyfit(xVals,yVals,2);
          yCalcVals = polyval(par,xVals);
          figure()
          hold on
          title("Parabola m = "+num2str(obj.massChasis+2*obj.massWheels)+"l = "+num2str(obj.l)+" radio = "+num2str(obj.radiusWheels))
          plot(xVals,yVals,'o')
          plot(xVals,yCalcVals)
          xlabel('Kp')
          ylabel('Kd')
          hold off
          delete(message);
       end
       
       function [t,torque,position,angle,energy] = runSimulation(obj,time,input)
           t = 0:0.01:time;
           signal = input(t);
           %Obtain the position
           position = lsim(obj.positionFunction,signal,t);
           %Obtain the angle
           angle = lsim(obj.angleFunction,signal,t);
           deltaT = diff(t');
           velocity = diff(position)./deltaT;
           velocity = [velocity ; velocity(end)];
           acceleration = diff(velocity) ./ deltaT;
           acceleration = [acceleration ; acceleration(end)];
           angularVelocity = diff(angle)./deltaT;
           angularVelocity = [angularVelocity ; angularVelocity(end)];
           angularAcceleration = diff(angularVelocity) ./ deltaT;
           angularAcceleration =[angularAcceleration ; angularAcceleration(end)];
           %Obtain the torque 
            torque = obj.radiusWheels*((obj.massChasis+2*obj.massWheels+(2*obj.inertiaWheels/obj.radiusWheels^2))*acceleration - obj.massChasis*obj.l*angularAcceleration);
           %Obtain th energy
           energy = (1/2)*obj.massChasis*velocity.^2 -obj.massChasis*obj.l*angularVelocity.*velocity.*cos(angle) +(1/2)*obj.massChasis*angularVelocity.^2*obj.l^2 +(1/2)*obj.inertiaChasis*angularVelocity.^2 +obj.massWheels*velocity.^2 +(1/obj.radiusWheels^2)*obj.inertiaWheels*velocity.^2 +2*obj.massChasis*obj.g*obj.radiusWheels +obj.massChasis*obj.g*(obj.radiusWheels +obj.l*cos(angle));
       end
   end
    
    
    
end