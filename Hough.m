A=imread('test-1.jpg');%讀取圖片
%A=imread('test-2.jpg');%測資2
figure(1);imshow(uint8(A));
[Height, Width, Depth] = size(A);
gray=rgb2gray(A);%轉灰街
[frameHeight, frameWidth, frameDepth] = size(gray);
line = zeros(frameHeight, frameWidth,Depth);
line=uint8(line);
figure(2);imshow(uint8(gray));
%%
sobel = zeros(frameHeight, frameWidth, 'double');
hough = zeros(180,frameHeight+frameWidth*2);
for m = 2:frameWidth-1;
    for l = 2:frameHeight-1
        Gx = (gray(l-1, m+1) + 2*gray(l, m+1) + gray(l+1, m+1)) - ...
            (gray(l-1, m-1) + 2*gray(l, m-1) + gray(l+1, m-1));
        Gy = (gray(l+1, m-1) + 2*gray(l+1, m) + gray(l+1, m+1)) - ...
            (gray(l-1, m-1) + 2*gray(l-1, m) + gray(l-1, m+1));
        value = abs(Gx) + abs(Gy);
        sobel(l-1, m-1) = value;
    end
end 
syms sita m l r;
figure(3);imshow(uint8(sobel));
%%
%  //--------------------------------------------------------------------------------------------------------------Hough
maxl=0;
maxp=0;
for m=1:frameHeight
    for l=1:frameWidth
        if(sobel(m,l)>=100)
            for sita=1:180
                sitapi=(sita)*3.14/180;
                r=l*cos(sitapi)+m*sin(sitapi);
                k=fix(r); 
                hough((sita),(k+frameWidth))=hough(sita,(k+frameWidth))+1;%這邊要加frameWidth式為了避免陣列為負，因為k算出來可能是負的
                if(hough((sita),(k+frameWidth))>maxl)
                        maxl=hough((sita),(k+frameWidth));
                        sitatemp=sita;
                        rtemp=k;
                end
            end
        end
    end
end   
%  //---------------------------------------------------------------------------------------------------------DrawLine
for m=1:frameHeight
    for l=1:frameWidth
        sitapi=(sitatemp)*3.14/180;
        r=l*cos(sitapi)+m*sin(sitapi);
        k=fix(r);
        if(k==rtemp)
            line(m,l,1)=0;
            line(m,l,2)=255;
            line(m,l,3)=0;                           
        else
                line(m,l,:)=A(m,l,:);
        end
    end
end
figure(4);imshow(uint8(line));

