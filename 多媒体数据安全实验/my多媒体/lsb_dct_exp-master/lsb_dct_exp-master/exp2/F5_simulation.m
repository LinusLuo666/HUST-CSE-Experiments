function [ncAC]=F5_simulation(COVER,STEGO,message)

try
	jobj=jpeg_read(COVER);	%��ȡcoverͼƬ
	PrimeDCT=jobj.coef_arrays{1};%��ȡDCTϵ��
    DCT=PrimeDCT;
catch
	error('ERROR (problem with the cover image)');
end

AC_Location=DCT; % ����DCT
AC_Location(1:8:end,1:8:end)=false; % ��DCϵ����0
AC_Location=find(AC_Location);	%�ҳ�DCT�в�ΪDCϵ������Ϊ0��λ��

ncAC=numel(AC_Location);	% �õ�ACϵ������

messageLen=length(message); % �õ����ĵ�����

%��Ϣ����
if(messageLen/2>ncAC/3)
	error('ERROR (too long message)');
end

i_DCT=1;
i_MSG=1;

while i_MSG+1<=messageLen
    if(i_DCT+2>ncAC) % û�и���ɹ�ע�����ĵ�ACϵ��
        fprintf('Max messageLength is %d.\n', i_MSG-2);
        error('ERROR (too long message)');
    end
    DCTInfo=DCT(AC_Location(i_DCT:i_DCT+2));
    DCTInfo(DCTInfo<0)=DCTInfo(DCTInfo<0)+1; % �����и���+1���ı����λ
    xor1=bitxor(mod(DCTInfo(1),2),mod(DCTInfo(2),2)); % a1��λ���a2
    xor2=bitxor(mod(DCTInfo(2),2),mod(DCTInfo(3),2)); % a2��λ���a3
    tobe_change=i_DCT;
    if(message(i_MSG)==xor1) % �ж����ֵ��ȷ���޸�λ
        if(message(i_MSG+1)==xor2)
            tobe_change=-1;
        else
            tobe_change=tobe_change+2;
        end
    else
        if(message(i_MSG+1)~=xor2)
            tobe_change=tobe_change+1;
        end 
    end
    if(tobe_change~=-1) % ��Ҫ�޸�
        if(DCT(AC_Location(tobe_change))>0) % ������1
            DCT(AC_Location(tobe_change))=DCT(AC_Location(tobe_change))-1;
        else % ������1
            DCT(AC_Location(tobe_change))=DCT(AC_Location(tobe_change))+1;
        end
        if(DCT(AC_Location(tobe_change))==0) % ���Ƕ�����0������λ��������Ƕ��
            i_MSG=i_MSG-2; 
            AC_Location(tobe_change)=[]; % ɾ����һλ��
            ncAC=ncAC-1;
            i_DCT=i_DCT-3; % ����δ���޸ĵ�ACϵ��
        end
    end
    i_DCT=i_DCT+3;
    i_MSG=i_MSG+2; % forѭ����ѭ�������ı䲻��Ч
end

%%% save the resulting stego image
try
    jobj.coef_arrays{1} = DCT;
    jobj.optimize_coding = 1;
    jpeg_write(jobj,STEGO);
catch
    error('ERROR (problem with saving the stego image)');
end

%��ʾͼ��
subplot(2,2,1);imshow(COVER);
title('δǶ����Ϣ��ͼ��');

subplot(2,2,2);histogram(PrimeDCT);axis([-10,10,0,2*1e4]);
title('Ƕ��ǰ��ͼ��DCTϵ��ֱ��ͼ');

subplot(2,2,3);imshow(STEGO);
title('Ƕ����Ϣ��ͼ��');

subplot(2,2,4);histogram(DCT);axis([-10,10,0,2*1e4]);
title('Ƕ����ͼ��DCTϵ��ֱ��ͼ');
