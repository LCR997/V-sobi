function [H,S,D]=sobi(X,n,p),
% program  by  A. Belouchrani and A. Cichocki
%
% Second
% Order
% Blind
% Identification
% SOBI
%**************************************************
% blind identification by joint diagonalization   *
% of correlation  matrices.                       *
%                       			  *
% ------------------------------------------------*
% THIS CODE ASSUMES TEMPORALLY CORRELATED SIGNALS *
% in estimating the cumulants                     *
% ------------------------------------------------*
%
% [H,S]=SOBI(X,m,p) produces a matrix H of dimension [m by n] and a matrix S
% of dimension [n by N] wich are respectively an estimate of the mixture matrix and 
% an estimate of the source signals of the linear model from where the 
% observation matrix X of dimension [m by N] derive.
% Note: > m: sensor number.
%       > n: source number by default m=n.
%       > N: sample number.
%	> p: number of correlation matrices to be diagonalized by default p=4.
%
% REFERENCES:
% A. Belouchrani, K. Abed-Meraim, J.-F. Cardoso, and E. Moulines, ``Second-order
%  blind separation of temporally correlated sources,'' in Proc. Int. Conf. on
%  Digital Sig. Proc., (Cyprus), pp. 346--351, 1993.
%
% A. Belouchrani and K. Abed-Meraim, ``Separation aveugle au second ordre de
%  sources correlees,'' in  Proc. Gretsi, (Juan-les-pins), 
%  pp. 309--312, 1993.
%
%  A. Belouchrani, and A. Cichocki, 
%  Robust whitening procedure in blind source separation context, 
%  Electronics Letters, Vol. 36, No. 24, 2000, pp. 2050-2053.
%  
%  A. Cichocki and S. Amari, 
%  Adaptive Blind Signal and Image Processing, Wiley,  2002.


[m,N]=size(X);
if nargin==1,
 n=m; % source detection (hum...)

 p=4; % number of correlation matrices to be diagonalized 
 end;
if nargin==2,
 p=4 ; % number of correlation matrices to be diagonalized
end; 
pm=p*m; % for convenience
X=X-kron(mean(X')',ones(1,N)); % zero mean
%%%% whitening
% Rx=(X*X')/T;
% if m<n, %assumes white noise
%   [U,D]=eig(Rx); [puiss,k]=sort(diag(D));
%   ibl= sqrt(puiss(n-m+1:n)-mean(puiss(1:n-m)));
%    bl = ones(m,1) ./ ibl ;
%   BL=diag(bl)*U(1:n,k(n-m+1:n))';
%   IBL=U(1:n,k(n-m+1:n))*diag(ibl);
% else    %assumes no noise
%    IBL=sqrtm(Rx);
%    Q=inv(IBL);
% end;
% X=Q*X;
%prewitening based directly on SVD
[UU,S,VV]=svd(X',0);
Q= pinv(S)*VV';
X=Q*X;
%
%%%correlation matrices estimation
k=1;for u=1:m:pm, k=k+1; Rxp=X(:,k:N)*X(:,1:N-k+1)'/(N-k+1); 
    M(:,u:u+m-1)=norm(Rxp,'fro')*Rxp; end;
%%%joint diagonalization
epsil=1/sqrt(N)/100; encore=1; V=eye(m);
while encore, encore=0;
 for p=1:m-1,
  for q=p+1:m,
   %%% Givens rotations
   g=[   M(p,p:m:pm)-M(q,q:m:pm)  ;
         M(p,q:m:pm)+M(q,p:m:pm)  ;
      i*(M(q,p:m:pm)-M(p,q:m:pm)) ];
	  [vcp,D] = eig(real(g*g')); [la,K]=sort(diag(D));
   angles=vcp(:,K(3));angles=sign(angles(1))*angles;
   c=sqrt(0.5+angles(1)/2);
   sr=0.5*(angles(2)-j*angles(3))/c; sc=conj(sr);
   oui = abs(sr)>epsil ;
   encore=encore | oui ;
   if oui , %%%update of the M and V matrices 
    colp=M(:,p:m:pm);colq=M(:,q:m:pm);
    M(:,p:m:pm)=c*colp+sr*colq;M(:,q:m:pm)=c*colq-sc*colp;
    rowp=M(p,:);rowq=M(q,:);
    M(p,:)=c*rowp+sc*rowq;M(q,:)=c*rowq-sr*rowp;
    temp=V(:,p);
    V(:,p)=c*V(:,p)+sr*V(:,q);V(:,q)=c*V(:,q)-sc*temp;
   end%% if
  end%% q loop
 end%% p loop
end%% while
%%%estimation of the mixing matrix and source signals
Hf=pinv(Q)*V; %estimated mixing matrix
Sf=V'*X; %estimated sources

H = Hf(:,1:n);
S = Sf(1:n,:);
% figure;title('解混后的信号');
% for c=1:10
%     subplot(10,1,c);plot(Hf(:,c));ylabel(['IC',num2str(c)]);
% end
% figure;
% plot(S(3,:));
%x=pinv(Hf)*Sf;
%Y=pinv(Hf)*x;
%figure;
%plot(S(4,:)+S(5,:)+S(10,:)+S(11,:)+S(12,:)+S(13,:));
%+S(6,:)+S(7,:)+S(8,:)+S(9,:)+S(10,:)+S(11,:)+S(12,:)
% y=x(1,:)+x(2,:)+x(3,:)+x(4,:)+x(5,:)+x(6,:)+x(7,:)+x(8,:)+x(9,:)+x(10,:)+x(11,:)+x(12,:)+x(13,:)+x(14,:);
% plot(y);
% figure;
% for z=1:14
%     subplot(7,2,z);plot(x(z,:));xlabel('Time/ms');
% end