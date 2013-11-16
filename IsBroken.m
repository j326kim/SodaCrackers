function [ broken ] = IsBroken( Keff, U, element, NN, maxtension, maxcompression,force)
    %string_a(2) %%angle from node 2 to 1
    %length is number of nodes on bow
    %U is global displacement
    flocal = zeros(((NN-2)/2)*3,1);
    C = 3;
    S = 4;
  broken = 0;
    %symmetry, only need to analyze half the bow
    for i = 1:NN/2-1
%         Keff(:,:,i) = Keff;

        T = [element(i,C) element(i,S) 0 0 0 0; ...
            -element(i,S) element(i,C) 0 0 0 0; ...
            0 0 1 0 0 0; ...
            0 0 0 element(i,C) element(i,S) 0; ...
            0 0 0 -element(i,S) element(i,C) 0; ...
            0 0 0 0 0 1]; 
        
            if i == NN/2-1
                U(NN/2*3-2:NN/2*3) = 0;
            end
            
            flocal(3*i-2:3*i+3) = T*Keff(:,:,i)*U(3*i-2:3*i+3);


    end
    
    
    %stress along axis
    sigma = zeros(NN/2,1);
    %assume constant per element, avoid unnecessary use of poissons ratio
    for i = 1:(NN/2)
        sigma(i) = flocal(i*3 - 2) ./ element(i,6);
    end
    
%     %all axial stresses in tension, set positive
%     for i = 1:(NN/2)
%         if sigma(i) < 0
%             sigma(i) = - sigma(i);
%         end
%     end   

    %moments
%included in sigmin and sigmax calculations   
    
    %principle stresses

    %just to be safe, set all moments positive
%     for i = 1:NN/2
%         if flocal(3*i) < 0
%             flocal(3*i) = -flocal(3*i);
%         end
%     end       
       
    sigmamax = zeros(NN/2,1);
    
    %Tension calculations
    for i = 1:NN/2
        sigmamax(i) = sigma(i) + ((flocal(3*i)+flocal(3*i-1)*element(i,7))*(element(i,9)/2))/element(i,10);
        if sigmamax(i)> maxtension
            broken = 1;
            force=1/4.44822162825*force;
            disp(['Tensile Failure in element ',num2str(i),' with a tensile stress of ',num2str(sigmamax(i)),'Pa'])
            disp(['Loading on string: ',num2str(force),'lbs']);
        end
    end
    
    sigmamin = zeros(NN/2,1);
    
    %compression calculations
    for i = 1:NN/2
        sigmamin(i) = sigma(i) - (flocal(3*i)+flocal(3*i-1)*element(i,7))*(element(i,9)/2)/element(i,10);
        if sigmamin(i) < -maxcompression
            broken = 1;
            force=1/4.44822162825*force;
            disp(['Compression Failure in element ',num2str(i),' with a compressive stress of ',num2str(sigmamin(i)),'Pa'])
            disp(['Loading on string: ',num2str(force),'lbs']);
        end
    end
    
  
    