classdef qx244_bdl < handle
    % Bidirectional Delay Line
    properties
        % Parameters
        len; % length of the delay line in samples
        R; % Wave Impedance
        % Internal Data
        dLineR; % the vector that represents the Right Going delay line
        dLineL; % the vector that represents the Left Going delay line
        % In order to connect with qx244_sj...
        portR; % saves the sj object that is connected to the right
        portRIdx; % which port on the sj object this is connected to
        portL; % saves the sj object that is connected to the left
        portLIdx; %  which port on the sj object this is connected to
        nextInR = 0; % A place for sj objects to store their output before the delay line propergates using the step method
        nextInL = 0; % Same as nextInR, but on the left side.
    end
       
    methods
        function obj = qx244_bdl(R,len)
            if nargin < 1
                R = 0;
            end           
            if nargin < 2
                len = 1;
            end
            obj.R = R;
            obj.len = len;
            obj.dLineR = zeros(1,obj.len);
            obj.dLineL = zeros(1,obj.len);
        end
        function step(obj,inR,inL)
            if nargin < 2
                inR = obj.nextInR;
                inL = obj.nextInL;
            end
            stepSize = length(inR);
            tempMat = [inL, obj.dLineR; obj.dLineL, inR];
            obj.portR.Vin(obj.portRIdx) = tempMat(1,(end-stepSize+1):end);
            obj.portL.Vin(obj.portLIdx) = tempMat(2,1:stepSize);
            obj.dLineR = tempMat(1,1:(end-stepSize));
            obj.dLineL = tempMat(2,(stepSize+1):end);
            obj.nextInR = 0;
            obj.nextInL = 0;
        end
        function connect(obj,sj,side)
            if strcmp(side, 'l')
                obj.portL = sj;
            elseif strcmp(side, 'r')
                obj.portR = sj;
            end
            sj.connect(obj, side);
        end   
        function initialize(obj,vec)
            if strcmp(vec,'random')
                vec = rand(1,obj.len) - 0.5;
            end
            obj.dLineR = vec ./ 2;
            obj.dLineL = vec ./ 2;
            obj.len = length(vec);
        end        
        function graph(obj)
            figure();
            subplot(311);
            stem(obj.dLineR);
            title('Right Traveling Delay Line');
            ylim([-1,1]);
            xlim([1,length(obj.dLineR)]);
            
            subplot(312);
            stem(obj.dLineL);
            title('Left Traveling Delay Line');
            ylim([-1,1]);
            xlim([1,length(obj.dLineR)]);
            
            subplot(313);
            stem(obj.dLineR+obj.dLineL);
            title('Simulated Wave from Summing BDL');
            ylim([-1,1]);
            xlim([1,length(obj.dLineR)]);
        end
        function output = tap(obj,i)
            output = obj.dLineR(i)+obj.dLineL(i);
        end
    end
end

