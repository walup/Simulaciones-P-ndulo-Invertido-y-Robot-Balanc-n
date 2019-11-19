%% 
%% Superplots
robot = BalanceRobot(massChasis,massWheels,width, height,radius);
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