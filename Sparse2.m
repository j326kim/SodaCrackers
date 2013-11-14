function [G_K,G_C,G_M] = Sparse2(G_K,G_C,G_M,centre)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    G_K(:,23) = [];
    G_K(23,:) = [];
    G_C(:,23) = [];
    G_C(23,:) = [];
    G_M(:,23) = [];
    G_M(23,:) = [];

    for i = 0:2
        G_K=removerows(G_K,3*centre-i); %remove row
        G_K(:,3*centre-i)=[]; %remove column
        G_C=removerows(G_C,3*centre-i);
        G_C(:,3*centre-i)=[];
        G_M=removerows(G_M,3*centre-i);
        G_M(:,3*centre-i)=[];
    end
end

