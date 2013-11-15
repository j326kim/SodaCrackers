%function for creating global stiffness matrix with the 2 given nodes
%with their attributes
%Rotation C = cosine(angle), S = sine(angle)
function [G_K, local] = CreateKGlobal(Global,C,S,E,L,A,I,Node1,Node2)

        %Taken off from formula
        local=[(A*C^2*E)/L+(12*E*I*S^2)/L^3 (A*C*E*S)/L-(12*C*E*I*S)/L^3 ...
           -(6*E*I*S)/L^2 -(A*C^2*E)/L-(12*E*I*S^2)/L^3 (12*C*E*I*S)/L^3-(A*C*E*S)/L ...
           -(6*E*I*S)/L^2;(A*C*E*S)/L-(12*C*E*I*S)/L^3 (12*C^2*E*I)/L^3+(A*E*S^2)/L ...
           (6*C*E*I)/L^2 (12*C*E*I*S)/L^3-(A*C*E*S)/L -(12*C^2*E*I)/L^3-(A*E*S^2)/L ...
           (6*C*E*I)/L^2;-(6*E*I*S)/L^2 (6*C*E*I)/L^2 (4*E*I)/L (6*E*I*S)/L^2 ...
           -(6*C*E*I)/L^2 (2*E*I)/L; -(A*C^2*E)/L-(12*E*I*S^2)/L^3 (12*C*E*I*S)/L^3-(A*C*E*S)/L ...
           (6*E*I*S)/L^2 (A*C^2*E)/L+(12*E*I*S^2)/L^3 (A*C*E*S)/L-(12*C*E*I*S)/L^3 ...
           (6*E*I*S)/L^2;(12*C*E*I*S)/L^3-(A*C*E*S)/L -(12*C^2*E*I)/L^3-(A*E*S^2)/L ...
           -(6*C*E*I)/L^2 (A*C*E*S)/L-(12*C*E*I*S)/L^3 (12*C^2*E*I)/L^3+(A*E*S^2)/L ...
           -(6*C*E*I)/L^2;-(6*E*I*S)/L^2 (6*C*E*I)/L^2 (2*E*I)/L (6*E*I*S)/L^2 ...
           -(6*C*E*I)/L^2 (4*E*I)/L];

        %take local matrix and insert 
        Node1=Node1*3-2; 
        Node2=Node2*3-2;
        Global(Node1:Node1+2,Node1:Node1+2)= Global(Node1:Node1+2,Node1:Node1+2)+local(1:3,1:3);
        Global(Node2:Node2+2,Node2:Node2+2)= Global(Node2:Node2+2,Node2:Node2+2)+local(4:6,4:6);
        Global(Node1:Node1+2,Node2:Node2+2)= Global(Node1:Node1+2,Node2:Node2+2)+local(1:3,4:6);
        Global(Node2:Node2+2,Node1:Node1+2)= Global(Node2:Node2+2,Node1:Node1+2)+local(4:6,1:3);
        G_K=Global;

end


%         local = [A*E/L 0 0 -A*E/L 0 0;
%                  0 12*E*I/L^3 6*E*I/L^2 0 -12*E*I/L^3 6*E*I/L^2;
%                  0 6*E*I/L^2 4*E*I/L 0 -6*E*I/L^2 2*E*I/L;
%                  -A*E/L 0 0 A*E/L 0 0;
%                  0 -12*E*I/L^3 -6*E*I/L^2 0 12*E*I/L^3 -6*E*I/L^2;
%                  0 6*E*I/L^2 2*E*I/L 0 -6*E*I/L^2 4*E*I/L;];
% 
%           localchris = T'*local*T;
%           
%         T = [C S 0  0 0 0;
%             -S C 0  0 0 0;
%              0 0 1  0 0 0;
%              0 0 0  C S 0;
%              0 0 0 -S C 0;
%              0 0 0  0 0 1;];

