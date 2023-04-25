cover='cover.jpg'; % 设置原始图像文件名
stego='stegojsteg.jpg'; % 设置隐藏信息后的图像文件名

%disp("ok");
% 读取原始图像的DCT系数
try 
%disp("ok");
    jobj=jpeg_read(cover); % 读取JPEG图像文件
%disp("ok");
    dct=jobj.coef_arrays{1}; % 提取DCT系数
%disp("ok");
    dct1=jobj.coef_arrays{1}; % 备份DCT系数
%disp("ok");
catch
    error('Error(problem with the cover image)'); % 报错提示原始图像文件有问题
end

disp("ok");
% 计算可嵌入信息的AC系数数量
insertable = dct ~= 0 & dct ~= 1; % 过滤掉DC系数和直流系数
%是一个逻辑数组，用于表示 dct 中所有不等于0或1的元素，即所有AC系数。

insertable(1:8:end, 1:8:end) = false; % 过滤掉Zigzag扫描的8x8块的第一个系数（DC系数）
AC=sum(insertable(:)); % 统计可嵌入信息的AC系数数量

% wen.txt_id=fopen('hide.txt','r');%隐藏的信息
% [msg,L]=fread(wen.txt_id,'ubit1');
% if(length(msg)>AC)
%     error('ERROR(too long message)');
% end
% 生成嵌入的信息（实际应该从文本文件中读取，此处用随机数代替）
msg=round(rand(AC,1)); % 生成随机的二进制信息

% 将信息嵌入DCT系数
len=length(msg); % 嵌入信息长度
id=1; % 当前嵌入信息的位置
[m,n]=size(dct); % DCT系数的尺寸
for f2 =1:n
    for f1 =1:m
        % 判断是否为DC系数或直流系数
        if(dct(f1,f2)==1 || dct(f1,f2) == 0)
            continue; % 跳过
        end
        % 判断是否为正数DCT系数
        if(dct(f1,f2)>1)%dct系数大于1
            odd=mod(dct(f1,f2),2);
            if(msg(id,1)==0 && odd==1)%嵌入信息为0，AC系数为奇数
               dct(f1,f2)=dct(f1,f2)-1; % 修改为偶数
            end
            if(msg(id,1)==1 && odd==0)%嵌入信息为1，AC系数为偶数
               dct(f1,f2)=dct(f1,f2)+1; % 修改为奇数
            end
        end
        % 判断是否为负数DCT系数
        if(dct(f1,f2)<0)%dct系数小于0
            odd=abs(mod(dct(f1,f2),2));
            if(msg(id,1)==0 && odd==1)%嵌入信息为0，AC系数为奇数
               dct(f1,f2)=dct(f1,f2)-1; % 修改为偶数
            end
            if(msg(id,1)==1 && odd==0)%嵌入信息为1，AC系数为偶数
               dct(f1,f2)=dct(f1,f2)+1; % 修改为奇数
            end
        end
        % 判断是否嵌入完所有信息
        if(id==len)
            break;
        end
        id=id+1;
    end
% 判断是否嵌入完所有信息
    if id ==len
        break;
    end
end

% 将嵌入信息后的DCT系数重新写入JPEG图像文件
try
    jobj.coef_arrays{1}=dct; % 更新DCT系数
    jobj.optimize_coding=1; % 优化编码
    jpeg_write(jobj,stego); % 写入JPEG图像文件
catch
    error('ERROR (problem with saving the stego image)') % 报错提示写入图像文件有问题
end

% 绘制图像和DCT系数直方图
subplot(2,2,1);
imshow(cover);
title('initial image');
subplot(2,2,2);
imshow(stego);
title('after image');
subplot(2,2,3);
histogram(dct1, 300);
axis([-16 16,0 2e4]);
title('histogram of initial image');
subplot(2,2,4);
histogram(dct,300);
axis([-16 16,0 2e4]);
title('histogram of after image');
% 此段代码实现了一个简单的LSB隐写术的信息嵌入过程。读入一个原始图像文件，提取
% 其中的DCT系数，并计算可嵌入信息的AC系数数量。在生成随机二进制信息后，将其
% 嵌入到DCT系数的最低位。嵌入时，对于每个AC系数，判断其是否为正数或负数，
% 再判断嵌入的信息是0还是1，从而修改DCT系数的奇偶性。嵌入完成后，
% 将修改后的DCT系数重新写入到一个JPEG图像文件中，完成信息隐藏。最后，
% 绘制原始图像和隐藏后的图像的DCT系数直方图，以比较它们的差异。
