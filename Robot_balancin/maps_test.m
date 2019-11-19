%% Maps test
% Homeostatic map
generator = MapProcessor(10,200,20,60,robot);
%%
[normAngle,normTorque,alphaH] = generator.getHomeostaticMap(60,@(x)heaviside(x));
%%
pData = generator.pRange;
dData = generator.dRange;
pGrid = generator.pGrid;
dGrid = generator.dGrid;

xVec = [min(pData),max(pData)];
yVec = [min(dData),max(dData)];
parVec = polyval(par,pData);

%Map of force
figure(1)
hold on
sgtitle('Mapa norma �ngulo')
imagesc(xVec,yVec,normAngle);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off

%Map of angle 
figure(2)
hold on 
sgtitle('Mapa norma torca')
imagesc(xVec,yVec,normTorque)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off

figure(3)
hold on 
sgtitle('Mapa Par�metro homeost�tico')
imagesc(xVec,yVec,alphaH)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off

%% Reduced Homeostatic map
[sdAngle,sdTorque,alphaHR] = generator.getReducedHomeostaticMap(60,@(x)heaviside(x));
%%
%Map of force
figure(1)
hold on
sgtitle('Mapa SD �ngulo')
imagesc(xVec,yVec,sdAngle);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off

%Map of angle 
figure(2)
hold on 
sgtitle('Mapa SD torca')
imagesc(xVec,yVec,sdTorque)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off

figure(3)
hold on 
sgtitle('Mapa Par�metro homeost�tico reducido')
imagesc(xVec,yVec,alphaHR)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off
%% Correlaci�n entre fuerza y angulo

corrMap = generator.getCorrelationMap(60,@(x)heaviside(x));
%%
%Map of correlation
figure(1)
hold on
sgtitle('Mapa correlaci�n torca - �ngulo')
imagesc(xVec,yVec,corrMap);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off
%%
corrMapEnergy = generator.getEnergyCorrelationMap(60,@(x)heaviside(x));
%%
%Map of correlation
figure(1)
hold on
sgtitle('Mapa correlaci�n energ�a - �ngulo')
imagesc(xVec,yVec,corrMapEnergy);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
xlim(xVec)
ylim(yVec)
hold off