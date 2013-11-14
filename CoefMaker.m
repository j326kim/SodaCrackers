%Create global stiffness, damping, mass matrices with dimension:
G_K = zeros(3*NN);
G_C = zeros(3*NN);
G_M = zeros(3*NN);
KeffMatrices = zeros(6, 6, NN); %KeffMatrises(:,:,i)

for i=1:NN
    
    N1 = element(i,1);  %First Node
    N2 = element(i,2);  %Second Node
    C  = element(i,3);  %Cosine
    S  = element(i,4);  %Sine
    E  = element(i,5);  %Modulus of Elasticity
    A  = element(i,6);  %Cross Sectional Area
    L  = element(i,7);  %Length
    P  = element(i,8);  %Density
    Th = element(i,9);  %Thickness
    I  = element(i,10); %Inertia
    
    [G_K, KeffMatrices(:,:,i)] = MatInsert(G_K,C,S,E,L,A,I,N1,N2);
    G_M = DistributedMassMatrixMaker(G_M,C,S,N1,N2,P,A,L);
    G_C = dampInsert(G_C,C,S,L,A,N1,N2);
end
    



