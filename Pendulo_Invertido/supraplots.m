%% Superplots
cart = InvertedPendulum(0.1,0.65,0.15);
%par = cart.computeParabola(10,60);
%% Underdamped
cart = cart.setPID(30,160,100);
prc = DataProcessor(cart,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),cart,'Subamortiguado')
%% Overdamped
cart = cart.setPID(200,160,15);
prc = DataProcessor(cart,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),cart,'Sobreamortiguado');
%% Critically damped

cart = cart.setPID(153.5333,160,33.5796);
prc = DataProcessor(cart,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),cart,'Crítico')