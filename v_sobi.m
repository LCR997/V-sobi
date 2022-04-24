function main_vmd(x,y,nt1,alpha,K)
[u]=VMD(y,alpha,0,K,0,1,1e-6);
% Nstd = 0.2;                % 正负高斯白噪声标准表
% NR = 100;                  % 加入噪声的次数
% MaxIter = 500;   
% SNRFlag = 2;
%[imf, its]=iceemdan(y,Nstd,NR,MaxIter,SNRFlag);
%[imf, its]=ceemdan(y,Nstd,NR,MaxIter);
fs=5000;
t=(0:1/fs:(2-1/fs))';
N=length(t);
figure;
plot(y);
figure;
for i=1:K
    subplot(K,1,i);plot(u(i,:));ylabel(['IMF',num2str(i)]);
end
% figure;
% for j = 1:9
%     [f,A] = PinPu(u(j,:),fs);
%     subplot(9,1,j);plot(f,A);xlabel('frequency/Hz');ylabel('Amplitude/mV');
% end
%figure;
%Y=u(1,:);
% +u(10,:)+u(11,:)+u(12,:)+u(13,:)+u(14,:)
%Y=imf(5,:)+imf(6,:)+imf(7,:)+imf(8,:)+imf(9,:)+imf(10,:);+X(3,:)+X(4,:)+X(5,:)+X(6,:)+X(7,:)+X(8,:)+X(9,:)+X(10,:)
%plot(Y);
[S,H]=sobi(u);
for l =1:K
    FuzEn(l) = FuzzyEntropy(H(l,:),1,0.2 * std(H(l,:)),2,1);
    CC(l)=corr(H(l,:)',1.2*nt1,'type','Pearson');   % 相关系数
end
r=FuzEn+abs(CC);%模糊熵和相关系数综合
disp(r);
R=find(r>0.3);%通过阈值挑出伪迹成分
% % [Z,W]=FastICA1(u);
H([R],:)=0;

X=S*H;

Y=sum(X);
figure;
plot(Y);xlabel('Sampling point');ylabel('Amplitude/μV');title('denoised signal');axis([0 5000,-50,50])
% %disp(Y);
% % FastICA(u);
% %[A,W]=fastica2(u);
% % X=A*u;
% %figure;
multiPlot('H',H);
multiPlot('x',X);
%disp(Y')
%% 降噪指标
SNR1(x,y);
SNR1(x,Y');

%均方根误差
RMSE1=sqrt((sum((Y'-x).^2))/N);
RMSE2=sqrt((sum(x.^2))/N);
RRMSE=RMSE1/RMSE2;
disp(RRMSE);
CC1=corr(Y',x,'type','Pearson');   % 相关系数
disp(CC1);


