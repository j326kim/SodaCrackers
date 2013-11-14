%function for creating global damping matrix with the 2 given nodes
%with their attributes
function G_C = CreateCGlobal(Global,C,S,L,A,Node1,Node2)
    
    Cconstant = 1.18125 * L * A; %damping Constant for wooden bow
    if Node1 == length(Global)/3 || Node2 == length(Global)/3
        Cconstant = 0.387864561; %%damping Constant for string
    end
    
    %C = cosine(angle), S = sine(angle)
    local = Cconstant*[C^2 C*S 0;C*S S^2 0;0 0 1];    
    
    %take local matrix and insert 
    Node1=Node1*3-2;
    Node2=Node2*3-2;
    Global(Node1:Node1+3-1,Node1:Node1+3-1)= Global(Node1:Node1+3-1,Node1:Node1+3-1) + local;
    Global(Node2:Node2+3-1,Node2:Node2+3-1)= Global(Node2:Node2+3-1,Node2:Node2+3-1) + local;
    Global(Node2:Node2+3-1,Node1:Node1+3-1)= Global(Node2:Node2+3-1,Node1:Node1+3-1) - local;
    Global(Node1:Node1+3-1,Node2:Node2+3-1)= Global(Node1:Node1+3-1,Node2:Node2+3-1) - local;
    G_C = Global;
end
