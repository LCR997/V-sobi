tic
clc
clear all
fs=2500;%����Ƶ��
Ts=1/fs;%��������
L=5000;%��������
t=(0:L-1)*Ts;%ʱ������
STA=1; %������ʼλ��
%----------------��������-----------------------------------------
load('EEG5')
load('nt1')
load('EEG6')
load('nt2')
% %-------------------------------------------------------
% load('X121_DE_time.mat')
%--------- some sample parameters forVMD������VMD��Ʒ������������---------------
alpha=[1000:200:5000];
%     %alpha;        % moderate bandwidth constraint���ʶȵĴ���Լ��/�ͷ�����
%     %disp(alpha)
k=length(alpha);
for f=1:k  %�Ż�alphaֵ
alpha=1000+200*(f-1);
%alpha=7000;
tau = 0;          % noise-tolerance (no strict fidelity enforcement)���������ޣ�û���ϸ�ı����ִ�У�
K =6;              % modes���ֽ��ģ̬��
DC = 0;             % no DC part imposed����ֱ������
init = 1;           % initialize omegas uniformly  ��omegas�ľ��ȳ�ʼ��
tol = 1e-7;         
%--------------- Run actual VMD code:���ݽ���vmd�ֽ�---------------------------
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

b=find(a==min(a));%ѡȡ�����ֵ����Сֵ
alpha=1000+200*b;% ȷ��alphaֵ
K_P(alpha,EEG5,nt1);%�Ż�Kֵ





