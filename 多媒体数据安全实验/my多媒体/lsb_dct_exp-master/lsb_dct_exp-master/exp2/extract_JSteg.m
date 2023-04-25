% 更改提取算法时，需要将下文JSteg_extract替换成其他函数
% 并修改算法名称name、嵌入信息长度messageLen等变量
STEGO='stego.jpg';
name='JSteg';
messageLen=28684;

tic;
messageHiden=JSteg_extract(STEGO,messageLen);
T=toc;

save('messageHiden','messageHiden','-ascii'); %保存提取出来的秘密信息

fprintf('-----------------------------------\n');
fprintf('%s extract finished\n', name);
fprintf('elapsed time: %.4f seconds\n',T);
fprintf('-----------------------------------\n');
