%% Superplots
cart = InvertedPendulum(0.1,0.65,0.15);
par = cart.computeParabola(10,60);
%% Underdamped
cart = cart.setPID(30,160,30);
prc = DataProcessor(cart,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),cart,'Subamortiguado')
%% Overdamped
cart = cart.setPID(200,160,15);
prc = DataProcessor(cart,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),cart,'Sobreamortiguado');
%% Critically damped
cart = cart.setPID(153.488,160,33.58);
prc = DataProcessor(cart,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),cart,'Crítico')

%% Tunning for the critical case
cart = cart.setPID(153.488,160,33.58);
%[type,poles] = cart.getStabilityType();
%disp('Estabilidad '+string(type));
%disp('Polo '+ string(poles));