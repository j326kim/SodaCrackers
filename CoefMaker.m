% E = xlsread('InputFile', 1, 'B2');
G_K = zeros(3*(length(xfinal)+1));
G_C = zeros(3*(length(xfinal)+1));
G_M = zeros(3*(length(xfinal)+1));
KeffMatrices = zeros(6, 6,length(xfinal)); %KeffMatrises(:,:,i)

for i = 2:(length(xfinal))
    N1 = i-1;
    N2 = i;
    L = elementVec(i);
    A = w*thickness(i); 
    Angle = angles(i);
    I = w*thickness(i)^3/12; 
        
    [G_K, KeffMatrices(:,:,i)] = MatInsert(G_K,Angle,E,L,A,I,N1,N2);
   % G_C = dampInsert(G_C,Angle,L,A,N1,N2);
    G_M = DistributedMassMatrixMaker(G_M,Angle,N1,N2,p,A,L);
    
%     if (G_C~=G_C.')
%         pause
%     end
%     if(G_K~=G_K.')
%         pause
%     end
%     if(G_M~=G_M.')
%         pause
%     end
end





