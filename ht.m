
% hysteresis thresholding.
HIGH = 10
LOW = 5
[pixels, indices] = sort(good(:), 'descend');
indices = int32(indices);
sp = size(pixels);

ROWS = int32(s(1));
COLS = int32(s(2));
rows = idivide(indices, ROWS);
cols = mod(indices, ROWS);
for i=2:sp(2)
end
