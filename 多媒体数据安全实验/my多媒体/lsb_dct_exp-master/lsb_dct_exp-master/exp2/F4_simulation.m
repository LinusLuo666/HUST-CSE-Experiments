function [ncAC]=JSteg_simulation(COVER,STEGO,message)

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

ncAC=numel(AC_Location);	% �õ���0��ACϵ������

messageLen=length(message);

%��Ϣ����
if(messageLen>ncAC)
	error('ERROR (too long message)');
end

i_DCT=1;
i_MSG=1;
while i_MSG<=messageLen
    if(i_DCT>ncAC) % û�и���ɹ�ע�����ĵ�ACϵ��
        fprintf('Max messageLength is %d.\n', i_MSG-1);
        error('ERROR (too long message)');
    end
    DCTInfo=DCT(AC_Location(i_DCT));
    if(DCTInfo>0)
        if(mod(DCTInfo,2)) % ������
            DCT(AC_Location(i_DCT))=DCTInfo+message(i_MSG)-1;
        else % ��ż��
            DCT(AC_Location(i_DCT))=DCTInfo-message(i_MSG);
        end
    else
        if(mod(DCTInfo,2)) % ������
            DCT(AC_Location(i_DCT))=DCTInfo+message(i_MSG);
        else % ��ż��
            DCT(AC_Location(i_DCT))=DCTInfo-message(i_MSG)+1;
        end
    end
    if(DCT(AC_Location(i_DCT))==0) % ���Ƕ�����0������������Ƕ��
        i_MSG=i_MSG-1; 
    end
    i_DCT=i_DCT+1;
    i_MSG=i_MSG+1;
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
