%A - square matrix
%B - Output matrix
%iteration - number to times to iterate
% function result = seidelSolver(MassMat,stiffnessMat,DampingMat ...
%         ,U0,U1,dt,B)
function result = seidelSolver(A,U1,B)

    loopVector = U1;
%     G1 = ( stiffnessMat - 2 * MassMat / (dt^2) ) * U1;
%     G2 = ( MassMat / (dt^2) - DampingMat / (2*dt) ) * U0;
%     A = MassMat / (dt^2) + DampingMat / (2*dt);
    
    iterationVector = loopVector; % Copy of loop vector (for convergence)
    counter = 0;
    while(true) % More iteration = better approximation
        
        for j=1:1:length(A) % Number of rows or columns of square A matrix             
            
            sumInEachRow = 0;
            for k=1:1:length(loopVector) %Loop through number of columns
                if (k ~= j)
                   %Calculate row sum when known values are subbed in
                   sumInEachRow = sumInEachRow + A(j,k) * loopVector(k,1);
                end
            end
            loopVector(j,1) = (B(j,1) - sumInEachRow)/A(j,j);
        end
        %Convergence Test (Only to see if it is diverging or not
        %for each iteration
        maximumError = -99999999;
        %Compare previous iteration vector with current iteration vector
        for d=1:1:length(iterationVector)
            error = (( loopVector(d,1) - iterationVector(d,1) ) ...
                / loopVector(d,1)) * 100;
            if (isnan(error))
                continue;
            elseif (error > maximumError)
                maximumError = error;
            end
        end
        counter = counter + 1;
        if (maximumError < 0)
            fprintf('Max Error for iteration %i: Diverging\n', counter);
            iterationVector = loopVector;
        else
           fprintf('Max Error for iteration %i: %f\n', counter, maximumError);
           if (abs(maximumError) < 0.001 && mod(counter,length(U1))==0) %change the value here to adjust precision
                break; %break out of while loop
           else
               %Make current copy, the previous copy vector
               iterationVector = loopVector; 
           end
        end
    end
    %transfer loopVector to result then return output of the function
    result = loopVector; % <-- U(i+1)
end
