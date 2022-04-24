function K_P(alpha,EEG5,nt1)
%alpha=2000;
tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
%K =8;              % modes：分解的模态数
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7;         
%--------------- Run actual VMD code:数据进行vmd分解---------------------------

for K=3:10 %K值范围
%K=2+i;
[u,u_hat,omega] = VMD(EEG5+1.2*nt1, alpha, tau, K, DC, init, tol);
%A=zeros(8,8);
A(K,:)=[5000*omega(end,:),zeros(1,10-length(5000*omega(end,:)))];%不同K值下的中心频率


end
%A=[A;5000*omega(end,:)];
B=A(3:10,:);
C=[B(1,:)./B(2,:);B(2,:)./B(3,:);B(3,:)./B(4,:);B(4,:)./B(5,:);B(5,:)./B(6,:);B(6,:)./B(7,:);B(7,:)./B(8,:)];
D=sum(C>1.1,2);
E=find(D==min(D));
K=E+2;
main_vmd(EEG5,EEG5+1.2*nt1,nt1,alpha,K)
end