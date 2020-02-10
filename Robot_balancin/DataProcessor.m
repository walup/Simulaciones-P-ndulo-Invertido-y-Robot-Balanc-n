%This class wlil process the simulations data
%it can do several things, from calculating the neeeded
%parameters to plotting time series or exporting an excel
%file 
classdef DataProcessor
   properties
      t;
      position;
      angle;
      torque;
      energy;
      normalizedTorque; 
      stability;
   end
   
   methods
       
       %The constructor receives a cart
       %and runs the simulation for a certain
       %signal
       function obj = DataProcessor(robot,time,input) 
          [obj.t,obj.torque,obj.position,obj.angle,obj.energy] = robot.runSimulation(time,input);
          %Obtain the normalized force
          obj.normalizedTorque = obj.torque*((robot.T^2)/((robot.massChasis*robot.l^2+robot.inertiaChasis)));
          obj.stability = robot.getStabilityType();
       end
       
       
       %Function to calculate the homeostatic parameter
       function [normAngle,normTorque,alpha] = homeostaticParameter(obj)
           %Moments of angle
           skAngle = skewness(obj.angle);
           kurtosisAngle = kurtosis(obj.angle);
           sdAngle = std(obj.angle);
           normAngle = sqrt(skAngle^2+kurtosisAngle^2+sdAngle^2);
           %Moments of normalized force
           skTorque = skewness(obj.normalizedTorque);
           kurtosisTorque = kurtosis(obj.normalizedTorque);
           sdTorque = std(obj.normalizedTorque);
           normTorque = sqrt(skTorque^2+kurtosisTorque^2+sdTorque^2);
           
           %Compute the parameter
           alpha = normTorque/normAngle;
       end
       
       function [sdAngle,sdTorque,alpha] = reducedHomeostaticParameter(obj)
           %std of angle
           sdAngle = std(obj.angle);
           %std of normalized torque
           sdTorque = std(obj.normalizedTorque);
           %The reduced homeostatic parameter
           alpha = sdTorque/sdAngle;
       end
       
       %Correlation between torque and angle
       function r = regCorrelation(obj)
           r = corrcoef(obj.torque,obj.angle);
           r = r(1,2);
       end
       
       %Correlation between energy and angle
       function rE = energyCorrelation(obj)
          rE = corrcoef(obj.energy,obj.angle);
          rE = rE(1,2);
       end
       
       %Function to plot the time series
       %of position angle and force
       function fig = plotTimeSeries(obj)
           %Create a figure
           fig = figure(1);
           sgtitle('Series de tiempo')
           hold on
           %Angle subplot
           subplot(3,1,1)
           plot(obj.t,obj.angle);
           title('聲gulo')
           xlabel('Tiempo (s)')
           ylabel('聲gulo (rad)')
           
           %Position subplot
           subplot(3,1,2)
           plot(obj.t,obj.position)
           title('Posici鏮')
           xlabel('Tiempo (s)')
           ylabel('Posici鏮 (m)')
           %Force subplot
           subplot(3,1,3)
           plot(obj.t,obj.torque)
           title('Torca')
           xlabel('Tiempo (s)')
           ylabel('Torca (N m)')
           hold off
       end
       
       %Plot the energy time series
       function fig = plotEnergy(obj)
          fig = figure();
          plot(obj.t,obj.energy)
          title('Energia')
          xlabel('Tiempo (s)')
          ylabel('Energia (J)')
       end
       function y = drawDistribution(obj)
          
          hold on 
          histogram(obj.angle,'Normalization','pdf','FaceColor',[68/255,68/255,255/255],'FaceAlpha',0.5,'edgecolor','none'); 
          histogram(obj.normalizedTorque,'Normalization','pdf','FaceColor',[238/255,48/255,0],'FaceAlpha',0.5,'edgecolor','none');
          
          
          %pd = fitdist(obj.angle,'Kernel');
         % pd2 = fitdist(obj.normalizedForce,'Kernel');
          %y = pdf(pd,intervalAngle);
          %y2 = pdf(pd2,intervalForce);
          %plot(intervalAngle,y,'Color',[68/255,68/255,255/255]);
          %plot(intervalForce,y2,'Color',[238/255,48/255,0])
          xlabel('Valor')
          legend('聲gulo','Torca Normalizada')
          hold off
       end
       
       function fig = superPlot(obj,sketcher,cart,tit)
          fig = figure();
          hold on
          %Graficamos el 嫕gulo
          subplot(4,2,2)
          plot(obj.t,obj.angle);
          title('Regulada')
          xlabel('Tiempo (s)')
          ylabel('聲gulo (rad)')
          
          %Graficamos la fuerza
          subplot(4,2,4)
          plot(obj.t,obj.torque)
          title('Reguladora')
          ylabel('Torca (N m)')
          
          %Graficamos la energia 
          subplot(4,2,6)
          plot(obj.t,obj.energy)
          title('Energia')
          xlabel('Tiempo (s)')
          ylabel('Energ燰 (J)')
          
          %dibujamos el p幯dulo invertido 
          subplot(4,2,1);
          title(tit)
          sketcher.drawModelRobot()
          p = get(gca,'Position');
          %Change the width 
          pDiff = p(3)/2;
          p(3) = p(3)-pDiff;
          p(1) = p(1)+pDiff/2;
          set(gca, 'Position', p);
          
          %El diagrama de bode
          subplot(4,2,[3,5])
          h = bodeplot(cart.angleFunction);
          options = getoptions(h);
          options.Title.String = 'Diagrama de Bode de G_{loop,\theta} (s)';
          options.Title.FontSize = 10;
          options.XLabel.String = 'Frecuencia';
          options.XLabel.FontSize = 10;
          options.FreqUnits = 'Hz';
          options.YLabel.String = {'Magnitud' 'Fase'};
          options.YLabel.FontSize = 10;
          setoptions(h,options);
          
          %La distribucion
          subplot(4,2,[7,8])
          title('Distribuciones')
          obj.drawDistribution();
          p = get(gca,'Position');
          p(2) = p(2)-0.06;
          set(gca,'Position',p);
          hold off 
          
       end
       
       function rpm = getRPM(obj,robot)
          %This function will calculate the rpm 
          deltaT = diff(obj.t');
          velocity = diff(obj.position)./ deltaT;
          velocity = [velocity;velocity(end)];
          rpm = velocity *(60/(2*pi*robot.radiusWheels));
       end
  
       
   end
    
    
    
    
end