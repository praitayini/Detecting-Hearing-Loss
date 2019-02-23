L=0.005;
T= 0:L:10;
figure(1)
plot(T,val(:,1:2001));
title('input signal, ABR Physionet')
xlabel('ms')
ylabel('amplitude')
n=50;
wn=[0.05 100]/1000;
[B A]= fir1(n,wn,'bandpass',hann(51));
h=freqz(B,A);
%m=20*log(abs(h));
figure(2)
y1=filter(B,A,val(:,1:2001));
plot(T,y1);
title('filtered signal');

% cwt & dwt
scales=linspace(10,250,128);
figure(3)
[coefs,sgram] = cwt(y1,scales,'mexh','scal'); %  returns continous wavelet transform % and plots the scalogram

line([935,935],[0,300],'color','k','linestyle','--');   
line([1000,1000],[0,300],'color','k','linestyle','--'); 
cwtcoff=coefs;

lev = 11;   %level 10
wave='db4';  %Haar wavelet
[C,L] = wavedec(val(:,1:2001), lev, wave);%to decompose a signal into discrete wavelet coefficients
dwtcoeff=C;

%instantaneous energy
x_env_diff=cal_freqweighted_energy(y1,1,'envelope_diff');
figure(5)
plot(T,x_env_diff);
title('Instantaneous Energy')
ylabel('amplitude');
xlabel('time(ms)');
line([5.7,5.7],[0,3*10^16],'color','k','linestyle','--'); 
%% LMS
N=2001;
desired=y1;
noise=randn(1,N);
primary=desired+noise;
order=2;
mu=0.01;
n=length(primary);
delayed=zeros(1,order);
adap=zeros(1,order);
cancelled=zeros(1,n);
 
 for k=1:n,
     delayed(1)=desired(k);
     y=delayed*adap';
     cancelled(k)=primary(k)-y;
     adap = adap + 2*mu*cancelled(k) .* delayed;
     delayed(2:order)=delayed(1:order-1);
 end
 
 figure(3);
 plot(T,cancelled);
 ylabel('cancelled');

%% lms

N=1024;
xn = randn(1,N);
fs=200;
L=256;
a=.25;
PX=mean(xn.^2);
delta=a * (1/(10*L*PX));
L=lms(xn,y1,delta,L);
figure(4);
plot(T,L);

%% cwt conti.
figure(3);
scales=linspace(5,400,10);
imagesc(T,scales.*0.0019,sgram(:,1:2001).^0.3); % plot the scalogram in time axis with gamma correction
set(gca,'ydir','normal') % to reverse the y-axis
line([5,5],[0,1],'color','k','linestyle','--'); % dashed line for scale a from problem 1
line([6,6],[0,1],'color','k','linestyle','--'); % dashed line for scale a from problem 1
xlabel('time,sec');
ylabel('scale a');
title('percentage of energy for each wavelet coefficient');
colorbar

