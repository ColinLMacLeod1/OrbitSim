function [ ] = OrbitSim1
%OrbitSim1 is the the basic setup for the future
%OrbitSim.m
G = 6.674e-11; %Nm^2/kg^2 Gravitational Constant

choice = menu('Choose a Simulation','Earth and Moon','Solar System','Custom','Exit');
if choice == 4
    fprintf('Program ended by user\n')
    return
end
if choice == 1
%% Earth and Moon Situation    
    prompt = {'Number of iterations','Time interval (s)'};
    DlgBoxTitle = 'Plotting Details';
    defaultans = {'',''};
    x = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    n = x(1);
    t = x(2);
    ax = 5e8;
    Inputs = cell(1,2);
    [Inputs{1},Inputs{2}] = EarthSim;
    nP = 2;
    mode = 2;
    
elseif choice == 2
%% Solar System Situation
    msgbox('For large simulations like the solar system animated results may be extremely slow. Graphed results are suggested')
    mode = menu('Choose model type','Graphed Results','Animated Results');
    nP=9;
    prompt = {'Number of iterations','Time interval (s)'};
    DlgBoxTitle = 'Plotting Details';
    defaultans = {'',''};
    x = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    n = x(1);
    t = x(2);
    ax = 6e12;
    Inputs = cell(1,nP);
    [Inputs{1},Inputs{2},Inputs{3},Inputs{4},Inputs{5},Inputs{6},Inputs{7},Inputs{8},Inputs{9}] = SolarSim;
    
else
%% Custom Situation    
    mode = menu('Choose model type','Graphed Results','Animated Results');
    
    prompt = {'Number of iterations','Time interval (s)','Axis Scale (one dimension)'};
    DlgBoxTitle = 'Plotting Details';
    defaultans = {'','',''};
    x = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    n = x(1);
    t = x(2);
    ax= x(3);
    
    prompt = {'Enter the number of bodies'};
    DlgBoxTitle = 'Number of Bodies';
    defaultans = {''};
    nP = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    Inputs = cell(1,nP);


    prompt = {'Enter the mass','Enter the x position','Enter the y position','Enter the x velocity','Enter the y velocity','Enter the radius'};
    DlgBoxTitle = 'Enter Central Mass Stats';
    defaultans = {'mass','x','y','vx','vy','r'};
    Inputs{1} = transpose(str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans)) );

    for i=2:nP

        prompt = {'Enter the mass','Enter the x position','Enter the y position','Enter the x velocity','Enter the y velocity','Enter the radius'};
        DlgBoxTitle = 'Enter Body Stats';
        defaultans = {'mass','x','y','vx','vy','r'};
        Inputs{i} = transpose(str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans)) );
    end
    fprintf('Data Succesfully recorded \n')
%Planet array format: [mass x y vx vy r]
end

%% Setup Position Cell Arrays
Pos = cell(1,nP-1);
[Pos{1,1:length(Pos)}] = deal(zeros(2,n));
%% Movement Calculation
tic
for in = 2:nP
    fprintf('Commencing position calculations for mass %d \n',in)
    for i=1:n
    Pos{in-1}(1,i) = Inputs{in}(2);
    Pos{in-1}(2,i) = Inputs{in}(3);

    r2 = (Inputs{in}(2)-Inputs{1}(2))^2+(Inputs{in}(3)-Inputs{1}(3))^2;
    theta = atan((Inputs{in}(3)-Inputs{1}(3))/(Inputs{in}(2)-Inputs{1}(2)));
    acc = (G*Inputs{1}(1))/r2;

    AX = abs(cos(theta)*acc);
        if Inputs{in}(2)>Inputs{1}(2)
            AX=-AX;
        end % if
    AY = abs(sin(theta)*acc); 
        if Inputs{in}(3)>Inputs{1}(3)
            AY=-AY;
        end % if
 
    Inputs{in}(2) = Inputs{in}(2) + Inputs{in}(4)*t+ (1/2)*AX*(t^2);
    Inputs{in}(3) = Inputs{in}(3) + Inputs{in}(5)*t+ (1/2)*AY*(t^2);
    Inputs{in}(4) = Inputs{in}(4) + AX*t;
    Inputs{in}(5) = Inputs{in}(5) + AY*t;
    end % for loop
end % for loop
toc
%% Display

ang=0:0.01:2*pi; 
xp=Inputs{1}(6)*cos(ang);
yp=Inputs{1}(6)*sin(ang);

figure(1)
uicontrol(gcf,'style','pushbutton',...
              'string','End',...
              'callback',@exitButton);
     
    if mode == 1
tic         
        fprintf('Beginning to graph results \n')
        axis([-ax ax -ax ax])
        hold on
        plot(Inputs{1}(2)+xp,Inputs{1}(3)+yp,'LineWidth',3);
        for pl = 1:nP-1
            p(pl) = plot(Pos{pl}(1,1:100:n),Pos{pl}(2,1:100:n),'--','LineWidth',0.25);
        end % for loop
toc
    elseif mode == 2
        fprintf('Beginning to animate results \n')
        for j=1:100:n
            axis([-ax ax -ax ax])
            hold on
            plot(Inputs{1}(2)+xp,Inputs{1}(3)+yp,'LineWidth',3);
            for pl = 1:nP-1
                p(pl) = plot(Pos{pl}(1,j),Pos{pl}(2,j),'o');
            end % for loop
            pause(30/(n/100));
            if isempty(findall(0,'Type','Figure'))
                break
            end
            delete(p)
        end % for loop
    end %if
    close all
    fprintf('Program complete \n')    

    function exitButton(~,~,~) 
       fprintf('Program ended by user')
       close all
    end
end

