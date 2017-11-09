%% plucked String Sound Demo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script will create a system that simulate a string terminated on
% both side. It would generate a sound, and the algorithm may take up to 20
% secs or so to complete.
clear all;
close all;
%% User Parameters: Change these and run again~~
Rj = 150;         % Impedance at terminating Junctures
stringLen = 70;   % The length of the BDL which is the length of the String
pickUpPoint = 20; % The position of the pickup. Needs to be between 1 and stringLen.

%% Main Script
% Create Scattering Junction that terminates the string
sj1 = qx244_sj(Rj);
sj2 = qx244_sj(Rj);
% Creates the BDL and connect it properly.
seg1 = qx244_bdl(1, stringLen);
seg1.initialize('random');
seg1.connect(sj1,'l');
seg1.connect(sj2,'r');

% Do simulation for 1 second and pickup the sound 
sound = zeros(44100,1);
for i = 2:44100
    seg1.step();
    sj1.step();
    sj2.step();
    sound(i) = sound(i-1)+seg1.tap(pickUpPoint); % Taking the intergral to translate from Velocity wave to Displacement Wave
end

% Plot and play the sound
figure()
plot(sound);
soundsc(sound, 44100);