function determinant = getDeterminant(Xorig,first,determinant)  
    if (first==1)
        determinant = 0;
        X=zeros(size(Xorig)+1);
        for k=2:1:size(X)
            X(1,k) = (-1)^k;
            X(k,1) = (-1)^k;
        end
        first=0;
        X(2:size(X),2:size(X))=Xorig;
    else
        X=Xorig;
    end
    smallerX=zeros(size(X));
   
    if (length(smallerX) > 3)
        for i=2:1:length(smallerX)
            smallerX = X;
            smallerX(2,:)=[];
            smallerX(:,i)=[];
            determinant = determinant + X(2,i)*X(1,i)* ...
                X(2,1)*getDeterminant(smallerX,first,determinant);
        end
    else
        smallerX = X;
        smallerX(1,:)=[];
        smallerX(:,1)=[];
        result = (smallerX(1,1) * smallerX(2,2)) ...
            - (smallerX(1,2) * smallerX(2,1));
        determinant = result
    end
end