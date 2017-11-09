%% qx244_bdl demo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The first section will create an instance of the qx244_bdl object, and
% after it is created, the rest of the sections can be run in any order.

%% To constrct a BDL
myBDL = qx244_bdl(1,20); % myBDL is now a BDL with wave impedance 1 and a length of 20 samples.
myBDL % this shows its internal structure

%% To see a BDL
myBDL.graph();

%% To load a BDL with noise
myBDL.initialize('random');
myBDL.graph();

%% To load a BDL with a specific state
bdlState = ones(1,20);
myBDL.initialize(bdlState);
myBDL.graph();

%% To load a BDL with a specific state (another example)
bdlState(9:11) = [0.5, 0, 0.5];
myBDL.initialize(bdlState);
myBDL.graph();

%% To propergate in time with BDL with .step()
bdlState = zeros(1,20);
bdlState(9:11) = [0.5, 1, 0.5];
myBDL.initialize(bdlState);
myBDL.graph();
% Advance time, propergate delay line. 5 times.
for i = 1:5
    myBDL.step();
    %myBDL.graph();
end
myBDL.graph();

%% To input signal into the delay line with .step()
bdlState = zeros(1,20);
myBDL.initialize(bdlState);
myBDL.graph();
myBDL.step(0.5,0.8); % .step(input at the right hand side, input at the left hand side)
myBDL.graph();

%% To see the behavior of the string at a specific pick-up location on the BDL with .tap()
bdlState = [0 0.5, 1, 0.5 0 0.5, 1, 0.5 0 0.3, 0.8, 0.3 0 0.4, 1, 0.4 0 0.5, 1, 0.5 0 0.5, 1, 0.5 0];
myBDL.initialize(bdlState);
myBDL.graph();
pickUp = zeros(5,1);
for i = 1:5 % do it five times
    pickUp(i) = myBDL.tap(10); % output the state of the string at location 10 out of 20 shift registers.
    myBDL.step();
end
myBDL.graph();
figure();
stem(pickUp); 
title('The output of the vibrating string picked up at the center of the string');
