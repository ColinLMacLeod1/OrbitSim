close all
B = Earth;
A = Moon;
nP =2;
n = 100000;
%% Setup
G = 6.674e-11; %Nm^2/kg^2
t =10000;

X = zeros(1,n);
Y = zeros(1,n);
%{
GravForceX = @(P1,P2) (G.*P1(1).*P2(1))./((P1(2)-P2(2)).^2); %Gm1m2/r^2 
GravForceY = @(P1,P2) (G.*P1(1).*P2(1))./((P1(3)-P2(3)).^2);

Acc = @(F,M) F/M;
%}
%% Movement
for i=1:n
X(i) = A(2);
Y(i) = A(3);

r2 = (A(2)-B(2))^2+(A(3)-B(3))^2;
theta = atan((A(3)-B(3))/(A(2)-B(2)));
acc = (G*B(1))/r2;

AX = cos(theta)*acc;
if A(2)>B(2)
    AX=-AX;
end
AY =sin(theta)*acc; 
if A(3)>B(3)
    AY=-AY;
end

A(2) = A(2) + A(4)*t+ (1/2)*AX*(t^2);
A(3) = A(3) + A(5)*t+ (1/2)*AY*(t^2);
A(4) = A(4) + AX*t;
A(5) = A(5) + AY*t;

end
%% Display
ang=0:0.01:2*pi; 
Bxp=B(6)*cos(ang);
Byp=B(6)*sin(ang);

Axp=A(6)*cos(ang);
Ayp=A(6)*sin(ang);

Aabs = sqrt((AX)^2+(AY)^2)
X(n)
Y(n)

figure(1)
for j=1:n
axis([-5e8 5e8 -5e8 5e8])
hold on
plot(B(2)+Bxp,B(3)+Byp,'LineWidth',1);
p = plot(X(j)+Axp,Y(j)+Ayp,'LineWidth',1);
pause(1/100000000);
delete(p)
end
