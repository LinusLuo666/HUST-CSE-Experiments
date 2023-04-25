Picture = imread('stego.bmp');
Picture = double(Picture);
[m,n]=size(Picture);
% 加载原始图像

frr=fopen('LSB.txt','w');
len=80;
% 打开存放秘密信息的文件
p=1;
for f2=1:n
   for f1=1:m
      if bitand(Picture(f1,f2),1)==1
         fwrite(frr,1,'ubit1');
         result(p,1)=1;
      else
         fwrite(frr,0,'ubit1');
         result(p,1)=0;
      end
      if p==len
          break;
      end
      if p<len
          p=p+1;
      end
   end
   if p==len
       break;
   end
end
fclose(frr);