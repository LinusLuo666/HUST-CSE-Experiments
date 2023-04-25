% 更改嵌入算法时，需要将下文JSteg_simulation替换成其他函数
% 并修改算法名称name、嵌入信息长度messageLen等变量
COVER='cover.jpg';
STEGO='stego.jpg';
name='JSteg';
messageLen=28684;

message=randi([0 1],1,messageLen);%0000); %生成随机数，作为隐藏信息
save('message','message','-ascii'); %保存秘密信息

tic;
[nzAC]=JSteg_simulation(COVER,STEGO,message);
T=toc;

fprintf('-----------------------------------\n');
fprintf('%s simulation finished\n', name);
fprintf('cover image: %s\n',COVER);
fprintf('stego image: %s\n',STEGO);
fprintf('number of nzACs in cover: %i\n',nzAC);
fprintf('bits of message: %d\n',length(message));
fprintf('elapsed time: %.4f seconds\n',T);
fprintf('-----------------------------------\n');
