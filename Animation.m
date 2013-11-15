function [] = Animation(setOfFinalXBow,setOfFinalYBow,force)

    figure(1);
    clf(1);
    force=1/4.44822162825*force;
    title([num2str(force),' lbs'],'Color',[.6 0 0])
    axis off,axis equal
    ylim([-1 1]);
    xlim([-1 1]);
        
    for i=1:(length(setOfFinalXBow))-1
        if i<length(setOfFinalXBow)-1
            line(setOfFinalXBow(1,i:i+1),setOfFinalYBow(1,i:i+1),'color','blue');
        else
            line(setOfFinalXBow(1,i:i+1),setOfFinalYBow(1,i:i+1),'color','red');
            hold on;
            X=[setOfFinalXBow(1,i+1) setOfFinalXBow(1,1)];
            Y=[setOfFinalYBow(1,i+1) setOfFinalYBow(1,1)];
            line(X,Y,'color','red');
        end
    end
end