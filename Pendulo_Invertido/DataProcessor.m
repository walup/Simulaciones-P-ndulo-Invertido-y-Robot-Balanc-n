%This class wlil process the simulations data
%it can do several things, from calculating the neeeded
%parameters to plotting time series or exporting an excel
%file 
classdef DataProcessor
   properties
      t;
      position;
      angle;
      force;
      energy;
      normalizedForce; 
      stability;
   end
   
   methods
       
       %The constructor receives a cart
       %and runs the simulation for a certain
       %signal
       
       function obj = DataProcessor(cart,time,input) 
          [obj.t,obj.force,obj.position,obj.angle,obj.energy] = cart.runSimulation(time,input);
          %Get the natural force 
          factor = cart.T^2/((cart.M+cart.m)*cart.l);
          %Obtain the normalized force
          obj.normalizedForce = obj.force*factor;
          obj.stability = cart.getStabilityType();
       end
      
       
       %Function to calculate the homeostatic parameter
       function [normAngle,normForce,alpha] = homeostaticParameter(obj)
           %Moments of angle
           skAngle = skewness(obj.angle);
           kurtosisAngle = kurtosis(obj.angle);
           sdAngle = std(obj.angle);
           normAngle = sqrt(skAngle^2+kurtosisAngle^2+sdAngle^2);
           %Moments of normalized force
           skForce = skewness(obj.normalizedForce);
           kurtosisForce = kurtosis(obj.normalizedForce);
           sdForce = std(obj.normalizedForce);
           normForce = sqrt(skForce^2+kurtosisForce^2+sdForce^2);
           
           %Compute the parameter
           alpha = normForce/normAngle;
       end
       
       function [sdAngle,sdForce,alpha] = reducedHomeostaticParameter(obj)
           %std of angle
           sdAngle = std(obj.angle);
           %std of normalized force
           sdForce = std(obj.normalizedForce);
           %The reduced homeostatic parameter
           alpha = sdForce/sdAngle;
       end
       
       %Correlation between force and angle
       function r = regCorrelation(obj)
           r = corrcoef(obj.force,obj.angle);
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
           plot(obj.t,obj.force)
           title('Fuerza')
           xlabel('Tiempo (s)')
           ylabel('Fuerza (N)')
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
          minAngle = min(obj.angle);
          maxAngle = max(obj.angle);
          minForce = min(obj.normalizedForce);
          maxForce = max(obj.normalizedForce);
          intervalAngle = linspace(minAngle,maxAngle,1000);
          intervalForce = linspace(minForce,maxForce,1000);
          
          hold on 
          histogram(obj.angle,'Normalization','pdf','FaceColor',[68/255,68/255,255/255],'FaceAlpha',0.5,'edgecolor','none'); 
          histogram(obj.normalizedForce,'Normalization','pdf','FaceColor',[238/255,48/255,0],'FaceAlpha',0.5,'edgecolor','none');
          
          
          %pd = fitdist(obj.angle,'Kernel');
         % pd2 = fitdist(obj.normalizedForce,'Kernel');
          %y = pdf(pd,intervalAngle);
          %y2 = pdf(pd2,intervalForce);
          %plot(intervalAngle,y,'Color',[68/255,68/255,255/255]);
          %plot(intervalForce,y2,'Color',[238/255,48/255,0])
          xlabel('Valor')
          legend('聲gulo','Fuerza normalizada')
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
          plot(obj.t,obj.force)
          title('Reguladora')
          xlabel('Tiempo (s)')
          ylabel('Fuerza (N)')
          
          %Graficamos la energia 
          subplot(4,2,6)
          plot(obj.t,obj.energy)
          title('Energia')
          xlabel('Tiempo (s)')
          ylabel('Energ燰 (J)')
          
          %dibujamos el p幯dulo invertido 
          subplot(4,2,1);
          title(tit)
          sketcher.drawModelPendulum()
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
   end
    
    
    
    
end