cover='cover.jpg'; % ����ԭʼͼ���ļ���
stego='stegojsteg.jpg'; % ����������Ϣ���ͼ���ļ���

%disp("ok");
% ��ȡԭʼͼ���DCTϵ��
try 
%disp("ok");
    jobj=jpeg_read(cover); % ��ȡJPEGͼ���ļ�
%disp("ok");
    dct=jobj.coef_arrays{1}; % ��ȡDCTϵ��
%disp("ok");
    dct1=jobj.coef_arrays{1}; % ����DCTϵ��
%disp("ok");
catch
    error('Error(problem with the cover image)'); % ������ʾԭʼͼ���ļ�������
end

disp("ok");
% �����Ƕ����Ϣ��ACϵ������
insertable = dct ~= 0 & dct ~= 1; % ���˵�DCϵ����ֱ��ϵ��
%��һ���߼����飬���ڱ�ʾ dct �����в�����0��1��Ԫ�أ�������ACϵ����

insertable(1:8:end, 1:8:end) = false; % ���˵�Zigzagɨ���8x8��ĵ�һ��ϵ����DCϵ����
AC=sum(insertable(:)); % ͳ�ƿ�Ƕ����Ϣ��ACϵ������

% wen.txt_id=fopen('hide.txt','r');%���ص���Ϣ
% [msg,L]=fread(wen.txt_id,'ubit1');
% if(length(msg)>AC)
%     error('ERROR(too long message)');
% end
% ����Ƕ�����Ϣ��ʵ��Ӧ�ô��ı��ļ��ж�ȡ���˴�����������棩
msg=round(rand(AC,1)); % ��������Ķ�������Ϣ

% ����ϢǶ��DCTϵ��
len=length(msg); % Ƕ����Ϣ����
id=1; % ��ǰǶ����Ϣ��λ��
[m,n]=size(dct); % DCTϵ���ĳߴ�
for f2 =1:n
    for f1 =1:m
        % �ж��Ƿ�ΪDCϵ����ֱ��ϵ��
        if(dct(f1,f2)==1 || dct(f1,f2) == 0)
            continue; % ����
        end
        % �ж��Ƿ�Ϊ����DCTϵ��
        if(dct(f1,f2)>1)%dctϵ������1
            odd=mod(dct(f1,f2),2);
            if(msg(id,1)==0 && odd==1)%Ƕ����ϢΪ0��ACϵ��Ϊ����
               dct(f1,f2)=dct(f1,f2)-1; % �޸�Ϊż��
            end
            if(msg(id,1)==1 && odd==0)%Ƕ����ϢΪ1��ACϵ��Ϊż��
               dct(f1,f2)=dct(f1,f2)+1; % �޸�Ϊ����
            end
        end
        % �ж��Ƿ�Ϊ����DCTϵ��
        if(dct(f1,f2)<0)%dctϵ��С��0
            odd=abs(mod(dct(f1,f2),2));
            if(msg(id,1)==0 && odd==1)%Ƕ����ϢΪ0��ACϵ��Ϊ����
               dct(f1,f2)=dct(f1,f2)-1; % �޸�Ϊż��
            end
            if(msg(id,1)==1 && odd==0)%Ƕ����ϢΪ1��ACϵ��Ϊż��
               dct(f1,f2)=dct(f1,f2)+1; % �޸�Ϊ����
            end
        end
        % �ж��Ƿ�Ƕ����������Ϣ
        if(id==len)
            break;
        end
        id=id+1;
    end
% �ж��Ƿ�Ƕ����������Ϣ
    if id ==len
        break;
    end
end

% ��Ƕ����Ϣ���DCTϵ������д��JPEGͼ���ļ�
try
    jobj.coef_arrays{1}=dct; % ����DCTϵ��
    jobj.optimize_coding=1; % �Ż�����
    jpeg_write(jobj,stego); % д��JPEGͼ���ļ�
catch
    error('ERROR (problem with saving the stego image)') % ������ʾд��ͼ���ļ�������
end

% ����ͼ���DCTϵ��ֱ��ͼ
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
% �˶δ���ʵ����һ���򵥵�LSB��д������ϢǶ����̡�����һ��ԭʼͼ���ļ�����ȡ
% ���е�DCTϵ�����������Ƕ����Ϣ��ACϵ�������������������������Ϣ�󣬽���
% Ƕ�뵽DCTϵ�������λ��Ƕ��ʱ������ÿ��ACϵ�����ж����Ƿ�Ϊ����������
% ���ж�Ƕ�����Ϣ��0����1���Ӷ��޸�DCTϵ������ż�ԡ�Ƕ����ɺ�
% ���޸ĺ��DCTϵ������д�뵽һ��JPEGͼ���ļ��У������Ϣ���ء����
% ����ԭʼͼ������غ��ͼ���DCTϵ��ֱ��ͼ���ԱȽ����ǵĲ��졣
