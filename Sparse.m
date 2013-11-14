function [G_K,G_C,G_M,G_U,G_Ud,G_Udd,G_F] = Sparse(G_K,G_C,G_M,G_U,G_Ud,G_Udd,G_F,centre)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    G_K(:,23) = [];
    G_K(23,:) = [];
    G_C(:,23) = [];
    G_C(23,:) = [];
    G_M(:,23) = [];
    G_M(23,:) = [];
    G_F(23) = [];
        G_U(23)=[];
        G_Ud(23)=[];
        G_Udd(23)=[];



    for i = 0:2
        G_K=removerows(G_K,3*centre-i); %remove row
        G_K(:,3*centre-i)=[]; %remove column
        G_C=removerows(G_C,3*centre-i);
        G_C(:,3*centre-i)=[];
        G_M=removerows(G_M,3*centre-i);
        G_M(:,3*centre-i)=[];
        G_F=removerows(G_F,3*centre-i);
        G_U=removerows(G_U,3*centre-i);
        G_Ud=removerows(G_Ud,3*centre-i);
        G_Udd=removerows(G_Udd,3*centre-i);
    end
end

