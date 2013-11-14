NN=8; %number of nodes                                                                                                                                                                                                 ; %number of nodes including string
%columns in elemental matrix
N1=1;N2=2;C=3;S=4;e=5;CrossA=6;L=7; ro=8;thick=9; I=10;
element=zeros(NN,10);

E =6894757290; %youngs Modulus of wood
p = 470; %Density (wood)
w = 0.04445; %Width of wood (Constant)
stringMass = 0.0164427; % Mass of the string 
stringE = 2e11; %String modulus of elasticity
stringR = 0.0015875/2; %String Diameter
stringP = 7750; %string density
thickIncrem=0.0127/(NN/2-2); %change in thickness when moving along the bow
tmax=16.75; %adjust this variable to change the curvature of the bow

%these variables are used to compute the shape of the bow
t=[0:0.0001:tmax]; 
r=(tmax^2+75^2)/(2*tmax);
x=t;
y=sqrt(r.^2-(t-r).^2);

%this section is used to calculate the arclength of half the bow
arclength=0;
for i=2:length(t)
    arclength= arclength+sqrt((y(i)-y(i-1))^2 + (x(i)-x(i-1))^2);
end

Nodes = zeros(NN,2); 
Nodes(NN/2,1) = x(1);
Nodes(NN/2,2) = y(1);
        
n=1;
linelength=0;
for i = 2:length(t)
  %arclength of the current element
  linelength = linelength + sqrt((y(i)-y(i-1))^2 + (x(i)-x(i-1))^2);

    if linelength +sqrt((y(i)-y(i-1))^2 + (x(i)-x(i-1))^2)> arclength/(NN/2-1)    %0.1655
        Nodes(NN/2-n,1) = x(i)/100; %divide by 100 to get into meters
        Nodes(NN/2-n,2) = y(i)/100;
        n = n +1;
        linelength=0;
    end

end

%creates the symmetry of the bow
for i=1:NN/2-1
    Nodes(NN-i,1)=Nodes(i,1);
    Nodes(NN-i,2)=-Nodes(i,2);
end
Nodes(end,1)=Nodes(end-1,1); %set inital position of string seperately

%fills in the elemental matrix
for i=1:NN
    %assign 2 local nodes to each element
    if i==NN
        element(i,N1)=1;
        element(i,N2)=i;
    else
        element(i,N2)=i+1;
        element(i,N1)=i;
    end
    
    %elements that can be computed without needing specific parameters like
    %youngs modulus and thickness
    element(i,L)=sqrt((Nodes(element(i,N2),1)-Nodes(element(i,N1),1))^2 + ...
        (Nodes(element(i,N2),2)-Nodes(element(i,N1),2))^2);
    element(i,C)= (Nodes(element(i,N2),1)-Nodes(element(i,N1),1))/element(i,L);%(x2-x1)/L
    element(i,S)= (Nodes(element(i,N2),2)-Nodes(element(i,N1),2))/element(i,L);%(y2-y1)/L
    
    %Add elemental information that requires specific parameters that are
    %different for the string and the bow
    if i<NN-1
        %Bow elements
        if i<=NN/2-1
            element(i,thick)=0.00635+(i-1)*thickIncrem;
            element(NN-1-i,thick)=element(i,9);
        end
        element(i,e)=E;
        element(i,CrossA)=w*element(i,thick);
        element(i,ro)=p;
        element(i,I)=w*element(i,thick)^3/12;
    else
        %String elements
        element(i,thick)=stringR*2;
        element(i,ro)=stringP;
        element(i,CrossA)=pi*(stringR)^2;
        element(i,e)=stringE;
        element(i,I)=pi* (stringR)^4 / 4; 
    end
end

%plots the bow
figure('color','white');
bow=zeros(NN,1);
axis equal, axis off
ylim([-1 1]);
xlim([-1 1]);

%thickness is multiplied by ten so that the change in thickness is apparent
for i=1:NN
    lx=[Nodes(element(i,N1),1) Nodes(element(i,N2),1)];
    ly=[Nodes(element(i,N1),2) Nodes(element(i,N2),2)];
    bow(i,1)=line(lx,ly,'color','blue','LineWidth',element(i,thick)*100);
end



