function resultI = BilateralFilt2(I,d,sigma)  
%%%  
%Author£ºLiFeiteng  
%Version£º1.0¡ª¡ªgray image  Time£º2013/05/01  
%Version£º1.1¡ª¡ªgray/colorimage  Time£º2013/05/02  2013/05/05  
%d half window width 
I = double(I);  
if size(I,3)==1  
    resultI = BilateralFiltGray(I,d,sigma);  
elseif size(I,3)==3  
    resultI = BilateralFiltColor(I,d,sigma);  
else   
    error('Incorrect image size')      
end  
end  
  
function resultI = BilateralFiltGray(I,d,sigma)  
  
[m n] = size(I);  
newI = ReflectEdge(I,d);  
resultI = zeros(m,n);  
width = 2*d+1;  
%Distance  
D = fspecial('gaussian',[width,width],sigma(1));  
S = zeros(width,width);%pix Similarity  
h = waitbar(0,'Applying bilateral filter...');  
set(h,'Name','Bilateral Filter Progress');  
for i=1+d:m+d  
    for j=1+d:n+d  
        pixValue = newI(i-d:i+d,j-d:j+d);  
        subValue = pixValue-newI(i,j);  
        S = exp(-subValue.^2/(2*sigma(2)^2));  
        H = S.*D;  
        resultI(i-d,j-d) = sum(pixValue(:).*H(:))/sum(H(:));   
    end  
    waitbar(i/m);  
end  
close(h);  
end  
  
function resultI = BilateralFiltColor(I,d,sigma)  
I = applycform(I,makecform('srgb2lab'));  
[m n ~] = size(I);  
newI = ReflectEdge(I,d);  
resultI = zeros(m,n,3);  
width = 2*d+1;  
%Distance  
D = fspecial('gaussian',[width,width],sigma(1));  
% [X,Y] = meshgrid(-d:d,-d:d);  
% D = exp(-(X.^2+Y.^2)/(2*sigma(1)^2));  
S = zeros(width,width);%pix Similarity  
h = waitbar(0,'Applying bilateral filter...');  
set(h,'Name','Bilateral Filter Progress');  
sigma_r = 100*sigma(2);  
for i=1+d:m+d  
    for j=1+d:n+d  
        pixValue = newI(i-d:i+d,j-d:j+d,1:3);  
        %subValue = pixValue-repmat(newI(i,j,1:3),width,width);  
        dL = pixValue(:,:,1)-newI(i,j,1);  
        da = pixValue(:,:,2)-newI(i,j,2);  
        db = pixValue(:,:,3)-newI(i,j,3);  
        S = exp(-(dL.^2+da.^2+db.^2)/(2*sigma_r^2));  
        H = S.*D;  
        H = H./sum(H(:));  
        resultI(i-d,j-d,1) = sum(sum(pixValue(:,:,1).*H));   
        resultI(i-d,j-d,2) = sum(sum(pixValue(:,:,2).*H));      
        resultI(i-d,j-d,3) = sum(sum(pixValue(:,:,3).*H));      
    end  
    waitbar(i/m);  
end  
close(h);  
resultI = applycform(resultI,makecform('lab2srgb'));  
end  