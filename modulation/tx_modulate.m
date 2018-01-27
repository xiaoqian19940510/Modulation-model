function [mod_symbols,table, P] = tx_modulate(txdata_in, num_bits)
 
%**************************************************************************
%This program modulates the input binary data.The inputs are:
% bits_in -> the binary input bits
%modulation -> we choose one of 'BPSK','QPSK',8PSK',16QAM'
%The outputs are:
%mod_symbols -> modulated output
%table -> the complete set of symbols in a chosen constellation. This is
%required by the demodulator.
%P -> the number of points in a chosen constellation. This is required by
%the demodulator
%**************************************************************************
txdata_len = length(txdata_in);
switch (num_bits)
% *************************** BPSK modulation ***************************
   case 1
      % Angle [pi/4 -3*pi/4] corresponds to 
      % Gray code vector [0 1], respectively.
      table=exp(j*[0 -pi]);       % generates BPSK symbols
      table=table([1 0]+1);       % Gray code mapping pattern for BPSK symbols
      inp=txdata_in;
      mod_symbols=table(inp+1);   % maps transmitted bits into BPSK symbols
      P=2;                        % 2 constellation points
% *************************** QPSK modulation *************************
 
    case 2
       % Angle [pi/4 3*pi/4 -3*pi/4 -pi/4] corresponds to 
       % Gray code vector [00 10 11 01], respectively.
       table=exp(j*[-3/4*pi 3/4*pi 1/4*pi -1/4*pi]);   % generates QPSK symbols
       table=table([0 1 3 2]+1);                       % Gray code mapping pattern for QPSK symbols
       inp=reshape(txdata_in,2,txdata_len/2);
       mod_symbols=table([2 1]*inp+1);                 % maps transmitted bits into QPSK symbols
       P=4;                                            % 4 constellation points
    
% *************************** 8PSK modulation ************************* 
 
    case 3
       % generate constellations
       % Angle [0 pi/4 pi/2 3*pi/4 pi 5*pi/4 3*pi/2 7*pi/4] corresponds to 
       % Gray code vector [000 001 011 010 110 111 101 100], respectively.
       table=exp(j*[0 pi/4 pi/2 3*pi/4 pi 5*pi/4 3*pi/2 7*pi/4]);  % generates 8PSK symbols
       table=table([0 1 3 2 6 7 5 4]+1);                           % Gray code mapping pattern for 8PSK symbols
       inp=reshape(txdata_in,3,txdata_len/3);
       mod_symbols=table([4 2 1]*inp+1);                           % maps transmitted bits into 8PSK symbols
       P=8;                                                        %8 constellation points
    
% *************************** 16QAM modulation ************************* 
 
    case 4
       % generates 16QAM symbols
       m=1;
       for k=-3:2:3
           for l=-3:2:3
               table(m) = (k+j*l)/sqrt(10);                          % power normalization
               m=m+1;
           end;
       end;
       table=table([0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]+1);     % Gray code mapping pattern for 8-PSK symbols
       inp=reshape(txdata_in,4,txdata_len/4);
       mod_symbols=table([8 4 2 1]*inp+1);                         % maps transmitted bits into 16QAM symbols
       P=16;                                                       %16 constellation points
    
% *************************** 64QAM modulation *************************
 
    case 5
       % generates 64QAM symbols
       m=1;
       for k=-7:2:7
           for l=-7:2:7
               table(m) = (k+j*l)/sqrt(42);               % power normalization
               m=m+1;
           end;
       end;
       table=table([[ 0  1  3  2  7  6  4  5]...
                  8+[ 0  1  3  2  7  6  4  5]... 
                 24+[ 0  1  3  2  7  6  4  5]...
                 16+[ 0  1  3  2  7  6  4  5]...
                 56+[ 0  1  3  2  7  6  4  5]...
                 48+[ 0  1  3  2  7  6  4  5]...
                 32+[ 0  1  3  2  7  6  4  5]...
                40+[ 0  1  3  2  7  6  4  5]]+1);
      inp=reshape(txdata_in,6,txdata_len/6);
      mod_symbols=table([32 16 8 4 2 1]*inp+1);        % maps transmitted bits into 64QAM symbol
      P=64;                                                       %16 constellation points
   otherwise
     disp('Undefined modulation');
end
