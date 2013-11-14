function [G_K,G_C,G_M,G_U,G_Ud,G_Udd,G_F] = Sparse(G_K,G_C,G_M,G_U,G_Ud,G_Udd,G_F,Nodes,flag)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if flag==0
        for i=1:length(Nodes)
            G_K( Nodes(i),:)=[]; %remove row
            G_K(:,Nodes(i))=[]; %remove column
            G_C( Nodes(i),:)=[]; %remove row
            G_C(:,Nodes(i))=[]; %remove column
            G_M( Nodes(i),:)=[]; %remove row
            G_M(:,Nodes(i))=[]; %remove column
            G_F(Nodes(i),:)=[];
            G_U(Nodes(i),:)=[];
            G_Ud(Nodes(i),:)=[];
            G_Udd(Nodes(i),:)=[];
        end
    else
        for i=1:length(Nodes)
            G_K( Nodes(i),:)=[]; %remove row
            G_K(:,Nodes(i))=[]; %remove column
            G_C( Nodes(i),:)=[]; %remove row
            G_C(:,Nodes(i))=[]; %remove column
            G_M( Nodes(i),:)=[]; %remove row
            G_M(:,Nodes(i))=[]; %remove column
        end
    end
end

