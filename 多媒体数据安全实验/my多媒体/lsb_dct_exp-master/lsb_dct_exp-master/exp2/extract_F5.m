% ������ȡ�㷨ʱ����Ҫ������JSteg_extract�滻����������
% ���޸��㷨����name��Ƕ����Ϣ����messageLen�ȱ���
STEGO='stego.jpg';
name='F5';
messageLen=32700;

tic;
messageHiden=F5_extract(STEGO,messageLen);
T=toc;

save('messageHiden','messageHiden','-ascii'); %������ȡ������������Ϣ

fprintf('-----------------------------------\n');
fprintf('%s extract finished\n', name);
fprintf('elapsed time: %.4f seconds\n',T);
fprintf('-----------------------------------\n');
