over='cover.jpg'; % 原始的JPEG图像
stego='stegoF3.jpg'; % 嵌入了隐藏信息的JPEG图像
frr=fopen('F3_dec_res.txt','a'); % 打开一个文件，用于存储提取出的信息
try 
    jobj=jpeg_read(stego); % 读取嵌入了隐藏信息的JPEG图像
    dct=jobj.coef_arrays{1}; % 获取JPEG图像的DCT系数
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)'); % 若读取出错，则抛出异常
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end)); % 计算图像中可以嵌入信息的最大长度
len=80; % 需要提取的信息长度
p=1; % 初始化信息提取位置
[m,n]=size(dct); % 获取DCT系数矩阵的大小
for f2 =1:n
    for f1 =1:m
        if(dct(f1,f2)==0) % 如果DCT系数为0，则跳过
            continue;
        end
        odd=mod(dct(f1,f2),2); % 计算该DCT系数的奇偶性
        fwrite(frr,odd,'ubit1'); % 将该DCT系数的奇偶性写入文件
        if(p==len) % 如果已经提取完所有信息
            break;
        end
        p=p+1; % 更新下一个提取位置
    end
    if p ==len % 如果已经提取完所有信息
        break;
    end
end

%fprintf(frr),
fclose(frr); % 关闭文件句柄
