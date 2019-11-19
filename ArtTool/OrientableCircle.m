classdef OrientableCircle
    properties
       center;
       radius;
       orientation;
    end
    
    
    methods
        
        function obj = OrientableCircle(center,radius,orientation)
            obj.center = center;
            obj.radius = radius;
            %Orientation is an angle in degrees. 
            obj.orientation = orientation;
        end
        
        function rect = drawHorizontalRectangle(obj)
           corner = obj.center-[obj.radius obj.radius];
           rect = rectangle('Position',[corner 2*obj.radius 2*obj.radius],'FaceColor',[1,196/255,26/255],'Curvature',1);
        end
        
        
    end
    
end