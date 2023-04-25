clear all;
% 清除工作区中所有变量。

[fn,pn]=uigetfile({'*.jpg','JPEG files(*.jpg)';'*.bmp','BMP files(*.bmp)'},'Select file to hide');
% 弹出一个文件选择对话框，让用户选择一个 JPG 或 BMP 格式的图片文件。

name=strcat(pn,fn);
% 构造文件的完整路径。

t=imread(name);
% 读入图片文件。

I=t;
% 取图片的前 512 行和前 512 列，生成一个 512x512 的图像矩阵 I。

sz=size(I);
% 获取 I 的大小，生成一个包含行数和列数的数组 sz。
stg=I;
k=1;
i=1;
for rto=0.1:0.01:1
    % 对每个截取比例进行以下操作：  （截取比例为从10%到100%）
    row=round(sz(1)*rto);
    % 计算截取的行数，为 sz(1) 乘以 rto 的四舍五入整数值。
    col=round(sz(2)*rto);
    % 计算截取的列数，为 sz(2) 乘以 rto 的四舍五入整数值。
    p(k,i)=StgPrb(stg(1:row,1:col));
    % 调用函数 StgPrb，计算 stg 矩阵的前 row 行和前 col 列中的隐写概率，将概率值保存到 p 数组中的第 k 行、第 i 列。
    % StgPrb 是一个 MATLAB 函数，用于计算指定矩阵中的隐写概率。
    i=i+1;
    % 将 i 的值加 1。
end
% 循环结束。
