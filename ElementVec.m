elementVec = zeros(1,length(xfinal));
for i = 2:length(xfinal)
    elementVec(1,i) = sqrt((xfinal(1,i)-xfinal(1,i-1))^2 +...
                     (yfinal(1,i)-yfinal(1,i-1))^2);
end
