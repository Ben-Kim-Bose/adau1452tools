classdef ADAU1452ConnectionObj < handle
    % ADAU1452CONNECTIONOBJ A connection interface for the ADAU1452's I2C
    % peripheral
    properties
        ConnectionObject;
    end

    properties (GetAccess=public, SetAccess=public)
        IsConnected = false;
    end

    methods
        function obj = ADAU1452ConnectionObj(options)
            arguments
                options.WalnutIdx (1,1) {mustBeNumeric} = 1;
            end
            if ~isMATLABReleaseOlderThan("R2023b")
                try                   
                    list = aardvarklist;
                    controller = aardvark(list.SerialNumber(1)); clear list;
                    controller.EnablePullupResistors(true);
                    controller.EnableTargetPower = true;
                    i2cbusses = scanI2CBus(controller);
                    obj.ConnectionObject = device(controller, I2CAddress=i2cbusses(options.WalnutIdx));
                    obj.IsConnected = true;
                catch ME
                    if (strcmp(ME.identifier, 'instrument:interface:serialcontroller:OpenController'))
                        disp('Clear Aardvark!')
                    end
                    rethrow(ME);
                end
            else
                error('Matlab 2023b or higher is required for Aardvark interface.')
            end
        end
    end
end

