%function for creating mass damping matrix with the 2 given nodes
%with their attributes (Uses distributed mass)
function [ G_M ] = CreateMGlobal(G_M,C,S,Node1,Node2,density,A,L)
        
        %Rotation C = cosine(angle), S = sine(angle)
%         T = [C S 0  0 0 0;
%             -S C 0  0 0 0;
%              0 0 1  0 0 0;
%              0 0 0  C S 0;
%              0 0 0 -S C 0;
%              0 0 0  0 0 1;];
%         
%         %Taken off from formula
%         local=[140      0      0  70     0      0;
%                  0    156   22*L   0    54  -13*L;
%                  0   22*L  4*L^2   0  13*L -3*L^2;
%                 70      0      0 140     0      0;
%                  0     54   13*L   0   156  -22*L;
%                  0  -13*L -3*L^2   0 -22*L  4*L^2;];
%         
%         %Combine everything together
%         local=(T.'*local*T*((density*A*L)/420));

local= [ 140*C^2 + 156*S^2,           -16*C*S, -22*L*S,   70*C^2 + 54*S^2,            16*C*S,  13*L*S; ...
                   -16*C*S, 156*C^2 + 140*S^2,  22*C*L,            16*C*S,   54*C^2 + 70*S^2, -13*C*L; ...
                   -22*L*S,            22*C*L,   4*L^2,           -13*L*S,            13*C*L,  -3*L^2; ... 
           70*C^2 + 54*S^2,            16*C*S, -13*L*S, 140*C^2 + 156*S^2,           -16*C*S,  22*L*S; ...
                    16*C*S,   54*C^2 + 70*S^2,  13*C*L,           -16*C*S, 156*C^2 + 140*S^2, -22*C*L; ...
                    13*L*S,           -13*C*L,  -3*L^2,            22*L*S,           -22*C*L,   4*L^2;];
        %take local matrix and insert 
        Node1=Node1*3-2; 
        Node2=Node2*3-2;
        G_M(Node1:Node1+2,Node1:Node1+2)= G_M(Node1:Node1+2,Node1:Node1+2)+local(1:3,1:3);
        G_M(Node2:Node2+2,Node2:Node2+2)= G_M(Node2:Node2+2,Node2:Node2+2)+local(4:6,4:6);
        G_M(Node1:Node1+2,Node2:Node2+2)= G_M(Node1:Node1+2,Node2:Node2+2)+local(1:3,4:6);
        G_M(Node2:Node2+2,Node1:Node1+2)= G_M(Node2:Node2+2,Node1:Node1+2)+local(4:6,1:3);
end
