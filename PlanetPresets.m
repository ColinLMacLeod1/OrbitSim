function [Earth,Moon] = EarthSim
%% Constants

G = 6.674e-11;

%% Functions
OrbitVelocity = @(mB,d) sqrt(G*mB/(d));

%% Radii
rEarth = 6371e3;
rMoon = 1737e3;
%rSun = 1;

%% Mass
mEarth = 5.927e24;
mMoon = 7.34767309e22;
%mSun = ;

%% Distances
EdM = 384400e3;
%EdS = ;
%% Orbit velocities
%EovS = OrbitVelocity(mSun,EdS);
MovE = OrbitVelocity(mEarth,EdM);

Earth = [mEarth 0 0 0 0 rEarth];
Moon = [mMoon EdM 0 0 MovE rMoon];

end
