%% qx244_sj demo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script will create an instance of qx244_sj and demonstrate
% scattering at impedance change through connecting sj and bdl.

% Create an instance of a qx244_sj
mySJ = qx244_sj(0); % A scatter junction with 0 internal impedance.

% Create two BDLs of different impedance and connect them to mySJ
% Creating BDLs and connecting
bdl1 = qx244_bdl(1,20);
bdl2 = qx244_bdl(2,20);
bdl1.connect(mySJ,'r'); % .connect takes two arguments, the first is the scatter junction, the second is which side of the BDL whoud be connected to the SJ.
bdl2.connect(mySJ,'l');

% Create an inpulse in bdl1
initState = zeros(1,20);
initState(12:18) = [0.4, 0.9, 0.4 0 -0.4, -0.9, -0.4];
bdl1.initialize(initState);

% Get ready to start the simulation
close all;
% step through the system for 10 time steps 
% (WARNING... 20 figures will be created)
for i = 1:10
    bdl1.step();
    bdl2.step();
    mySJ.step();
    bdl1.graph(); % the odd figures (1,3,5,7,9...19) are snapshots of bdl1
    bdl2.graph(); % the even numbered figures are snapshots of bdl2.
    mySJ % This will show the connections and status of the Scattering Junction at each time step.
end

%close all
