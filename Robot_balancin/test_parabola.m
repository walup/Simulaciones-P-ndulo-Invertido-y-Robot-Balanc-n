%% Test parabola 

%% Create a robot
massWheels = 0.1;
massChasis = 0.6;
height = 0.3;
width = 0.15;
radius = 0.05;

robot = BalanceRobot(massChasis,massWheels,width, height,radius);

%% Get the parabola 
par = robot. computeParabola(10,50);