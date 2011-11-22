function llr = LTE_Soft_QAM_Demodulation(y,LTE_link_params)
%此函数用来对输入的I，Q两路接收信号进行软解调,
%llr输出为各个比特的对数似然比的相对值，最后的绝对值乘以2/
%y_i,y_q为接收信号的I，Q两路分量，都是实数
%len 表示输入信号的长度
%mod为调制方式，1 for QPSK, 2 for 16QAM ,3 for 64 QAM
len = length(y);
y_q = imag(y);
y_i = real(y);

modulation_order = LTE_link_params.MCS_params.modulation_order;
num_bits_per_symbol = modulation_order/2;

switch modulation_order
    case 2
        llr(1:2:len*2)=-y_i*sqrt(2);
        llr(2:2:len*2)=-y_q*sqrt(2); 
    case 4
        bit_per_sy=4;
        const1=sqrt(10);
        y_i=y_i*const1;
        y_q=y_q*const1;
        
        %下面是第一个比特
        index1=find(y_i>2);
        llr(index1*bit_per_sy-3)=2-2*y_i(index1);
        index2=find(y_i<-2);
        llr(index2*bit_per_sy-3)=-2-2*y_i(index2);
        index3=setdiff(setdiff(1:len,index1),index2);
        llr(index3*bit_per_sy-3)=-y_i(index3);
        %下面是第二个比特
        index1=find(y_q>2);
        llr(index1*bit_per_sy-2)=2-2*y_q(index1);
        index2=find(y_q<-2);
        llr(index2*bit_per_sy-2)=-2-2*y_q(index2);
        index3=setdiff(setdiff(1:len,index1),index2);
        llr(index3*bit_per_sy-2)=-y_q(index3);
        %下面是第三、四个比特的判断
        llr(3:bit_per_sy:len*bit_per_sy)=abs(y_i)-2;
        llr(4:bit_per_sy:len*bit_per_sy)=abs(y_q)-2;
        
    case 6
        bit_per_sy=6;
        const1=sqrt(42);
        y_i=y_i*const1;
        y_q=y_q*const1;
        %下面是第1个比特
        index1=find(y_i>6);
        llr(index1*bit_per_sy-5)=12-4*y_i(index1);
        index2=find(y_i<-6);
        llr(index2*bit_per_sy-5)=-12-4*y_i(index2);
        index3=find(and(y_i<=6,y_i>4));
        llr(index3*bit_per_sy-5)=6-3*y_i(index3);
        index4=find(and(y_i<=4,y_i>2));
        llr(index4*bit_per_sy-5)=2-2*y_i(index4);
        index5=find(and(y_i>=-6,y_i<-4));
        llr(index5*bit_per_sy-5)=-6-3*y_i(index5);
        index6=find(and(y_i>=-4,y_i<-2));
        llr(index6*bit_per_sy-5)=-2-2*y_i(index6);
        index7=find(abs(y_i)<=2);
        llr(index7*bit_per_sy-5)=-y_i(index7);
        %下面是第二个比特
        index1=find(y_q>6);
        llr(index1*bit_per_sy-4)=12-4*y_q(index1);
        index2=find(y_q<-6);
        llr(index2*bit_per_sy-4)=-12-4*y_q(index2);
        index3=find(and(y_q<=6,y_q>4));
        llr(index3*bit_per_sy-4)=6-3*y_q(index3);
        index4=find(and(y_q<=4,y_q>2));
        llr(index4*bit_per_sy-4)=2-2*y_q(index4);
        index5=find(and(y_q>=-6,y_q<-4));
        llr(index5*bit_per_sy-4)=-6-3*y_q(index5);
        index6=find(and(y_q>=-4,y_q<-2));
        llr(index6*bit_per_sy-4)=-2-2*y_q(index6);
        index7=find(abs(y_q)<=2);
        llr(index7*bit_per_sy-4)=-y_q(index7);           
            
        %下面是第三个比特       
        index1=find(abs(y_i)>6);
        llr(index1*bit_per_sy-3)=2*abs(y_i(index1))-10;
        index2=find(abs(y_i)<=2);
        llr(index2*bit_per_sy-3)=2*abs(y_i(index2))-6;
        index3=setdiff(setdiff(1:len,index1),index2);
        llr(index3*bit_per_sy-3)=abs(y_i(index3))-4;

        %下面是第四个比特
        index1=find(abs(y_q)>6);
        llr(index1*bit_per_sy-2)=2*abs(y_q(index1))-10;
        index2=find(abs(y_q)<=2);
        llr(index2*bit_per_sy-2)=2*abs(y_q(index2))-6;
        index3=setdiff(setdiff(1:len,index1),index2);
        llr(index3*bit_per_sy-2)=abs(y_q(index3))-4;

        %下面是第五个比特
        index1=find(abs(y_i)>4);
        llr(index1*bit_per_sy-1)=abs(y_i(index1))-6;
        index2=setdiff(1:len,index1);
        llr(index2*bit_per_sy-1)=-abs(y_i(index2))+2;
        %下面是第六个比特
        index1=find(abs(y_q)>4);
        llr(index1*bit_per_sy)=abs(y_q(index1))-6;
        index2=setdiff(1:len,index1);
        llr(index2*bit_per_sy)=-abs(y_q(index2))+2;
    otherwise
        disp('demodulation mod is not correct');
end %end switch

 [x,y,llr]=L_Quantization_RandI_p(llr,1,0,31,32);
            
            
            
                
            
            
                
