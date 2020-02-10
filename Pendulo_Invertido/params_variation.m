%First we calculate the 3 parabolas with different masses
cart  = InvertedPendulum(0.1,0.65,0.15);
par = cart.computeParabola(10,60);

cart  = InvertedPendulum(0.1,2*0.65,0.15);
par2 = cart.computeParabola(10,60);
%%
cart  = InvertedPendulum(0.1,3*0.65,0.15);
par3 = cart.computeParabola(10,60);
%%
cart  = InvertedPendulum(0.1,0.65,3*0.15);
par4 = cart.computeParabola(10,60);

cart  = InvertedPendulum(0.1,0.65,4*0.15);
par5 = cart.computeParabola(10,60);


%%
xInterval = linspace(80,200,10000);
y1 = polyval(par,xInterval);
y2 = polyval(par2,xInterval);
y3 = polyval(par3,xInterval);
y4 = polyval(par4,xInterval);
y5 = polyval(par5,xInterval);
figure()
sgtitle('Efecto de variar parámetros físicos en el péndulo invertido')
subplot(1,2,1)
hold on
title('Efecto de la variación de masa')
plot(xInterval,y1)
plot(xInterval,y2)
plot(xInterval,y3)
legend('M = '+string(0.65),'M = '+string(2*0.65),'M = '+string(3*0.65))
xlabel('kp')
ylabel('kd')
xlim([80,200])
%ylim([10,60])
hold off

subplot(1,2,2)
hold on 
title('Efecto de la variación de longitud')
plot(xInterval,y1)
plot(xInterval,y4)
plot(xInterval,y5)
legend('l = '+string(0.15),'l = '+string(2*0.15),'l = '+string(3*0.15))
xlabel('kp')
ylabel('kd')
xlim([80,200])
hold off