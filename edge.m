% Author: Jeeyoung Kim
% Edge detector.

DIM = 20;
SIZE = DIM * 2 + 1;
OFFSET = DIM + 1;
G = zeros(SIZE, SIZE);
for x=-DIM:DIM
  for y=-DIM:DIM
    absval = sqrt(x^2 + y^2);
    G(x+OFFSET,y+OFFSET) = normpdf(absval, 0, 10);
  end
end
