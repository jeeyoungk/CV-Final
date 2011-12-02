% Author: Jeeyoung Kim
% Edge detector.

DIM = 4;
SIZE = DIM * 2 + 1;
OFFSET = DIM + 1;
SIGMA = 1;
G = zeros(SIZE, SIZE);
for x=-DIM:DIM
  for y=-DIM:DIM
    absval = sqrt(x^2 + y^2);
    G(x+OFFSET,y+OFFSET) = normpdf(absval, 0, SIGMA);
  end
end

DX = zeros(DIM*2+1-4, DIM*2+1-4);
DY = zeros(DIM*2+1-4, DIM*2+1-4);

% Calculate the derivatives for G.
for x=-DIM+2:DIM-2,
    for y=-DIM+2:DIM-2,
        % Normalized x, y to the matrix.
        nx = x + DIM + 1;
        ny = y + DIM + 1;
        dx = (-G(nx+2, ny) + 8*G(nx+1, ny) - 8*G(nx-1, ny) + G(nx-2, ny))/12;
        dy = (-G(nx, ny+2) + 8*G(nx, ny+1) - 8*G(nx, ny-1) + G(nx, ny-2))/12;
        DX(nx-2,ny-2)=dx;
        DY(nx-2,ny-2)=dy;
    end
end

% rgbI = imread('samples/Haruhi.PNG');
rgbI = imread('samples/bookshelf.jpg');
rgbI = imresize(rgbI, 0.25);
%rgbI = imread('samples/ladder.jpg');
% rgbI = rgbI(1:100,101:200,:);
I = rgb2gray(rgbI);
I = double(I);
s = size(I);
convx = conv2(DX, I);
convy = conv2(DY, I);
convx = convx(1+2:s(1)+2,1+2:s(2)+2);
convy = convy(1+2:s(1)+2,1+2:s(2)+2);
result = (convx.^2 + convy.^2).^0.5;
angle = atan(convx ./ convy);
t = round(angle / pi * 4 + 2);
% identify 0 with 8.
t = t .* (t ~= 4);
filtered = (t - (t-4) .* (result <= 15));
% quiver(...); % Use this to plot.

% Non-maximal suppression.
good = zeros(s);
for row=2:s(1)-1
	for col=2:s(2)-1
		dir = t(row, col);
		cur = result(row, col);
		% dir == 0, 1, 2, or 3
		if (dir == 0) % Horizontal
			compared = [result(row-1, col), result(row+1, col)];
		elseif (dir == 1) % Down-right / Up-left
			compared = [result(row+1, col-1), result(row-1, col+1)];
		elseif (dir == 2) % Vertical
			compared = [result(row, col-1), result(row, col+1)];
		elseif (dir == 3) % Down-left / Up-right
			compared = [result(row-1, col-1), result(row+1, col+1)];
		end
		all = [compared cur];
		good(row, col) = (max(all) == cur);
	end
end
good = good .* result;

% hysteresis thresholding.
[pixels, idx] = sort(good(:), 'decend')
