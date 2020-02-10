%% Maps test
% Homeostatic map
generator = MapProcessor(100,250,20,60,cart);
%%
[normAngle,normForce,alphaH] = generator.getHomeostaticMap(60,@(x)heaviside(x));
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
sgtitle('Mapa norma ángulo')
imagesc(xVec,yVec,normAngle);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off

%Map of angle 
figure(2)
hold on 
sgtitle('Mapa norma fuerza')
imagesc(xVec,yVec,normForce)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off

figure(3)
hold on 
sgtitle('Mapa Parámetro homeostático')
imagesc(xVec,yVec,alphaH)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off

%% Reduced Homeostatic map
[sdAngle,sdForce,alphaHR] = generator.getReducedHomeostaticMap(60,@(x)heaviside(x));
%%
%Map of force
figure(1)
hold on
sgtitle('Mapa SD ángulo')
imagesc(xVec,yVec,sdAngle);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off

%Map of angle 
figure(2)
hold on 
sgtitle('Mapa SD fuerza')
imagesc(xVec,yVec,sdForce)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off

figure(3)
hold on 
sgtitle('Mapa Parámetro homeostático reducido')
imagesc(xVec,yVec,alphaHR)
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off
%% Correlaciòn entre fuerza y angulo

corrMap = generator.getCorrelationMap(60,@(x)heaviside(x));
%%
%Map of correlation
figure(1)
hold on
sgtitle('Mapa correlación fuerza - ángulo')
imagesc(xVec,yVec,corrMap);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off
%%
corrMapEnergy = generator.getEnergyCorrelationMap(60,@(x)heaviside(x));
%%
%Map of correlation
figure(1)
hold on
sgtitle('Mapa correlación energía - ángulo')
imagesc(xVec,yVec,corrMapEnergy);
xlabel('kp')
ylabel('kd')
colorbar;
set(gca,'YDir','normal')
plot(pData,parVec,'Color','red');
text(105,45,'Subamortiguado');
text(200,45,'Sobreamortiguado')
text(166,45,'Crítico \rightarrow');
xlim(xVec)
ylim(yVec)
hold off