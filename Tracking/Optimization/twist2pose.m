function [T] = twist2pose(twistVec)
    % Splitting the twist vector into angular and translational velocity
    % vectors
     v = twistVec(1:3)';
     w = twistVec(4:6)';
     
     % Constructing the rotational exponential coordinates matrix
     wSkewed = [0 -w(3) w(2); w(3) 0 -w(1); -w(2) w(1) 0;];
     
     % Handing zero rotation
     if(1 && ~any(w))
         R = eye(3);
         t = v;
     else
         % Rodrigues formula
         R = eye(3) + (wSkewed/norm(w)) * sin(norm(w)) + (((wSkewed)*(wSkewed))/(norm(w)*norm(w))) * (1 - cos(norm(w)));

         % Computing the 3 x 1 translational vector (expression from ethan eade doc)
         t = (eye(3) + (((1 - cos(norm(w))) / (norm(w)^2)) * wSkewed) + (((norm(w) - sin(norm(w))) / (norm(w)^3)) * (wSkewed * wSkewed))) * v;
     end
     
     % Constructing the 4 x 4 transformation matrix
     T = zeros(4);
     T(4,4) = 1;
     
     T(1:3,1:3) = R;
     T(1:3,4) = t';
     T = T(1:3,1:4);
end