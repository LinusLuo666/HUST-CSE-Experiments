cover='cover.jpg'; % 待嵌入信息的JPEG图像
stego='stegoF4.jpg'; % 嵌入信息后的JPEG图像
wen.txt_id=fopen('hide.txt','r'); % 打开包含隐藏信息的文本文件
[msg,L]=fread(wen.txt_id,'ubit1'); % 读取文本文件中的信息
try 
    jobj=jpeg_read(cover); % 读取待嵌入信息的JPEG图像
    dct=jobj.coef_arrays{1}; % 获取JPEG图像的DCT系数
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)'); % 若读取出错，则抛出异常
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end)); % 计算图像中可以嵌入信息的最大长度
%numel函数返回的是矩阵中所有元素的个数
if(length(msg)>AC)
    error('ERROR(too long message)'); % 若信息长度超过最大可嵌入长度，则抛出异常
end
len=length(msg); % 获取信息长度
id=1; % 初始化嵌入信息的位置
[m,n]=size(dct); % 获取DCT系数矩阵的大小
for f2 =1:n
    for f1 =1:m
        if((dct(f1,f2))==0) % 如果DCT系数为0，则跳过
            continue;
        end
        if(dct(f1,f2)==1 &&msg(id,1)==0) % 如果DCT系数为1，而嵌入信息为0，则将DCT系数变为0
            dct(f1,f2)=0;
            continue;
        end
        if(dct(f1,f2)>=1) % 如果DCT系数大于等于1（正数）
            odd=mod(dct(f1,f2),2); % 计算该系数的奇偶性
            if(msg(id,1)~=odd) % 如果DCT系数的奇偶性和嵌入信息不同，则将该系数减1
                dct(f1,f2)=dct(f1,f2)-1;
            end
        end
        if(dct(f1,f2)==-1 &&msg(id,1)==1) % 如果DCT系数为-1，而嵌入信息为1，则将DCT系数变为0
            dct(f1,f2)=0;
            continue;
        end
        if(dct(f1,f2)<=-1) % 如果DCT系数小于等于-1（负数）
            odd=abs(mod(dct(f1,f2),2)); % 计算该系数的奇偶性
            if(msg(id,1)==odd) % 如果DCT系数的奇偶性和嵌入信息相同，则将该系数加1
                dct(f1,f2)=dct(f1,f2)+1;
            end
        end
        if(id==len) % 如果已经嵌入完
            break;
        end
        id=id+1; % 更新下一个嵌入
    end
    if id ==len
        break;
    end
end
      
try 
    jobj.coef_arrays{1}=dct;
    jobj.optimize_coding=1;
    jpeg_write(jobj,stego); % 将嵌入信息后的DCT系数写入新的JPEG文件中
catch
    error('ERROR (problem with saving the stego image)') % 若写入出错，则抛出异常
end
subplot(2,2,1);
imshow(cover);
title('initial image');
subplot(2,2,2);
imshow(stego);
title('after image');
subplot(2,2,3);
% i=1;
% j=1;
% for f1 =1:n
%     for f2=1:m
%         if(dct1(f1,f2)>=-8 &&dct1(f1,f2)<=8)
%             dcti(i,j)=dct1(f1,f2);
%             j=j+1;
%         end
%     end
%     i=i+1;
% end

hist(dct1,300); % 绘制原图像的DCT系数直方图
axis([-8 8,0 inf]);
title('histogram of initial image');
subplot(2,2,4);
hist(dct,300); % 绘制嵌入信息后的DCT系数直方图
axis([-8 8,0 inf]);
title('histogram of after image');
%bar(dct);%bar(dct);
