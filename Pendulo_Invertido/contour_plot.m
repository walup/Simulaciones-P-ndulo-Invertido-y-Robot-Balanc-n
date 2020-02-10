%Contour plots
figure()
sgtitle('Correlaci�n energ�a - �ngulo contornos')
subplot(1,2,1)
hold on 
title('P�ndulo invertido de masa puntual')
contourf(pGrid,dGrid,corrMapEnergy)
plot(pData,parVec,'Color','red');
colorbar;
set(gca,'YDir','normal')
text(110,45,'Par�bola de estabilidad \rightarrow','Color','w');
xlabel('kp')
ylabel('kd')
xlim(xVec)
ylim(yVec)
hold off

subplot(1,2,2)
hold on 
title('Robot balanc�n')
contourf(pGridRobot,dGridRobot,corrMapEnergyRobot)
plot(pDataRobot,parVecRobot,'Color','red');
colorbar;
set(gca,'YDir','normal')
text(105,45,'Par�bola de estabilidad \rightarrow','Color','w');
xlabel('kp')
ylabel('kd')
xlim(xVecRobot)
ylim(yVecRobot)
hold off