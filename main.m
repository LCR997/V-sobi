tic
clc
clear all
fs=2500;%采样频率
Ts=1/fs;%采样周期
L=5000;%采样点数
t=(0:L-1)*Ts;%时间序列
STA=1; %采样起始位置
%----------------导入数据-----------------------------------------
load('EEG5')
load('nt1')
load('EEG6')
load('nt2')
% %-------------------------------------------------------
% load('X121_DE_time.mat')
%--------- some sample parameters forVMD：对于VMD样品参数进行设置---------------
alpha=[1000:200:5000];
%     %alpha;        % moderate bandwidth constraint：适度的带宽约束/惩罚因子
%     %disp(alpha)
k=length(alpha);
for f=1:k  %优化alpha值
alpha=1000+200*(f-1);
%alpha=7000;
tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
K =6;              % modes：分解的模态数
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7;         
%--------------- Run actual VMD code:数据进行vmd分解---------------------------
[u, u_hat, omega] = VMD(EEG5+1.2*nt1, alpha, tau, K, DC, init, tol);
% 
for i =1:K
    %SE(i)=SampEn(u(i,:),2,0.2);
    %pe(i)=pec(u(i,:),3,1);
    %b=sum(u(i,:),2);
    KL(i) = K_L(EEG5+1.2*nt1,u(i,:));
    
end

a(f)=sum(KL,2);
%disp(HE)
% xx=[];
% 
end

b=find(a==min(a));%选取相对熵值中最小值
alpha=1000+200*b;% 确定alpha值
K_P(alpha,EEG5,nt1);%优化K值





