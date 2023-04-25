cover='cover.jpg';
stego='stegojsteg.jpg';
% 定义原始图片文件名和隐写后的图片文件名。

wen.txt_id=fopen('hide.txt','r');
% 打开一个文件，用于读取要隐藏的消息。

[msg,L]=fread(wen.txt_id,'ubit1');
% 从文件中读取二进制消息，存储到变量 msg 中，L 表示读取的位数。

try 
    jobj=jpeg_read(cover);
    % 读取原始 JPEG 图片，将其存储到一个结构体 jobj 中。
    dct=jobj.coef_arrays{1};
    % 获取 jobj 结构体中的 DCT 系数矩阵，存储到变量 dct 中。
    dct1=jobj.coef_arrays{1};
    % 同时将 DCT 系数矩阵存储到另一个变量 dct1 中，后面将在 dct1 上进行操作。
catch
    error('Error(problem with the cover image)');
    % 如果读取原始图片失败，则抛出一个异常。
end

AC=numel(dct)-numel(dct(1:8:end,1:8:end));
% 计算 dct 矩阵中 AC 系数的数量，即 dct 中除去 DC 系数的数量。

if(length(msg)>AC)
    error('ERROR(too long message)');
end
% 如果要隐藏的消息的长度大于可用的隐写位数，则抛出一个异常。

len=length(msg);
% 获取要隐藏的消息的长度。

id=1;
% 计数器 id，用于记录已经隐藏的隐写信息的位数。

[m,n]=size(dct);
% 获取 dct 矩阵的大小，m 表示矩阵的行数，n 表示矩阵的列数。

for f2 =1:n
    for f1 =1:m
        % 对于 dct 矩阵中的每个系数进行以下操作：
        if(abs(dct(f1,f2))<=1)
            % 如果系数的绝对值小于等于 1，则跳过该系数。
            continue;
        end
        if(dct(f1,f2)>1)%正数
            % 如果系数是正数，则进行以下操作：
            odd=mod(dct(f1,f2),2);
            % 取出系数的最低位，存储到 odd 中。
            if(msg(id,1)==0&&odd==1)%奇数遇到0
                dct(f1,f2)=dct(f1,f2)-1;
                % 如果要隐藏的消息的当前位是 0，且 odd 是 1，则将 dct 中该系数的最低位改为 0。
            end
            if(msg(id,1)==1 && odd==0)
               dct(f1,f2)=dct(f1,f2)+1;
               % 如果要隐藏的消息的当前位是 1，且 odd 是 0，则将 dct 中该系数的最低位改为 1。
            end
        end
        if(dct(f1,f2)<-1)
            % 如果系数是负数，则进行以下操作：
            odd=abs(mod(dct(f1,f2),2));
            % 取出系数的最低位的绝对值，存储到 odd 中。
            if(msg(id,1)==0&&odd==1)%奇数遇到0
                dct(f1,f2)=dct(f1,f2)+1;
                % 如果要隐藏的消息的当前位是 0，且 odd 是 1，则将 dct 中该系数的最低位改为 0。
            end
            if(msg(id,1)==1 && odd==0)
                dct(f1,f2)=dct(f1,f2)-1;
            % 如果要隐藏的消息的当前位是 1，且 odd 是 0，则将 dct 中该系数的最低位改为 1。
            end
        end
        if(id==len)
            % 如果已经隐藏完所有的隐写信息，则跳出循环。
            break;
        end
        id=id+1;
        % 计数器 id 加 1。
    end
    if id ==len
        % 如果已经隐藏完所有的隐写信息，则跳出循环。
        break;
    end
end
dctchange=dct-dct1;
% 计算 dct 矩阵中每个系数的变化量。

try
    jobj.coef_arrays{1}=dct;
    % 将修改后的 dct 矩阵存储到结构体 jobj 中。
    jobj.optimize_coding=1;
    % 优化编码。
    jpeg_write(jobj,stego);
    % 将隐写后的图片保存到文件中。
catch
    error('ERROR (problem with saving the stego image)')
    % 如果保存图片失败，则抛出一个异常。
end

% 下面是画出原始图片和隐写后的图片的直方图，以及它们的对比。

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

hist(dct1,300);
axis([-8 8,0 inf]);
title('histogram of initial image');
subplot(2,2,4);
hist(dct,300);
axis([-8 8,0 inf]);
title('histogram of after image');
%bar(dct);

% 此段代码实现了一个简单的LSB隐写术的信息嵌入过程。读入一个原始图像文件，提取
% 其中的DCT系数，并计算可嵌入信息的AC系数数量。在生成随机二进制信息后，将其
% 嵌入到DCT系数的最低位。嵌入时，对于每个AC系数，判断其是否为正数或负数，
% 再判断嵌入的信息是0还是1，从而修改DCT系数的奇偶性。嵌入完成后，
% 将修改后的DCT系数重新写入到一个JPEG图像文件中，完成信息隐藏。最后，
% 绘制原始图像和隐藏后的图像的DCT系数直方图，以比较它们的差异。