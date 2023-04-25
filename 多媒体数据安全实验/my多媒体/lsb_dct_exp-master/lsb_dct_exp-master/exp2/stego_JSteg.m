% ����Ƕ���㷨ʱ����Ҫ������JSteg_simulation�滻����������
% ���޸��㷨����name��Ƕ����Ϣ����messageLen�ȱ���
COVER='cover.jpg';
STEGO='stego.jpg';
name='JSteg';
messageLen=28684;

message=randi([0 1],1,messageLen);%0000); %�������������Ϊ������Ϣ
save('message','message','-ascii'); %����������Ϣ

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
