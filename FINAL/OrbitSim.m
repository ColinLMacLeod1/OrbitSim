function [ ] = OrbitSim
%OrbitSim is a function that takes user input through a gui and simulates celestial orbits using non-relativistic physics by
%either animating the results or graphing them. The user can input a
%variable number of masses or can choose from two preset simulations. 

G = 6.674e-11; %Nm^2/kg^2 Gravitational Constant

%% Selecting preset or custom simulation
choice = menu('Choose a Simulation','Earth and Moon','Solar System','Custom','Exit');
if choice == 4
    fprintf('Program ended by user\n')
    return
end
if choice == 1
%% Earth and Moon Situation    
    prompt = {'Number of iterations','Time interval (s)','Number of plotted iterations'};
    DlgBoxTitle = 'Plotting Details';
    defaultans = {'100000','100','1000'};
    x = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    n = x(1); %Number of iterations
    t = x(2); %Time between each iteration
    np= x(3); %Number of iterations that will be plotted
    ax = 5e8; %Axis
    Inputs = cell(1,2); %Initializing a cell for the user input masses
    [Inputs{1},Inputs{2}] = EarthSim;
    nP = 2; %Number of masses in the simulation
    mode = 2;
    
elseif choice == 2
%% Solar System Situation
    msgbox('For large simulations like the solar system animated results may be extremely slow. Graphed results are suggested')
    mode = menu('Choose model type','Graphed Results','Animated Results');
    nP=9;     %Number of masses in the simulation
    prompt = {'Number of calculated iterations','Time interval (s)','Number of plotted iterations'};
    DlgBoxTitle = 'Plotting Details';
    defaultans = {'10000','1000000','1000'};
    x = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    n = x(1); %Number of iterations
    t = x(2); %Time between each iteration
    np= x(3); %Number of iterations that will be plotted
    ax = 6e12;%Axis
    Inputs = cell(1,nP);%Initializing a cell for the user input masses
    [Inputs{1},Inputs{2},Inputs{3},Inputs{4},Inputs{5},Inputs{6},Inputs{7},Inputs{8},Inputs{9}] = SolarSim;
    
else
%% Custom Situation    
    mode = menu('Choose model type','Graphed Results','Animated Results');
    
    prompt = {'Number of iterations','Time interval (s)','Axis Scale (one dimension)','Number of plotted iterations'};
    DlgBoxTitle = 'Plotting Details';
    defaultans = {'','','',''};
    x = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));
    n = x(1); %Number of iterations
    t = x(2); %Time between each iteration
    ax= x(3); %Axis
    np= x(4); %Number of iterations that will be plotted
    
    prompt = {'Enter the number of bodies'};
    DlgBoxTitle = 'Number of Bodies';
    defaultans = {''};
    nP = str2double(inputdlg(prompt,DlgBoxTitle,1,defaultans));%Number of masses in the simulation
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

for in = 2:nP
    fprintf('Calculating positions for mass %d \n',in)
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
 
    Inputs{in}(2) = Inputs{in}(2) + Inputs{in}(4)*t+ (1/2)*AX*(t^2); %Assigning new x position
    Inputs{in}(3) = Inputs{in}(3) + Inputs{in}(5)*t+ (1/2)*AY*(t^2); %Assigning new y position
    Inputs{in}(4) = Inputs{in}(4) + AX*t; %Assigning new x velocity
    Inputs{in}(5) = Inputs{in}(5) + AY*t; %Assigning new y velocity
    end % for loop
end % for loop

%% Display

interv = round(n/np); % The interval for plotting fewer points than intervals calculated
%Creating a circle for the central mass:
xp=Inputs{1}(6)*cos(0:0.01:2*pi);
yp=Inputs{1}(6)*sin(0:0.01:2*pi);

%Initializing the figure
figure(1)
title('Orbit Simulation')
uicontrol(gcf,'style','pushbutton',...
              'string','End',...
              'callback',@exitButton);
     
    if mode == 1
        %% Graphed Results      
        fprintf('\nGraphing results \n')
        axis([-ax ax -ax ax])
        hold on
        plot(Inputs{1}(2)+xp,Inputs{1}(3)+yp,'k','LineWidth',3);
        for pl = 1:nP-1
            p(pl) = plot(Pos{pl}(1,1:interv:n),Pos{pl}(2,1:interv:n),'--','LineWidth',0.25);
        end % for loop
        pause(30);
    elseif mode == 2
        %% Animated Results
        fprintf('\nAnimating results \n\n')
        for j=1:interv:n
            axis([-ax ax -ax ax])
            hold on
            plot(Inputs{1}(2)+xp,Inputs{1}(3)+yp,'k','LineWidth',3);
            for pl = 1:nP-1
                p(pl) = plot(Pos{pl}(1,j),Pos{pl}(2,j),'o');
            end % for loop
            pause(15/(n/interv));
            if isempty(findall(0,'Type','Figure')) %Breaks Loop if Figure is closed
                break
            end
            delete(p)
        end % for loop
    end %if
    close all
    fprintf('\nProgram complete \n')    

    function exitButton(~,~,~) 
       fprintf('Program ended by user \n')
       close all
    end
    
end

