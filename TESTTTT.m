
for j=1:100:n
   axis([-ax ax -ax ax])
   hold on
   plot(Inputs{1}(2)+Bxp,Inputs{1}(3)+Byp,'LineWidth',3);
   for pl = 1:nP-1
        p(pl) = plot(Pos{pl}(1,j),Pos{pl}(2,j),'o');
   end % for loop
  % pause(1e-15);
   if isempty(findall(0,'Type','Figure'))
       break
   end
   %delete(p)

end % for loop