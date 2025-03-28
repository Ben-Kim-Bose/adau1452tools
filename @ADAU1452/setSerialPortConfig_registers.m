function [success] = setSerialPortConfig_registers(obj, serialPort, options)
    % setSerialPortConfig_registers(obj, serialPort, options) - 
    % Configures the serial port selected by serialPort with the settings
    % specified by arguments.
    % inputs
    %   serialPort - the port to be configured
    %       0-3 for SDATA_IN0-3
    %       5-7 for SDATA_OUT0-3
    % optional inputs (AS NUMBERS)
    %   frameClockSource - LRCLK pin selection
    %       0: Slave from CLK domain 0
    %       1: Slave from CLK domain 1
    %       2: Slave from CLK domain 2
    %       3: Slave from CLK domain 3
    %       4: LRCLK is master
    %   bitClockSource -  BCLK pin selection
    %       0: Slave from CLK domain 0
    %       1: Slave from CLK domain 1
    %       2: Slave from CLK domain 2
    %       3: Slave from CLK domain 3
    %       4: BCLK is master
    %   frameClockMode - LRCLK waveform type
    %       0: 50/50 duty cycle clock
    %       1: Pulse
    %   frameClockPolarity - LRCLK polarity
    %       0: Negative (falling edge)
    %       1: Positive (rising edge)
    %   bitClockPolarity - BCLK polarity
    %       0: Negative (falling edge)
    %       1: Positive (rising edge)
    %   wordLength - Audio data-word length
    %       0: 24 bits
    %       1: 16 bits
    %       2: 32 bits
    %       3: Flexible TDM mode
    %   dataFormat - MSB position
    %       0: I2S - BCLK delay by 1
    %       1: Left justified
    %       2: Right justified 24-bit data (delay by 8)
    %       3: Right justified 16-bit data (delay by 16)
    %   tdmMode - Channels per frame and BCLK cycles per channel
    %       0: 2 channels, 32 bit/channel
    %       1: 4 channels, 32 bit/channel
    %       2: 8 channels, 32 bit/channel
    %       3: 16 channels, 32 bit/channel
    %       4: 4 channels, 16 bit/channel
    %       5: 2 channels, 16 bit/channel
    %   tristateEnabled - Tristate unused output channels
    %       0: Drive every output channel
    %       1: Tristate unused output channels
    %   clockGenerator - Selects the clock generator to use for this spt
    %       0: Clock generator 1
    %       1: Clock generator 2
    %       2: Clock generator 3 (high precision)
    %   sampleRate - Sample Rate
    %       0: Fs/4
    %       1: Fs/2
    %       2: Fs
    %       3: 2*Fs
    %       4: 4*Fs
    % outputs
    %   success - Set to true if the operation was successful
    
    arguments
        obj (1,1)
        serialPort                  (1,1) {mustBeInRange(serialPort,0,7)};
        options.frameClockSource    = [];
        options.bitClockSource      = [];
        options.frameClockMode      = [];
        options.frameClockPolarity  = [];
        options.bitClockPolarity    = [];
        options.wordLength          = [];
        options.dataFormat          = [];
        options.tdmMode             = [];
        options.tristateEnabled     = [];
        options.clockGenerator      = [];
        options.sampleRate          = [];
    end
    success = false;
    % Serial Port Control Register info pulled from ADAU1452Constants 
    % Get the pair of control register addresses for the port specified.
    ctrl0_reg_name = sprintf('SERIAL_BYTE_%d_0', serialPort);
    ctrl1_reg_name = sprintf('SERIAL_BYTE_%d_1', serialPort);
    ctrl0_reg_addr = obj.DeviceConstants.SerialPortControl0Registers.RegisterAddress{ctrl0_reg_name};
    ctrl1_reg_addr = obj.DeviceConstants.SerialPortControl1Registers.RegisterAddress{ctrl1_reg_name};

    ctrl0_reg_original = obj.readRegister(ctrl0_reg_addr);
    ctrl1_reg_original = obj.readRegister(ctrl1_reg_addr);

    mask = [...
        uint16(bin2dec('1110000000000000')),...
        uint16(bin2dec('0001110000000000')),...
        uint16(bin2dec('0000001000000000')),...
        uint16(bin2dec('0000000100000000')),...
        uint16(bin2dec('0000000010000000')),...
        uint16(bin2dec('0000000001100000')),...
        uint16(bin2dec('0000000000011000')),...
        uint16(bin2dec('0000000000000111')),...
        uint16(bin2dec('0000000000100000')),...
        uint16(bin2dec('0000000000011000')),...
        uint16(bin2dec('0000000000000111'))...
    ];
    
    % Prepare write loads
    % If control setting is unspecified, write the original bits so setting is unchanged.
    ctrl0_reg_new = ctrl0_reg_original;
    if ~isempty(options.frameClockSource),  ctrl0_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(1), 'uint16')), bitshift(options.frameClockSource, 13, 'uint16'), 'uint16');   end % set frameClockSource
    if ~isempty(options.bitClockSource),    ctrl0_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(2), 'uint16')), bitshift(options.bitClockSource, 10, 'uint16'), 'uint16');     end % set bitClockSource
    if ~isempty(options.frameClockMode),    ctrl0_reg_new = bitset(ctrl0_reg_new, 10, options.frameClockMode, 'uint16');                        end % set frameClockMode
    if ~isempty(options.frameClockPolarity),ctrl0_reg_new = bitset(ctrl0_reg_new, 9, options.frameClockPolarity, 'uint16');                     end % set frameClockPolarity
    if ~isempty(options.bitClockPolarity),  ctrl0_reg_new = bitset(ctrl0_reg_new, 8, options.bitClockPolarity, 'uint16');                       end % set bitClockPolarity
    if ~isempty(options.wordLength),        ctrl0_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(6), 'uint16')), bitshift(options.wordLength, 5, 'uint16'), 'uint16');          end % set wordLength
    if ~isempty(options.dataFormat),        ctrl0_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(7), 'uint16')), bitshift(options.dataFormat, 3, 'uint16'), 'uint16');          end % set dataFormat
    if ~isempty(options.tdmMode),           ctrl0_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(8), 'uint16')), bitshift(options.tdmMode, 0, 'uint16'), 'uint16');             end % set tdmMode

    ctrl1_reg_new = ctrl1_reg_original;
    if ~isempty(options.tristateEnabled),   ctrl1_reg_new = bitset(ctrl1_reg_new, 6, options.tristateEnabled, 'uint16');                        end % set tristateEnabled
    if ~isempty(options.clockGenerator),    ctrl1_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(10), 'uint16')), bitshift(options.clockGenerator, 3, 'uint16'), 'uint16');      end % set clockGenerator
    if ~isempty(options.sampleRate),        ctrl1_reg_new = bitor(bitand(ctrl0_reg_new, bitcmp(mask(11), 'uint16')), bitshift(options.sampleRate, 0, 'uint16'), 'uint16');          end % set sampleRate

    try
        obj.writeRegister(ctrl0_reg_addr, ctrl0_reg_new);
        obj.writeRegister(ctrl1_reg_addr, ctrl1_reg_new);
        success = true;
    catch ME
        rethrow(ME);
    end
end