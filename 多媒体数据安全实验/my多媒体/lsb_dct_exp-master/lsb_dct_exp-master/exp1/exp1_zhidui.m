I=imread('cover.bmp');
O=imread('stego1.bmp');
I=I(1:200000);
O=O(1:200000);
%subplot(121);
x=100;
histogram(I, 0:1:x);
set(gca, 'xtick', 0:2:x); % 横坐标每隔2显示刻度
grid on;
hold on;
%subplot(122);
histogram(O, 0:1:x);
set(gca, 'xtick', 0:2:x); % 横坐标每隔2显示刻度
grid on;