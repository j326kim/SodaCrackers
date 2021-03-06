function [ G_M, G_K, G_C, Keff] = CoefMaker( NN, element)

    %Create global stiffness, damping, mass matrices with dimension:
    G_K = zeros(3*NN);
    G_C = zeros(3*NN);
    G_M = zeros(3*NN);
    KeffTemp = zeros(6,6);
    Keff = zeros(6, 6, NN);

    for i=1:NN

        N1 = element(i,1);  %First Node
        N2 = element(i,2);  %Second Node
        C  = element(i,3);  %Cosine
        S  = element(i,4);  %Sine
        E  = element(i,5);  %Modulus of Elasticity
        A  = element(i,6);  %Cross Sectional Area
        L  = element(i,7);  %Length
        P  = element(i,8);  %Density
        I  = element(i,10); %Inertia

        %Create global stiffness matrix
        [G_K, KeffTemp] = CreateKGlobal(G_K,C,S,E,L,A,I,N1,N2);
        %Create global distributed mass matrix
        G_M = CreateMGlobal(G_M,C,S,N1,N2,P,A,L);
        %Create global damping Matrix
        G_C = CreateCGlobal(G_C,C,S,L,A,N1,N2);
        
        Keff(:,:,i) = KeffTemp;
        
        %symmetry check
        if  max(max(G_M-G_M')) ~= 0 || max(max(G_C-G_C')) ~= 0 || max(max(G_K-G_K')) ~= 0
            pause;
        end
    end
end

