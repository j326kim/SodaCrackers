clear all;
close all;
clc;

%for in newtons
F_Start = 0;
F_Step = 0.1;
F_End = 100;

%time step
dt = 0.00001;

%number of times through loop
count = 0;

%flaiure flag will be set to 1 when failure condition reached
failureFlag = 0;

%running flag will be set to one after the first iteration to avoid
%resparcing unnecessary sparcing
RunningFlag=0;

%wood properties
E =6894757290; %youngs Modulus of wood
p = 470; %Density (wood)
w = 0.04445; %Width of wood (Constant)

%string properties
stringMass = 0.0164427; % Mass of the string 
stringE = 2e11; %String modulus of elasticity
stringD = 0.0015875; %String Diameter

%failure parameters for bow
maxtension = 1790000;
maxcompression = 16500000;

%really what you want to look at is Nodes and element
Initial_Matrix_Maker;

F = zeros(NN*3,1);
U=zeros(NN*3,1);
Uminus=zeros(NN*3,1);
Uplus=zeros(NN*3,1);
x_Animate = zeros(NN, 2000);
y_Animate = zeros(NN, 2000);
KeffMatrices = zeros(6, 6, NN);

%really what you wanna look at is G_K G_M G_C


sparseNodes=[3*NN 3*NN-1 3*NN/2 3*NN/2-1 3*NN/2-2];

%sparce
[ G_M, G_K, G_C, KeffMatrices ] = CoefMaker( NN, element);
[G_K,G_C,G_M,Uplus,U,Uminus,F]= Sparse(G_K,G_C,G_M,Uplus,U,Uminus,F,sparseNodes,RunningFlag);
RunningFlag=1;


% while ((failureFlag == 0 )&&( F(end-2) <= 2*F_End))
while (failureFlag == 0)
    
F(end - 2) = F(end - 2) + F_Step;

%Setup to make everything in the form Ax = B
        A = G_M/dt^2 + G_C/(2*dt); 
        G1 = (G_K - 2*G_M/(dt^2))*U;
        G2 = (G_M/dt^2 - G_C/(2*dt))*Uminus;
% 
%         if (F(end-2) < F_End)
           B =  -G1 - G2 + F;    %make force vector
%         else
%            B =  -G1 - G2;
%         end

        %Solve for Uplus
%       Uplus = seidelSolver(G_M,G_K,G_C,Uminus,U,dt,F);
%       Uplus = seidelSolver(A,U,B);
        Uplus = inv(A)*B;
%         if Uplus(8)~=Uplus(11)
%             pause;
%         end
        Uminus = U;
        U = Uplus;
        

    flag_center = 0;
    for i = 1 : NN - 1
        if i == NN/2
            flag_center = 1;
        end

        if flag_center == 0 
            Nodes(i,1) = Nodes(i,1) + U(3*i-2,1)-Uminus(3*i-2,1);
            x_Animate(i, count+1) =  Nodes(i,1);
            Nodes(i,2) = Nodes(i,2) + U(3*i-1,1)-Uminus(3*i-1,1);
            y_Animate(i, count+1) =  Nodes(i,2);
        elseif i == NN - 1
            Nodes(i+1,1) = Nodes(i+1,1) + U(3*i-2,1)-Uminus(3*i-2,1);
            x_Animate(i+1, count+1) =  Nodes(i+1,1);
            Nodes(i+1,2) = 0;
            y_Animate(i+1, count+1) =  0;
        else
            Nodes(i+1,1) = Nodes(i+1,1) + U(3*i-2,1)-Uminus(3*i-2,1);
            x_Animate(i+1, count+1) =  Nodes(i+1,1);
            Nodes(i+1,2) = Nodes(i+1,2) + U(3*i-1,1)-Uminus(3*i-1,1);
            y_Animate(i+1, count+1) =  Nodes(i+1,2);
        end
                
    end
    
%     %string(2) is the string node which moves in the X direction
%     stringx(2) = stringx(2) + U(end-2) - Uminus(end-2);
%     stringy(2)=0; %string node does not move in the Y direction so it is always zero
%     %add the string node to the animation matrix as the last node
%     x_Animate(end, count+1) =  stringx(2);
%     y_Animate(end, count+1) =  stringy(2);
%     
%     %update the endpoints of the string (unnecessary since they are the
%     %same as the end points on the bow)
%     stringx(1) = xfinal(1);
%     stringx(end)=xfinal(end);
%     stringy(end)=yfinal(end);
%     stringy(1)=yfinal(1);
for i = 1:NN
    element(i,7)=sqrt((Nodes(element(i,2),1)-Nodes(element(i,1),1))^2 + ...
        (Nodes(element(i,2),2)-Nodes(element(i,1),2))^2);
    element(i,3)= (Nodes(element(i,2),1)-Nodes(element(i,1),1))/element(i,7);%(x2-x1)/L
    element(i,4)= (Nodes(element(i,2),2)-Nodes(element(i,1),2))/element(i,7);%(y2-y1)/L
end 
    %show the current shape of the bow in an animation
    Animation(x_Animate(:,count+1).',y_Animate(:,count+1).',F(end - 2))

%     for j=2:3
%         stringangle(j) = atan((stringy(j)-stringy(j-1)) ./ (stringx(j)-stringx(j-1)));
%         if j==3
%             stringangle(j) = pi - stringangle(j); %hard code the angle tranfer, who cares, theres only ever 3 string nodes
%         end
%     end
% 
%     %angle
%     for i = 2:1:length(xfinal)
%         angles(i) = atan( (yfinal(i)-yfinal(i-1)) / (xfinal(i)-xfinal(i-1)));
%         if angles(i) < 0
%             angles(i) = pi + angles(i);
%         end
%     end

    %updates the lengths of each bow element (not string)
%     elementVec = zeros(1,length(xfinal));
%     for i = 2:length(xfinal)
%         elementVec(1,i) = sqrt((xfinal(1,i)-xfinal(1,i-1))^2 +...
%                          (yfinal(1,i)-yfinal(1,i-1))^2);
%     end

    [ G_M, G_K, G_C, KeffMatrices ] = CoefMaker( NN, element);
    [G_K,G_C,G_M,Uplus,U,Uminus,F]= Sparse(G_K,G_C,G_M,Uplus,U,Uminus,F,sparseNodes,RunningFlag);

%     [G_K,G_C,G_M] = Sparse2(G_K,G_C,G_M,indexcenternode);
    
    %check failure
    count = count+1;
%     if mod(count,300)==0
%         pause;
%     end

end

% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %Initial setup; creates xfinal(), yfinal(), angles(), thickness()
% Initial_Matrix_Maker;
% U = zeros(3*(length(xfinal(1,:))+1),1); %Change the hard-coded value to (length(Global),1))
% Uplus = zeros(3*(length(xfinal(1,:))+1),1);
% Uminus = zeros(3*(length(xfinal(1,:))+1),1);
% F = zeros(3*(length(xfinal(1,:))+1),1);
% XAni = zeros(length(xfinal(1,:))+1, Flim); %X animation matrix
% YAni = zeros(length(xfinal(1,:))+1, Flim); %Y animation matrix
% StringLE = sqrt((stringy(3)-stringy(2))^2 + (stringx(3)-stringx(2))^2);
% 
% [G_K,G_C,G_M,Uplus,U,Uminus,F]= Sparse(G_K,G_C,G_M,Uplus,U,Uminus,F,indexcenternode);
% 
% 


% clear all;
% close all;
% clc;
% 
% %Constants
% Flim = 100; %Limit on force vector; biiigggg value to set
%                  %limit outside of possible failure point
% 
% 
% Fslope = 2000000; %ROC of the force increments; calculated based on
%               %typical loading at 1s, or full draw in regular use
% dt = 0.0001; %time step
% TimeTerm = 500*dt;
% 
% 
% 
% E = xlsread('InputFile', 1, 'B2');
% p = xlsread('InputFile', 1, 'B4'); %Density (wood)
% w = xlsread('InputFile', 1, 'B6'); %Width of wood (Constant)
% stringMass = xlsread('InputFile', 1, 'H4'); % Mass of the string 
% stringE = xlsread('InputFile', 1, 'H2'); %String modulus of elasticity
% stringD = xlsread('InputFile', 1, 'H6'); %String Radius
% failure = 0; %Failure flag; if failure condition is reached, set to 1
% count = 0; %Number of iterations the while loop has gone through.
% maxtension = xlsread('InputFile', 1, 'B8');
% maxcompression = xlsread('InputFile', 1, 'B10');
% 
% 
% %Initial setup; creates xfinal(), yfinal(), angles(), thickness()
% Initial_Matrix_Maker;
% U = zeros(3*(length(xfinal(1,:))+1),1); %Change the hard-coded value to (length(Global),1))
% Uplus = zeros(3*(length(xfinal(1,:))+1),1);
% Uminus = zeros(3*(length(xfinal(1,:))+1),1);
% F = zeros(3*(length(xfinal(1,:))+1),1);
% XAni = zeros(length(xfinal(1,:))+1, Flim); %X animation matrix
% YAni = zeros(length(xfinal(1,:))+1, Flim); %Y animation matrix
% StringLE = sqrt((stringy(3)-stringy(2))^2 + (stringx(3)-stringx(2))^2);
% 
% 
% %force input vector
% Fap = Fslope*dt:Fslope*dt:TimeTerm*Fslope; 
% 
% ElementVec;
% CoefMaker; 
% [G_K,G_C,G_M,Uplus,U,Uminus,F]= Sparse(G_K,G_C,G_M,Uplus,U,Uminus,F,indexcenternode);
% 
% for time = 0:dt:TimeTerm 
% % while failure == 0 %|| Fap(1,count+1) ~= Flim
%     % Making Global matrices
%     F(3*(length(xfinal))-2,1) = Fap(1, count+1);
%     if count > 0
%         for i = 1:(length(xfinal(1,:)))
%             if i == indexcenternode
%                 i = i+1;
%             end
%                 xfinal(1,i) = xfinal(1,i) + U(3*i-2,1)-Uminus(3*i-2,1);
%                 XAni(i,count+1) = xfinal(1,i);
%                 yfinal(1,i) = yfinal(1,i) + U(3*i-1,1)-Uminus(3*i-1,1);
%                 YAni(i,count+1) = yfinal(1,i);
%         end
%         
% %         XAni(i+1,count+1) = stringx(1, 1);
% %         stringx(2) = stringx(2) + U(3*i+1,1)-Uminus(3*i+1,1);
% %         YAni(i+1,count+1) = stringx(1, 1);
%         
%     
%     
%     %update position of string
%     stringx(1) = xfinal(1);
%     stringx(3) = xfinal(1);
%     stringy(1) = yfinal(1);
%     stringy(3) = yfinal(length(yfinal));
% 
%     %update angle
%     for j=2:3
%         stringangle(j) = atan((stringy(j)-stringy(j-1)) ./ (stringx(j)-stringx(j-1)));
%         if j==3
%             stringangle(j) = pi - stringangle(j); %hard code the angle tranfer, who cares, theres only ever 3 string nodes
%         end
%     end
%     
%     
%     %StringLE = sqrt((stringy(3)-stringy(2))^2 + (stringx(3)-stringx(2))^2);
% 
%     % make garbage to fuck around with
%     LoopU = zeros(3*(length(xfinal(1,:))+1),1); 
%     LoopUd = zeros(3*(length(xfinal(1,:))+1),1);
%     LoopUdd = zeros(3*(length(xfinal(1,:))+1),1);
%     LoopF = zeros(3*(length(xfinal(1,:))+1),1);
%     clearvars G_K G_M G_C;
%     
%     ElementVec; % Makes a vector, elementVec(), with element lengths.
%     CoefMaker; 
%     [G_K,G_C,G_M,LoopU,LoopUd,LoopUdd,LoopF]= Sparse(G_K,G_C,G_M,LoopU,LoopUd,LoopUdd,LoopF,indexcenternode);
%     clearvars LoopU;
%     clearvars LoopUd;
%     clearvars LoopUdd;
%     clearvars LoopF;
%     
%     end
%     
%     %Setup to make everything in the form Ax = B
%     A = 1/dt^2*G_M + 1/(2*dt)*G_C; 
%     G1 = (G_K - 2/dt^2*G_M)*U;
%     G2 = (1/dt^2*G_M - 1/(2*dt)*G_C)*Uminus;
%     
%     %make force vector
%     B =  -G1 - G2 + F;
% %     
%     %Solve for Uplus
% %     Uplus = seidelSolver(G_M,G_K,G_C,Uminus,U,dt,F);
%     Uplus = inv(A)*B;
%     Uminus = U;
%     U = Uplus; 
% %     
% %     %Check for failure
%      % failure = IsBroken( KeffMatrices, U, angles, length(xfinal), thickness, w, maxtension, maxcompression);
% %  
% % 
%       count = count + 1
%       if count> 500
%         failure = 1; %remove once IsBroken is done
%       end
% end
