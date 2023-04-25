cover='cover.jpg';  % 初始图像文件名
stego='stegoF4.jpg';  % 嵌入信息后的图像文件名
frr=fopen('F4_dec_res.txt','a');  % 打开一个文本文件，以便将提取出的隐藏信息写入其中
try 
    jobj=jpeg_read(stego);  % 读取嵌入信息后的JPEG文件
    dct=jobj.coef_arrays{1};  % 获取JPEG文件中的DCT系数
    dct1=jobj.coef_arrays{1};  
catch
    error('Error(problem with the cover image)');  % 报错：无法读取JPEG文件
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));  % 计算DCT系数中8x8块中AC系数的总数
len=80;  % 设置需要提取的隐藏信息的长度为80
p=1;  % 初始化计数器，用于统计已提取出的隐藏信息长度
[m,n]=size(dct);  % 获取DCT系数矩阵的大小
for f2 =1:n  % 遍历所有的列
    for f1 =1:m  % 遍历所有的行
        if(dct(f1,f2)==0)  % 如果当前DCT系数为0，则直接跳过
            continue;
        end
        if dct(f1,f2)>0  % 如果当前DCT系数为正数
            odd=mod(dct(f1,f2),2);  % 提取其最低位的信息
            fwrite(frr,odd,'ubit1');  % 将提取出的信息写入文件
        else  % 如果当前DCT系数为负数
            odd=mod(dct(f1,f2),2);  % 提取其最低位的信息
            fwrite(frr,mod(odd+1,2),'ubit1');  % 将提取出的信息的取反写入文件
        end
        if(p==len)  % 如果已经提取出了80位隐藏信息
            break;  % 退出循环
        end
        p=p+1;  % 统计已提取出的隐藏信息长度
    end
    if p ==len
        break;  % 退出循环
    end
end
fclose(frr);  % 关闭文件句柄
