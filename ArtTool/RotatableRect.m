%A rotatable rectangle class because MATLAB doesn't have one
%(WTH matlab)

classdef RotatableRect
   properties
      x;
      y;
      width;
      height;
      corners;
      rectPatch;
   end
   methods
       %The constructor
       function obj = RotatableRect(x,y,width,height)
           obj.x = x;
           obj.y = y;
           obj.width = width;
           obj.height = height;
           obj.corners = [obj.x obj.y ; obj.x+obj.width obj.y;obj.x+obj.width obj.y+obj.height; obj.x obj.y+obj.height];
       end
       
       
       function [fig,rotCorners] = drawRotatedRect(obj,angle,pointOfRotation)
           
           %First do some rotation operations
           rotMatrix = [cosd(angle) sind(angle);-sind(angle) cosd(angle)];
           rotCorners = zeros(4,2);
           for i = 1:4
            rotCorners(i,:) = pointOfRotation + rotMatrix*(obj.corners(i,:)'-pointOfRotation);
           end
           %Now draw it
           fig = patch(rotCorners(:,1),rotCorners(:,2),[105/255,105/255,105/255]);
       end
       
       function [fig,rotCorners] = drawColoredRotatedRect(obj,angle,pointOfRotation,color)
           
           %First do some rotation operations
           rotMatrix = [cosd(angle) sind(angle);-sind(angle) cosd(angle)];
           rotCorners = zeros(4,2);
           for i = 1:4
            rotCorners(i,:) = pointOfRotation + rotMatrix*(obj.corners(i,:)'-pointOfRotation);
           end
           %Now draw it
           fig = patch(rotCorners(:,1),rotCorners(:,2),[105/255,105/255,105/255],'FaceColor',color);
       end
   end
    
end