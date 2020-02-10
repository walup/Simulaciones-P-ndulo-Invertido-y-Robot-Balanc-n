
classdef InvertedPendulum
    properties
       %Physical parameters
       M;
       m;
       l;
       g;
       %Control parameters
       kp;
       ki;
       kd;
       %Transfer functions (model)
       positionFunction;
       angleFunction;       
       %Period of the pendulum to be able to use natural units
       T;
    end
    
    methods
       %The constructor initializes the cart with the given physical
       %parameters
       
       function obj = InvertedPendulum(m,M,l)
          %Mass of the pendulum 
          obj.m = m;
          %Mass of the cart
          obj.M = M;
          %Length of the rod
          obj.l = l;
          %Gravitational acceleration
          obj.g = 9.81;
          %The period of the pendulum
          obj.T = 2*pi*sqrt(obj.l/obj.g);
       end
       
       function obj = setPID(obj,kp,ki,kd)
           %Set the control parameters
           obj.kp = kp;
           obj.ki = ki;
           obj.kd = kd;
           
           %Set the closed loop transfer functions
           s = tf('s');
           obj.angleFunction = s/(ki + kp*s + kd*s^2 - obj.M*obj.g*s - obj.g*obj.m*s + obj.M*obj.l*s^3);
           obj.positionFunction = -(- obj.l*s^2 + obj.g)/(obj.l*obj.M*s^4 +obj.kd*s^3 +(obj.kp -obj.g*(obj.m +obj.M))*s^2 +obj.ki*s);
       end
       
       %Sets only the angle loop transfer function
       function obj = setAnglePID(obj,kp,ki,kd)
           s = tf('s');
           obj.angleFunction = s/(ki + kp*s + kd*s^2 - obj.M*obj.g*s - obj.g*obj.m*s + obj.M*obj.l*s^3);
       end
       
       %This function will obtain an approximate 
       %model of order 2 for the closed loop angle
       %transfer function
       function reducedTransf = getReducedTransf(obj)
          %Get the poles 
          poles = pole(obj.angleFunction);
          %Take out the pole with the biggest real part 
          poles = poles(abs(real(poles)) < max(abs(real(poles))));
          s = tf('s');
          %Return the reduced transfer function with the removed pole 
          reducedTransf = s/((s-poles(1))*(s-poles(2)));
       end
       
       %This function will get the stability type of a
       %reduced model of order 2
       function [behaviorType, poles] = getStabilityType(obj)
          %The precission to which we will say the poles are equal
          prec = 1*10^-2;
          %Get the reduced transfer function
          redTransf = obj.getReducedTransf();
          %Get the poles of the reduced model
          poles = pole(redTransf);
          pole1 = poles(1);
          pole2 = poles(2);
          %Select the type of stability according to the poles
          %Overdamped
          if(isreal(pole1) && isreal(pole2) && abs(pole1 -pole2)>prec)
              behaviorType = StabilityType.OVERDAMPED;
          %Critically damped
          elseif(isreal(pole1) && isreal(pole2) &&  abs(pole1-pole2)<prec)
              behaviorType = StabilityType.CRITICALLY_DAMPED;
          %Underdamped
          elseif(~isreal(pole1) && ~isreal(pole2) && conj(pole1) == pole2)
              behaviorType = StabilityType.UNDERDAMPED;
          else
              behaviorType = StabilityType.NONE;                  
          end
       end
       
       %This function will compute the stability parabola
       %for a constant ki of 160. 
       function par = computeParabola(obj,startD,endD)
           %Set an initial value for the integral control 
           ki = 160;
           delta = 1;
           %We will scan 20 points in the kd axis
           yScanRange = linspace(startD,endD,20);
           %cap of points we will search in the kp
           %axis for a transition of behavior
           CAP = 1000;
           %Create a sample cart with the same
           %physical parameters
           cart = InvertedPendulum(obj.m,obj.M,obj.l);
           points = zeros(length(yScanRange),2);
           %Create a waitbar
           message = waitbar(0,'Computing parabola');
           for i = 1:length(yScanRange)
               waitbar(i*1/length(yScanRange),message);
               type1 = 0;
               type2 = 0;
               %Now we will scan the x axis (proportional) until we find
               %a change in type, at most we will reach a cap of 1000
               %points
               x = 0;
               while(x < CAP)
                  if(x == 0) 
                      %Set a new PID 
                      cart = cart.setAnglePID(x,ki,yScanRange(i));
                      %Get the stability type
                      [type1,~] = cart.getStabilityType();
                      type2 = type1;
                      x = x+delta;
                  else
                      %Set a new PID
                      cart = cart.setAnglePID(x,ki,yScanRange(i));
                      %Get the stability type 
                      [type1,~] = cart.getStabilityType();
                      %Compare it with the last type and if it is different
                      %then we will just store the average of the previous
                      %and the new point
                      if(type1 ~= type2)
                         disp('Changed behavior');
                         pointX = (2*x-delta)/2;
                         pointY = yScanRange(i);
                         points(i,:) = [pointX,pointY];
                         disp("Last type: "+string(type2)+" New type: "+string(type1));
                         break;
                      end
                      type2 = type1;
                      x = x+delta;
                  end  
               end
               
           end
           %Now its time to adjust a parabola to the
           %collected points
           %Collect x and y coordinates of points
           xVals = points(:,1);
           yVals = points(:,2);
           %Adjust the parabola to them
           par = polyfit(xVals,yVals,2);
           %Get the parabola coefficients 
           [c1,c2,c3] = obj.getParabolaCoefficients(par,ki);
           yCalcVals = polyval(par,xVals);
           figure()
           %The parabola plot
           hold on
           a = gca;
           a.Position(4) = 0.6;
           a.Position(2) = 0.3;
           title("Parabola m = "+num2str(obj.m)+" M = "+num2str(obj.M)+" l = "+num2str(obj.l))
           %Area under the plot to mark the overdamped region
           patch([xVals',flip(xVals')],[yCalcVals',ones(1,length(yCalcVals'))*min(yCalcVals)],[251, 105, 86]/255,'FaceAlpha',0.5);
           patch([xVals',flip(xVals')],[yCalcVals',ones(1,length(yCalcVals'))*max(yCalcVals)],[54, 191, 199]/255,'FaceAlpha',0.5);
           plot(xVals,yVals,'o')
           plot(xVals,yCalcVals)
           text(100,30,'Subamortiguado')
           text(180,30,'Sobreamortiguado')
           text(142,30,'Crítico \rightarrow');
           annotation('textbox', [0.1, 0.1, 0.1, 0.1], 'String', "Coeficientes de la parábola:      c_{1} = "+num2str(c1)+"     c_{2} =  "+num2str(c2)+"      c_{3} =  "+num2str(c3),'FontWeight','bold')
           xlabel('kp')
           ylabel('kd')
           xlim([min(xVals),max(xVals)])
           ylim([min(yCalcVals),max(yCalcVals)])
           hold off
           delete(message);
       end
       
       %This function will run a simulation for the given input signal
       %Here input signal has to be a function, something like @(x)step(x)
       function [t,force,position,angle,energy] = runSimulation(obj,time,input)
         %The time interval
         t = 0:0.01:time;
         %Obtain the input signal evaluating the function given as
         %parameter
         signal = input(t);
         %Obtain the position response
         position = lsim(obj.positionFunction,signal,t);
         %Obtain the angle response
         angle = lsim(obj.angleFunction,signal,t);
         %To obtain the force we need to take the first and second 
         %numerical derivatives of the angle and position
         deltaT = diff(t');
         velocity = diff(position)./deltaT;
         velocity = [velocity ; velocity(end)];
         acceleration = diff(velocity) ./ deltaT;
         acceleration = [acceleration ; acceleration(end)];
         angularVelocity = diff(angle)./deltaT;
         angularVelocity = [angularVelocity ; angularVelocity(end)];
         angularAcceleration = diff(angularVelocity) ./ deltaT;
         angularAcceleration =[angularAcceleration ; angularAcceleration(end)];
         %Obtain the force
         force = (obj.M+obj.m)*acceleration + obj.m*obj.l*angularAcceleration;  
         %Obtain the energy 
         energy = (1/2)*(obj.m+obj.M)*velocity.^2 +(1/2)*obj.m*obj.l^2*angularVelocity.^2-obj.m*angularVelocity.*velocity*obj.l.*cos(angle)+(obj.m*obj.g*obj.l*cos(angle));
        
       end
       
       function [c1,c2,c3] = getParabolaCoefficients(obj,par,ki)
           %par has three coefficients and it sets the structure of a
           %parabola of the form y = a1x^2 +a2x+a3
           a1 = par(1);
           a2 = par(2);
           a3 = par(3);
           
           c1 = a2/(2*a1);
           c2 = (a1/4)-ki;
           c3 = (a2^2/(4*a1))-a3;
       end
       
           
           
           
       end
      
    
end