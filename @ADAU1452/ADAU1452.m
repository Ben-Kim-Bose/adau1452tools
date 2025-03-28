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
            obj.SerialPortConfig = obj.getSerialPortConfig();
        end

        %% Read/Write Registers
        function [registerOut] = readRegister(obj, register_uint16, options)
           arguments
               obj 
               register_uint16 (1,:) {mustBeA(register_uint16,'uint16')}
               options.readLength (1,1) {isnumeric} = 2; % length of read, currently only works with 2 bytes.
           end
           registerOut = obj.readADAU1452Register_aardvark(register_uint16, options.readLength);
        end

        function [success] = writeRegister(obj, register_uint16, value_uint16, options)
           arguments
               obj 
               register_uint16 (1,:) {mustBeA(register_uint16,'uint16')}
               value_uint16 (1,:) {mustBeA(value_uint16,'uint16')}
               options.verifyWrites (1,1) = false;
           end
           success = obj.writeADAU1452Register_aardvark(register_uint16, value_uint16, options.verifyWrites);
        end

        %% Data Routing Methods
        function [success] = populateDataRoutes(obj)
            fprintf('Populating Data Routes\n');
            %obj.InternalDataRouting = obj.populateDataRoutes_registers();
            success = true;
        end

        %% Serial Port Config
        function [serialPortConfig] = getSerialPortConfig(obj)
            fprintf('Reading current Serial Port Configuration\n');
            serialPortConfig = obj.getSerialPortConfig_registers();
        end

        function [success] = setSerialPortConfig(obj, serialPort, options)
            % setSerialPortConfig(serialPort, options) - 
            % User-facing serial port configuration method. Will interpret
            % char arrays to register writes.
            % inputs
            %   serialPort - the port to be configured
            %       0-3 for SDATA_IN0-3
            %       5-7 for SDATA_OUT0-3
            % outputs
            %   success - Set to true if the operation was successful
            arguments
                obj (1,1)
                serialPort                  (1,:) {mustBeInRange(serialPort,0,7)};
                options.frameClockSource    char {mustBeMember(options.frameClockSource,{'','Slave from CLK domain 0', 'Slave from CLK domain 1', 'Slave from CLK domain 2', 'Slave from CLK domain 3', 'LRCLK is master'})} = '';
                options.bitClockSource      char {mustBeMember(options.bitClockSource,{'','Slave from CLK domain 0', 'Slave from CLK domain 1', 'Slave from CLK domain 2', 'Slave from CLK domain 3', 'BCLK is master'})} = '';
                options.frameClockMode      char {mustBeMember(options.frameClockMode,{'','50/50 duty cycle clock', 'Pulse'})} = '';
                options.frameClockPolarity  char {mustBeMember(options.frameClockPolarity,{'','Negative', 'Positive'})} = '';
                options.bitClockPolarity    char {mustBeMember(options.bitClockPolarity,{'','Negative', 'Positive'})} = '';
                options.wordLength          char {mustBeMember(options.wordLength,{'','24 bits', '16 bits', '32 bits', 'Flexible TDM mode'})} = '';
                options.dataFormat          char {mustBeMember(options.dataFormat,{'','I2S - BCLK delay by 1', 'Left justified', 'Right justified 24-bit data (delay by 8)', 'Right justified 16-bit data (delay by 16)'})} = '';
                options.tdmMode             char {mustBeMember(options.tdmMode,{'','2 channels, 32 bit/channel', '4 channels, 32 bit/channel', '8 channels, 32 bit/channel', '16 channels, 32 bit/channel', '4 channels, 16 bit/channel', '2 channels, 16 bit/channel'})} = '';
                options.tristateEnabled     char {mustBeMember(options.tristateEnabled,{'','Drive every output channel', 'Tristate unused output channels'})} = '';
                options.clockGenerator      char {mustBeMember(options.clockGenerator,{'','Clock generator 1', 'Clock generator 2', 'Clock generator 3 (high precision)'})} = '';
                options.sampleRate          char {mustBeMember(options.sampleRate,{'','Fs/4', 'Fs/2', 'Fs', '2*Fs', '4*Fs'})} = '';
            end

            success = false;
            
            % Interpolate the user-readable parameter choice with its
            % corresponding binary from the ADAU1452 lookup table.
            if ~isempty(options.frameClockSource),  frameClockSource = uint16(str2double(obj.DeviceConstants.SPTFrameClockSourceTable.BinaryStr{options.frameClockSource}));    else, frameClockSource = []; end
            if ~isempty(options.bitClockSource),    bitClockSource = uint16(str2double(obj.DeviceConstants.SPTBitClockSourceTable.BinaryStr{options.bitClockSource}));          else, bitClockSource = []; end
            if ~isempty(options.frameClockMode),    frameClockMode = uint16(str2double(obj.DeviceConstants.SPTFrameClockModeTable.BinaryStr{options.frameClockMode}));          else, frameClockMode = []; end
            if ~isempty(options.frameClockPolarity),frameClockPolarity = uint16(str2double(obj.DeviceConstants.SPTFrameClockPolarityTable.BinaryStr{options.frameClockPolarity})); else, frameClockPolarity = []; end
            if ~isempty(options.bitClockPolarity),  bitClockPolarity = uint16(str2double(obj.DeviceConstants.SPTBitClockPolarityTable.BinaryStr{options.bitClockPolarity}));    else, bitClockPolarity = []; end
            if ~isempty(options.wordLength),        wordLength = uint16(str2double(obj.DeviceConstants.SPTWordLengthTable.BinaryStr{options.wordLength}));                      else, wordLength = []; end
            if ~isempty(options.dataFormat),        dataFormat = uint16(str2double(obj.DeviceConstants.SPTDataFormatTable.BinaryStr{options.dataFormat}));                      else, dataFormat = []; end
            if ~isempty(options.tdmMode),           tdmMode = uint16(str2double(obj.DeviceConstants.SPTTDMModeTable.BinaryStr{options.tdmMode}));                               else, tdmMode = []; end
            if ~isempty(options.tristateEnabled),   tristateEnabled = uint16(str2double(obj.DeviceConstants.SPTTristateEnabledTable.BinaryStr{options.tristateEnabled}));       else, tristateEnabled = []; end
            if ~isempty(options.clockGenerator),    clockGenerator = uint16(str2double(obj.DeviceConstants.SPTClockGeneratorTable.BinaryStr{options.clockGenerator}));          else, clockGenerator = []; end
            if ~isempty(options.sampleRate),        sampleRate = uint16(str2double(obj.DeviceConstants.SPTSampleRateTable.BinaryStr{options.sampleRate}));                      else, sampleRate = []; end

            success = setSerialPortConfig_registers(obj, serialPort, ...
                frameClockSource = frameClockSource,...
                bitClockSource = bitClockSource,...
                frameClockMode = frameClockMode,...
                frameClockPolarity = frameClockPolarity,...
                bitClockPolarity = bitClockPolarity,...
                wordLength = wordLength,...
                dataFormat = dataFormat,...
                tdmMode = tdmMode,...
                tristateEnabled = tristateEnabled,...
                clockGenerator = clockGenerator,...
                sampleRate = sampleRate);

            obj.SerialPortConfig = obj.getSerialPortConfig();
        end
    end % End Public Methods

    %% Private Methods
    methods (Access = public)
        [serialPortConfig] = getSerialPortConfig_registers(obj);
        [success] = setSerialPortConfig_registers(obj, serialPort, options);
        [response] = readADAU1452Register_aardvark(obj, address_uint16, readLength);
        [success] = writeADAU1452Register_aardvark(obj, address_uint16, value_uint16, verifyWrites);
    end
end