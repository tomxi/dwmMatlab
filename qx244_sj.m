classdef qx244_sj < handle
    %Scatter Junction
    properties
        Rj; % Junction Impedance
        % Internal
        Vj = 0; % Junction Velocity
        ports = []; % BDLs connected to this sj
        portSide = []; % Which side of the BDL is connected?
        Vin = []; % A place to store a list of inputs from different BDLs ready to be scattered 
        Rsum;  % Sum of all the impedances at the Junction, to facilitate calculation
    end
    
    methods
        function obj = qx244_sj(r)
            if nargin < 1
                r = 0;
            end
            obj.Rj = r;
            obj.updateRsum();
        end
        function connect(obj,BDL,side)
            obj.ports = [obj.ports BDL];
            if strcmp(side, 'l')
                BDL.portLIdx = length(obj.ports);
            elseif strcmp(side, 'r')
                BDL.portRIdx = length(obj.ports);
            end
            obj.Vin = [obj.Vin 0];
            obj.portSide = [obj.portSide side];
            obj.updateRsum();
        end       
        function updateRsum(obj)
            sum = obj.Rj;
            for bdl = obj.ports
                sum = sum + bdl.R;
            end
            obj.Rsum = sum;
        end
        function step(obj, Vin)
            if nargin < 2
                Vin = 0;
            end
            obj.Vin = obj.Vin + Vin;
            Vj = 0;
            for i = 1:length(obj.ports)
                Vj = Vj + 2*obj.ports(i).R / obj.Rsum * obj.Vin(i);
            end
            obj.Vj = Vj;
            VjVec = ones(1, length(Vin)) * obj.Vj;
            Vout = VjVec - obj.Vin;
            obj.Vin = obj.Vin * 0;
            for i = 1:length(obj.ports)
                if strcmp(obj.portSide(i),'r')
                    obj.ports(i).nextInR = Vout(i);
                elseif strcmp(obj.portSide(i),'l')
                    obj.ports(i).nextInL = Vout(i);   
                end
            end
        end   
    end
 end

