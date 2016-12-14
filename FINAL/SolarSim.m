function [sun,mercury,venus,earth,mars,jupiter,saturn,uranus,neptune] = SolarSim
%% Constants
G = 6.674e-11;

%% Functions
OrbitVelocity = @(mB,d) sqrt(G*mB/(d));

%% Radii
rSun = 696342e3;

%% Mass
mSun = 1988550000e21;
mMerc = 60.83e21;
mVenus = 4868.5e21;
mEarth = 5973.6e21;
mMars = 163.18e21;
mJup = 1898600e21;
mSat = 1898600e21;
mUr = 86832e21;
mNep = 102430e21;


%% Distances
dMerc = 5.79e10;
dVenus = 1.082e11;
dEarth = 1.496e11;
dMars = 2.279e11;
dJup = 7.786e11;
dSat = 1.433e12;
dUr = 2.873e12;
dNep = 4.495e12;

%% Orbit velocities
vMerc = OrbitVelocity(mSun,dMerc);
vVenus = OrbitVelocity(mSun,dVenus);
vEarth = OrbitVelocity(mSun,dEarth);
vMars = OrbitVelocity(mSun,dMars);
vJup = OrbitVelocity(mSun,dJup);
vSat = OrbitVelocity(mSun,dSat);
vUr = OrbitVelocity(mSun,dUr);
vNep = OrbitVelocity(mSun,dNep);


sun = [mSun 0 0 0 0 rSun];
mercury= [mMerc dMerc 0 0 vMerc 1];
venus = [mVenus dVenus 0 0 vVenus 1];
earth = [mEarth dEarth 0 0 vEarth 1];
mars = [mMars dMars 0 0 vMars 1];
jupiter = [mJup dJup 0 0 vJup 1];
saturn = [mSat dSat 0 0 vSat 1];
uranus = [mUr dUr 0 0 vUr 1];
neptune = [mNep dNep 0 0 vNep 1];

end