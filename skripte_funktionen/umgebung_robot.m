function [right,left,above,below,ap] = umgebung_robot(y,x,a,b,A)
% below
if y+1 > a
    below = 3;
else
    below = A(y+1,x);
end

% above
if y-1 < 1
    above = 3;
else
    above = A(y-1,x);
end

% left
if x-1 < 1
    left = 3;
else
    left = A(y,x-1);
end

% right
if x+1 > b
    right = 3;
else
    right = A(y,x+1);
end

% Aktuelle Position
ap = A(y,x);
end