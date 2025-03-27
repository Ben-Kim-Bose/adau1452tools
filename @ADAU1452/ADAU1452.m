classdef ADAU1452
    % ADAU1452 Class to hold connections, settings, and data routing of an
    % ADAU1452 DSP.

    properties (SetAccess=private, GetAccess=public)
        ConnectionStatus = 'Not Connected'
        SerialPortConfig
        ASRCConfig
    end 

    properties (Access=public) % make private later
        HWOBJ
        Connected = false
        InternalDataRouting
    end

    properties (Constant, Access=private)
        DeviceConstants = ADAU1452Constants();
    end

    methods (Access=public)
        function obj = ADAU1452(options)
            arguments
                options.WalnutIdx (1,1) {mustBeNumeric} = 1;
            end
            obj.HWOBJ = ADAU1452ConnectionObj('WalnutIdx',options.WalnutIdx);
            obj.ConnectionStatus = 'Connected';
            obj.Connected = obj.HWOBJ.IsConnected;
            obj.readRegister(0xF204)
            obj.SerialPortConfig = obj.getSerialPortConfig();
        end

        %% Read/Write Registers
        function [registerOut] = readRegister(obj, register_uint16, options)
           arguments
               obj 
               register_uint16 (1,:) {mustBeA(register_uint16,'uint16')}
               options.readLength (1,1) {isnumeric} = 2; % BYTES
           end
           registerOut = obj.readADAU1452Register_aardvark(register_uint16, options.readLength);
        end

        function [success] = writeRegister(obj, register_uint16, value_uint16, options)
           arguments
               obj 
               register_uint16 (1,:) {mustBeA(register_uint16,'uint16')}
               value_uint16 (1,:) {mustBeA(value_uint16,'uint16')}
               options.maxChunkSize (1,1) = -1;
               options.verifyWrites (1,1) = false;
           end
           success = obj.writeADAU1452Register_aardvark(register_uint16,value_uint16,'maxChunkSize', options.maxChunkSize,'verifyWrites',options.verifyWrites);
        end

        %% Data Routing Methods
        function [success] = populateDataRoutes(obj)
            fprintf('Populating Data Routes\n');
            %obj.InternalDataRouting = obj.populateDataRoutes_registers();
            success = true;
        end

        %% Serial Port Config
        % Proper implementation with a million args here
        function [success] = setSerialPortConfig(obj, options)
            arguments
                obj (1,1)
                options.serialPortIdx       (1,1)
                options.frameClockSource    (1,1)
                options.bitClockSource      (1,1)
                options.wordLength          (1,1)
                options.msbPosition         (1,1)
                options.tdmMode             (1,1)
                options.frameClockType      (1,1)
                options.frameClockPolarity  (1,1)
                options.bitClockPolarity    (1,1)
                options.clockGenerator      (1,1)
                options.sampleRate          (1,1)
                options.unusedOutput        (1,1)
            end
            success = false;
        end
        
        % 192kHzConfig
        % Temporary cop out register dump :p
        function [success] = set192kSPTConfig(obj)
        end


    end % End Public Methods

    %% Private Methods
    methods (Access = private)
        function [serialPortConfig] = getSerialPortConfig(obj)
            serialPortConfig = obj.getSerialPortConfig_registers();
        end
        [serialPortConfig] = getSerialPortConfig_registers(obj);
        [response] = readADAU1452Register_aardvark(obj, address_uint16, readLength);
        [success] = writeADAU1452Register_aardvark(obj, address_uint16, value_uint16, maxChunkSize, verifyWrites);
    end
end