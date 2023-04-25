cover='cover.jpg';
stego='stegojsteg.jpg';
% 定义原始图片文件名和隐写后的图片文件名。

frr=fopen('jsteg_dec_res.txt','a');
% 打开一个文件，用于存储提取出的隐写信息。

try % 可能会抛出异常的代码
    jobj=jpeg_read(stego);
    % 读取隐写后的 JPEG 图片，将其存储到一个结构体 jobj 中。
    dct=jobj.coef_arrays{1};
    % 获取 jobj 结构体中的 DCT 系数矩阵，存储到变量 dct 中。
    dct1=jobj.coef_arrays{1};
    % 同时将 DCT 系数矩阵存储到另一个变量 dct1 中，后面将在 dct1 上进行操作。
catch % 处理异常的代码
    error('Error(problem with the cover image)');
    % 如果读取隐写后的图片失败，则抛出一个异常。
end

AC=numel(dct)-numel(dct(1:8:end,1:8:end));
% 计算 dct 矩阵中 AC 系数的数量，即 dct 中除去 DC 系数的数量。

len=80;
% 定义需要提取的隐写信息的位数。

p=1;
% 计数器 p，用于记录已经提取出的隐写信息的位数。

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
            if(odd==0)%奇数
               fwrite(frr,0,'ubit1');
               % 如果 odd 是偶数，则向文件中写入一个 0。
            end
            if(odd==1)
               fwrite(frr,1,'ubit1');
              % 如果 odd 是奇数，则向文件中写入一个 1。
            end
        end
        if(dct(f1,f2)<-1)
            % 如果系数是负数，则进行以下操作：
            odd=abs(mod(dct(f1,f2),2));
            % 取出系数的绝对值的最低位，存储到 odd 中。
            if(odd==1)
                fwrite(frr,1,'ubit1');
                % 如果 odd 是奇数，则向文件中写入一个 1。
            end
            if(odd==0)
               fwrite(frr,0,'ubit1');
            % 如果 odd 是偶数，则向文件中写入一个 0。
            end
        end
        if(p==len)
        % 如果已经提取出 len 位隐写信息，则跳出循环。
            break;
        end
        p=p+1;
        % 计数器 p 加 1。
        end
        if p==len
        % 如果已经提取出 len 位隐写信息，则跳出循环。
            break;
        end
end
fclose(frr);
% 关闭文件。

