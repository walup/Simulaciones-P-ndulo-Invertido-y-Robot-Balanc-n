%This class has all the neccesary tools to draw the 
%inverted pendulum and the balance robot
classdef Sketcher 
    
    properties
       widthCart;
       heightCart;
       barLength;
       barWidth;
       ballRadius;
       widthChasis;
       heightChasis;
       radiusWheels;
    end
    
    
    methods
        function obj = Sketcher()
           %Initialize the sizes of things
           
           obj.barLength = 4;
           obj.widthCart = 4;
           obj.heightCart = 2;
           obj.radiusWheels = (1/3)*obj.widthCart;
           obj.ballRadius = 3/4;
           obj.barWidth = 4/8;
           obj.widthChasis = 2;
           obj.heightChasis = 3.5;
        end
        
        function fig = drawInvertedPendulum(obj,x,angle)
           grid off;
           %Draw the cart 
           xBox = x-obj.widthCart/2;
           rectangle('Position',[xBox obj.radiusWheels obj.widthCart obj.heightCart],'FaceColor',[102/255, 101/255, 205/255]); 
           %Draw the wheels 
           %First wheel 
           rectangle('Position',[xBox 0 obj.radiusWheels obj.radiusWheels],'FaceColor',[0.75 0.75 0.75],'Curvature', [1 1]);
           %Second wheel 
           rectangle('Position',[xBox+obj.widthCart-obj.radiusWheels 0 obj.radiusWheels obj.radiusWheels],'FaceColor',[0.75 0.75 0.75],'Curvature', [1 1]);
           %Draw the bar 
           rodX = xBox+obj.widthCart/2-obj.barWidth/2;
           rodY = obj.radiusWheels + obj.heightCart;
           angleDegrees = rad2deg(angle);
           bar = RotatableRect(rodX,rodY,obj.barWidth,obj.barLength);
           [~,corners] = bar.drawRotatedRect(angleDegrees,[rodX + obj.barWidth/2;rodY]);
           
           %Draw the point mass 
           middlePoint = (corners(3,:)+corners(4,:))/2;
           center = middlePoint+[obj.ballRadius*sind(angleDegrees) obj.ballRadius*cosd(angleDegrees)];
           mass = OrientableCircle(center,obj.ballRadius,angleDegrees);
           mass.drawHorizontalRectangle();
           
           xlim([-4*obj.widthCart,4*obj.widthCart]);
           ylim([-2*obj.barLength,3*obj.barLength]);
        end
        
        function fig = drawRobot(obj,x,angle)
            %Draw the chasis
            xWheel = x-obj.radiusWheels/2;
            xChasis = x-obj.widthChasis/2;
            yChasis = obj.radiusWheels;
            chasis = RotatableRect(xChasis,yChasis,obj.widthChasis,obj.heightChasis);
            angleDegrees = rad2deg(angle);
            chasis.drawColoredRotatedRect(angleDegrees,[xWheel+obj.radiusWheels/2;obj.radiusWheels/2],[53/255,49/255,255/255])
            %Draw the wheel 
            rectangle('Position',[xWheel 0 obj.radiusWheels obj.radiusWheels],'FaceColor',[0.75 0.75 0.75],'Curvature', [1 1]);
            %Let's draw an inner yellow wheel
            newRadius = (2/3)*obj.radiusWheels;
            deltaRadius = obj.radiusWheels-newRadius;
            rectangle('Position',[xWheel+deltaRadius/2 deltaRadius/2 newRadius newRadius],'FaceColor',[1,196/255,26/255],'Curvature',[1 1]);
            xlim([-4*obj.widthChasis,4*obj.widthChasis]);
            ylim([-2*obj.heightChasis,3*obj.heightChasis]);
 
        end
        
        %Draws the prettiest of the prettiest
        function fig = drawModelPendulum(obj)
           axis off;
           x = 0;
           angle = pi/4;
           %Draw the cart 
           xBox = x-obj.widthCart/2;
           rectangle('Position',[xBox obj.radiusWheels obj.widthCart obj.heightCart],'FaceColor',[102/255, 101/255, 205/255]); 
           %Draw the wheels 
           %First wheel 
           rectangle('Position',[xBox 0 obj.radiusWheels obj.radiusWheels],'FaceColor',[0.75 0.75 0.75],'Curvature', [1 1]);
           %Second wheel 
           rectangle('Position',[xBox+obj.widthCart-obj.radiusWheels 0 obj.radiusWheels obj.radiusWheels],'FaceColor',[0.75 0.75 0.75],'Curvature', [1 1]);
           %Draw the bar 
           rodX = xBox+obj.widthCart/2-obj.barWidth/2;
           rodY = obj.radiusWheels + obj.heightCart;
           angleDegrees = rad2deg(angle);
           bar = RotatableRect(rodX,rodY,obj.barWidth,obj.barLength);
           [~,corners] = bar.drawRotatedRect(angleDegrees,[rodX + obj.barWidth/2;rodY]);
           
           %Draw the point mass 
           middlePoint = (corners(3,:)+corners(4,:))/2;
           center = middlePoint+[obj.ballRadius*sind(angleDegrees) obj.ballRadius*cosd(angleDegrees)];
           mass = OrientableCircle(center,obj.ballRadius,angleDegrees);
           mass.drawHorizontalRectangle();
           xlim([-4.5,4.5]);
           ylim([0,8]);
        end
        
        function fig = drawModelRobot(obj)
           axis off
           x = 0;
           angle = pi/4;
           %Draw the chasis
           xWheel = x-obj.radiusWheels/2;
           xChasis = x-obj.widthChasis/2;
           yChasis = obj.radiusWheels;
           chasis = RotatableRect(xChasis,yChasis,obj.widthChasis,obj.heightChasis);
           angleDegrees = rad2deg(angle);
           chasis.drawColoredRotatedRect(angleDegrees,[xWheel+obj.radiusWheels/2;obj.radiusWheels/2],[53/255,49/255,255/255])
           %Draw the wheel 
           rectangle('Position',[xWheel 0 obj.radiusWheels obj.radiusWheels],'FaceColor',[0.75 0.75 0.75],'Curvature', [1 1]);
           %Let's draw an inner yellow wheel
           newRadius = (2/3)*obj.radiusWheels;
           deltaRadius = obj.radiusWheels-newRadius;
           rectangle('Position',[xWheel+deltaRadius/2 deltaRadius/2 newRadius newRadius],'FaceColor',[1,196/255,26/255],'Curvature',[1 1]);
           xlim([-4*obj.widthChasis,4*obj.widthChasis]);
           ylim([-2*obj.heightChasis,3*obj.heightChasis]);
           xlim([-4,4]);
           ylim([0,4.5]);
        end
        
    end
    
    
end