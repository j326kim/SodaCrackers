function [ broken ] = IsBroken( Keff, U, angles, length, thickness, width, maxtension, maxcompression)
    %string_a(2) %%angle from node 2 to 1
    %length is number of nodes on bow
    %U is global displacement
    flocal = zeros((length-1)*3,1);

    for i = 1:3:(length-1)*3
%         Keff(:,:,i) = Keff;

        T = [cos(angles((i-1)/3+2)) sin(angles((i-1)/3+2)) 0 0 0 0; ...
            -sin(angles((i-1)/3+2)) cos(angles((i-1)/3+2)) 0 0 0 0; ...
            0 0 1 0 0 0; ...
            0 0 0 cos(angles((i-1)/3+2)) sin(angles((i-1)/3+2)) 0; ...
            0 0 0 -sin(angles((i-1)/3+2)) cos(angles((i-1)/3+2)) 0; ...
            0 0 0 0 0 1]; 
        for j =1:6
           
            flocal(i:i+5) = T*Keff(:,:,(i-1)/3+1)*U(i:i+5);
        end
    end
    
    
    %stress along axis
    sigma = zeros(length-1);
    %assume constant per element, avoid unnecessary use of poissons ratio
    area  = thickness * 0.0508; 
    for i = 1:(length-1)
        sigma(i) = flocal(1+3*(i-1)) ./ area(i);
    end
    
    %all axial stresses in tension, set positive
    for i = 1:(length-1)
        if sigma(i) < 0
            sigma(i) = - sigma(i);
        end
    end   

    %moments
    sigma = zeros(length-1);
    %assume constant per element, avoid unnecessary use of poissons ratio
    area  = thickness * 0.0508; 
    for i = 1:(length-1)
        sigma(i) = flocal(1+3*(i-1)) ./ area(i);
    end    
    
    %principle stresses
    Y = zeros(length-1);
    I = zeros(length-1);
    Y = thickness ./ 2; %distance from neutral axis
    I = (1/12).*(thickness.^3).*width;
    
    %check m1 = m2-------------------------------------------------
    %just to be safe, set all moments positive
    for i = 1:(length-1)
        if flocal(3*i) < 0
            flocal(3*i) = -flocal(3*i);
        end
    end       
       
    sigmamax = zeros(length-1);
    
    for i = 1:(length-1)
        sigmamax(i) = sigma(i) + flocal(6*i)*Y(i)/I(i);
        if sigmamax> maxtension
            broken = 1;
        end
    end
    
    sigmamin = zeros(length-1);
    
    for i = 1:(length-1)
        sigmamin(i) = sigma(i) - flocal(6*i)*Y(i)/I(i);
        if sigmamin < -maxcompression
            broken = 1;
        end
    end
    