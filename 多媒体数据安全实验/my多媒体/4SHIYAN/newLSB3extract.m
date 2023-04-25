%这段代码的主要功能是从一张含有私密信息的图像（'stego.bmp'）中提取隐藏的二进制
%信息，并将提取的信息保存到一个文本文件（'LSB.txt'）中。

% 读取含有私密信息的图像'stego.bmp'，并将其赋值给变量Picture
Picture = imread('stego.bmp');
rng(1,'twister'); %将种子设定为1，生成器为梅森旋转
r4 = randi(10,3000,1); %创建1 到10 之间的随机整数值数组


% 获取Picture的大小，其中m为行数，n为列数
[m,n]=size(Picture);
% 加载原始图像

% 以写入方式打开'LSB.txt'文件，并将文件标识符存储在frr变量中
frr=fopen('LSB.txt','w');

% 设置要提取的私密信息长度为80
len=640;
% 打开存放秘密信息的文件

% 初始化变量p
p=1;
tempi=1;
tempj=r4(tempi);
% 使用两层循环遍历Picture的每个像素
for f2=1:n
   for f1=1:m
        if(tempj==0)
          % 判断当前像素的最低有效位（Least Significant Bit，LSB）是否为1
          if bitand(Picture(f1,f2),1)==1
             % 如果是1，则将1写入'LSB.txt'文件，并将结果存储在result变量中
             disp(1);
             fwrite(frr,1,'ubit1');
             result(p,1)=1;
          else
             % 如果是0，则将0写入'LSB.txt'文件，并将结果存储在result变量中
             disp(0);
             fwrite(frr,0,'ubit1');
             result(p,1)=0;
          end
            tempi=tempi+1;
            tempj=r4(tempi);
            disp(Picture(f1,f2));

          if p<len
              p=p+1;
          end
        end
        tempj=tempj-1;
      % 如果p达到了设置的提取长度（len），跳出循环
      if p>=len
          break;
      end
      % 如果p小于设置的提取长度（len），将p加1
   end
   % 如果p达到了设置的提取长度（len），跳出循环
   if p>=len
       break;
   end
end

% 关闭文件标识符frr
fclose(frr);
