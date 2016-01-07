function [trk_magnitude,trk_orientation] = trk2magori1(data,prespective,options)
% data=Tracklets_matrix;
ImageName=imread(options.ImageName);
magx = abs(data(:,4:3:end-2) - data(:,1:3:end-5));
magy = abs(data(:,5:3:end-1) - data(:,2:3:end-4));
 magx(magx>5)=5;
 magy(magy>5)=5;
x = data(:,((ceil(size(magx,2)/2))*3)+1);
y = data(:,((ceil(size(magy,2)/2))*3)+2);
for i=1:length(y)
 
    if(y(i)>size(ImageName,1)||x(i)>size(ImageName,2)||y(i)<=0||x(i)<=0)
        W(i)=0;
    else
w(i,1) = prespective(y(i),x(i));
    end
end
% magx(magx>7)=7;
% magy(magy>7)=7;
%  w=(abs(double(size(ImageName,1)-data(:,3*floor(size(data(:,1:3:end-1),2)/2)+2))))/((size(ImageName,1)));

% C = bsxfun( @times,magy,w);
% trk_magnitude =sum((sqrt((magx).^2 + (C ).^2)),2);
 trk_magnitude =sum(sqrt((magx).^2 + (magy ).^2),2).*w;
trk_orientation = atan2(data(:,end-2) - data(:,1), (data(:,end-1) - data(:,2)+eps));
% trk_magnitude(trk_magnitude>7)=1;
