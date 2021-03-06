clear all;
close all;
clc;

NN=16; %number of nodes

%------------------------------Test Type----------------------------------%
% WARNING!! Oscillation will take a long time to run due to the number of
% iterations through the loop.
PullBack=1;
Oscillation=0;
TestType=Oscillation; 
%-------------------------------------------------------------------------%

%----------------Force settings (force is in newtons)---------------------%
F_Start = 0;
F_Step = 0.01;
if TestType == Oscillation
    F_End = 35;
    maxTime=40000;
else
    F_End = 2000;
    maxTime=8000;
end
%time step
dt = 0.001;
%-------------------------------------------------------------------------%

%number of times through loop
count = 0;

%running flag will be set to one after the first iteration to avoid
%resparcing unnecessary sparcing
RunningFlag=0;

%-------------------------------wood properties---------------------------%
E =7900000000; %youngs Modulus of wood
p = 470; %Density (wood)
w = 0.04445; %Width of wood (Constant)
%failure parameters for wooden bow were found at:
%http://www.matbase.com/material-categories/composites/polymer-matrix-composites-pmc/wood/class-2-wood-durable/material-properties-of-western-red-cedar-wood.html#properties
maxtension = 35e6;%took out two zeros
maxcompression = 50e6;%took out two zeros
%-------------------------------------------------------------------------%

%---------------------------string properties-----------------------------%
stringMass = 0.0164427; % Mass of the string 
stringE = 2e11; %String modulus of elasticity
stringR = 0.0015875/2; %String Radius
stringP = 7750; %String density
%-------------------------------------------------------------------------%

%------------------Elemental and Node Matrix creation---------------------%
Nodes = zeros(NN,2); 
element=zeros(NN,10);
%-------------------------------------------------------------------------%

%this script assigns values to the Nodes and element matrix
Initial_Matrix_Maker;

%--------Create all the vectors and matricies needed for bow testing------%
F = zeros(NN*3,1);
U=zeros(NN*3,1);
Uminus=zeros(NN*3,1);
Uplus=zeros(NN*3,1);
x_Animate = zeros(NN, maxTime);
y_Animate = zeros(NN, maxTime);
Keff = zeros(6, 6, NN);
BrokenFlag = 0;
%-------------------------------------------------------------------------%

%---------Create first coefficient matricies and sparse them--------------%

sparseNodes=[3*NN 3*NN-1 3*NN/2 3*NN/2-1 3*NN/2-2];
[ G_M, G_K, G_C, Keff] = CoefMaker( NN, element);
[G_K,G_C,G_M,Uplus,U,Uminus,F]= Sparse(G_K,G_C,G_M,Uplus,U,Uminus,F,sparseNodes,RunningFlag);
RunningFlag=1;
%-------------------------------------------------------------------------%

%This loop applies a force to the string node and after the maximum force
%prescribed above is reached, the force is removed. The total time can be
%adjusted through the maxTime variable and the time step is defined by the
%dt variable.
while (count < maxTime)
    
    %increment the force until the force reached F_End
    if F(end)<F_End
        F(end) = F(end) + F_Step;
    else
        if TestType==PullBack
            error('Bow did not break');
        end
    end

    %Setup to make everything in the form Ax = B
    A = G_M/dt^2 + G_C/(2*dt); 
    G1 = (G_K - 2*G_M/(dt^2))*U;
    G2 = (G_M/dt^2 - G_C/(2*dt))*Uminus;

    %At F_End, the force is removed in order to see the oscillation of
    %the bow for Oscillation TestType. Force keeps ramping up for PullBack
    %TestType
    if (F(end) < F_End || TestType==PullBack)
       B =  -G1 - G2 + F;    
    else
       B =  -G1 - G2;
    end

    Uplus = seidelSolver(A,U,B);
    Uminus = U;
    U = Uplus;
    
    %put the coordinates of each node for each time step in a matrix in
    %order to keep track of them throughout the entire test. 
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
            %this case is to adjust the displacement of the string
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
    
    %recalculate the lengths of the elements and their angles
    for i = 1:NN
            element(i,7)=sqrt((Nodes(element(i,2),1)-Nodes(element(i,1),1))^2 + ...
                (Nodes(element(i,2),2)-Nodes(element(i,1),2))^2);
        element(i,3)= (Nodes(element(i,2),1)-Nodes(element(i,1),1))/element(i,7);%(x2-x1)/L
        element(i,4)= (Nodes(element(i,2),2)-Nodes(element(i,1),2))/element(i,7);%(y2-y1)/L
    end 
    
    %show the current shape of the bow in an animation
     Animation(x_Animate(:,count+1).',y_Animate(:,count+1).',F(end));

    %Calculates the stress within each member to determine if max tension
    %or compression has been reached
    if TestType==PullBack
        BrokenFlag = IsBroken( Keff, U, element, NN, maxtension, maxcompression,F(end));
        if BrokenFlag == 1
            error('Bow Broken');
        end
    end
    
    %recalculate the coefficient matricies
    [ G_M, G_K, G_C, Keff] = CoefMaker( NN, element);
    [G_K,G_C,G_M,Uplus,U,Uminus,F]= Sparse(G_K,G_C,G_M,Uplus,U,Uminus,F,sparseNodes,RunningFlag);
    count = count+1;
end

figure(2);
plot(x_Animate(NN,:));
title('String Node Position in X direction')
xlabel('time(ms)');
ylabel('x position relative to center of the bow (m)');

figure(3);
plot(x_Animate(NN-1,:));
title('Bottom Bow Node Position in X direction')
xlabel('time(ms)');
ylabel('x position relative to center of the bow (m)');

figure(4);
plot(x_Animate(1,:));
title('Top Bow Node Position in X direction')
xlabel('time(ms)');
ylabel('x position relative to center of the bow (m)');
