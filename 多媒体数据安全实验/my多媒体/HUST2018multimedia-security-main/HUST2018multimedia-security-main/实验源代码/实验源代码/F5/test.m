%%% setup
COVER = 'cover.jpg'; % cover image (grayscale JPEG image)
STEGO = 'stego.jpg'; % resulting stego image that will be created
ALPHA = 0.10; % relative payload in terms of bits per nonzero AC DCT coefficient相对有效载荷，以非零AC DCT系数的比特数表示
SEED = 99; % PRNG seed for the random walk over the coefficients
wen.txt_id=fopen('hide.txt','r');
[message,L]=fread(wen.txt_id,'ubit1');
frr=fopen('f5dec.txt','a');
%message=randi([0,1],1,100);
%fprintf("%s",'U201812058');
%for i =1:80
    %fwrite(frr,message(i,1),'ubit1');
%end
save('message','message');
tic;
[nzAC] = nsf5_simulation(COVER,STEGO,SEED,message);
T = toc;

fprintf('-----\n');
fprintf('nsF5 simulation finished\n');
fprintf('cover image: %s\n',COVER);
fprintf('stego image: %s\n',STEGO);
fprintf('PRNG seed: %i\n',SEED);

fprintf('number of nzACs in cover: %i\n',nzAC);

fprintf('elapsed time: %.4f seconds\n',T);
function [AC]=nsf5_simulation(COVER,STEGO,SEED,message)
try
    jobj = jpeg_read(COVER); % JPEG image structure
    dct = jobj.coef_arrays{1}; % DCT plane
    dct1 = jobj.coef_arrays{1};
catch
    error('ERROR (problem with the cover image)');
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));
if(length(message)>AC)
    error('ERROR(too long message)');
end
changeable=true(size(dct));
changeable(1:8:end,1:8:end)=false;
changeable=find(changeable);%记录非0 系数的索引
rand('state',SEED);%根据密钥种子产生伪随机数重排列量化DCT系数
changeable=changeable(randperm(AC));%随机化AC序列
idD=1;
len=length(message);
for id =1:len
    while(abs(dct(changeable(idD)))<=1)%不考虑DC系数和值为0的AC系数。<=1的目的就是-1，1处理后会变成0，嵌入无效
        dct(changeable(idD))=0;
        idD=idD+1;
        if(idD>=AC)
            break;
        end
    end
    if(message(id,1)~=mod(dct(changeable(idD)),2))%根据矩阵编码计算是否需要修改DCT系数，实际上并没有进行矩阵编码在nsF5里
        dct(changeable(idD))=dct(changeable(idD))-sign(dct(changeable(idD)));%sign函数是符号函数
    end
    idD=idD+1;
end
try 
    jobj.coef_arrays{1}=dct;
    jobj.optimize_coding=1;
    jpeg_write(jobj,STEGO);
catch
    error('ERROR (problem with saving the stego image)')
end
subplot(2,2,1);
imshow(COVER);
title('initial image');
subplot(2,2,2);
imshow(STEGO);
title('after image');
subplot(2,2,3);
hist(dct1);
title('histogram of initial image');
subplot(2,2,4);
hist(dct);
title('histogram of after image');
function res = invH(y)
% inverse of the binary entropy function
to_minimize = @(x) (H(x)-y)^2;
res = fminbnd(to_minimize,eps,0.5-eps);
end
function res = H(x)
% binary entropy function
res = -x*log2(x)-(1-x)*log2(1-x);
end
end

        
