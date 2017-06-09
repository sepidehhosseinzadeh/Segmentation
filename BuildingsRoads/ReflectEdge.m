function newI = ReflectEdge(I,d)  
%Version£º1.0¡ª¡ªgrayimage  Time£º2013/05/01  
%Version£º1.1¡ª¡ªgray/colorimage  Time£º2013/05/02  
%considering the practical£¬uniformly use£ºreflect across edge  
  
if size(I,3)==1  
    newI = ReflectEdgeGray(I,d);  
elseif size(I,3)==3  
    newI = ReflectEdgeColor(I,d);  
else   
    error('Incorrect image size')      
end  
end  


function newI = ReflectEdgeGray(I,d) 
%expand image boundary
[m n] = size(I);  
newI = zeros(m+2*d,n+2*d);  
%middle 
newI(d+1:d+m,d+1:d+n) = I;  
%up
newI(1:d,d+1:d+n) = I(d:-1:1,:);  
%down  
newI(end-d:end,d+1:d+n) = I(end:-1:end-d,:);  
%left
newI(:,1:d) = newI(:,2*d:-1:d+1);  
%right
newI(:,m+d+1:m+2*d) = newI(:,m+d:-1:m+1);  
end  


function newI = ReflectEdgeColor(I,d)  
%expand image boundary
[m n ~] = size(I);  
newI = zeros(m+2*d,n+2*d,3);  
%middle  
newI(d+1:d+m,d+1:d+n,1:3) = I;  
%up 
newI(1:d,d+1:d+n,1:3) = I(d:-1:1,:,1:3);  
%down  
newI(end-d:end,d+1:d+n,1:3) = I(end:-1:end-d,:,1:3);  
%left
newI(:,1:d,1:3) = newI(:,2*d:-1:d+1,1:3);  
%right
newI(:,n+d+1:n+2*d,1:3) = newI(:,n+d:-1:n+1,1:3);  
end  