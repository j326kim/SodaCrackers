function G_C = CreateCGlobal(Global,C,S,L,A,Node1,Node2)
    
    Cd = 1.18125 * L * A;
    if Node1 == length(Global)/3 || Node2 == length(Global)/3
        Cd = 0.387864561;
    end
    
    temp = Cd*[C^2 C*S 0;C*S S^2 0;0 0 1];    
    
    Node1=Node1*3-2;
    Node2=Node2*3-2;
    Global(Node1:Node1+3-1,Node1:Node1+3-1)= Global(Node1:Node1+3-1,Node1:Node1+3-1) + temp;
    Global(Node2:Node2+3-1,Node2:Node2+3-1)= Global(Node2:Node2+3-1,Node2:Node2+3-1) + temp;
    Global(Node2:Node2+3-1,Node1:Node1+3-1)= Global(Node2:Node2+3-1,Node1:Node1+3-1) - temp;
    Global(Node1:Node1+3-1,Node2:Node2+3-1)= Global(Node1:Node1+3-1,Node2:Node2+3-1) - temp;
    
    G_C = Global;
end

    %create local matrix
%    C=floor(cos(angle)*10^10)/10^10;
%    S=floor(sin(angle)*10^10)/10^10;