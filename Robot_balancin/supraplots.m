%% 
%% Superplots
massWheels = 0.1;
massChasis = 0.6;
height = 0.3;
width = 0.15;
radius = 0.05;
robot = BalanceRobot(massChasis,massWheels,width, height,radius);
par = robot.computeParabola(10,60);
%% Underdamped
robot = robot.setPID(30,160,100);
prc = DataProcessor(robot,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),robot,'Subamortiguado')
%% Overdamped
robot = robot.setPID(200,160,30);
prc = DataProcessor(robot,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),robot,'Sobreamortiguado');
%% Critically damped
robot = robot.setPID(138.968,160,30);
prc = DataProcessor(robot,60,@(x)heaviside(x));
prc.superPlot(Sketcher(),robot,'Crítico')

%% Tunning of the critical dampening 
robot = robot.setPID(138.968,160,30);
[type,poles]  = robot.getStabilityType();
disp('Estabilidad '+ string(type));
disp('Polos '+string(poles));
