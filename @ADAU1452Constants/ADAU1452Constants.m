classdef ADAU1452Constants < handle
    % ADAU1452Constants Constants for ADAU1452 intermediary DSP chip on the
    % Nimbus platform board.
    % This class holds tables for various registers for the ADAU1452,
    % pulled from the ADAU1452 datasheet.
    % Written by Ben Kim
    properties
        %% Control Registers
        % Audio Signal Routing Registers
        ASRCInputSelectorRegisters
        ASRCOutputRateSelectorRegisters
        SerialOutputSourceRegisters
        SPDIFInputSourceRegisters
        % Serial Port Config Registers
        SerialPortControl0Registers
        SerialPortControl1Registers
        
        %% Lookup Tables
        % ASRC
        % Serial Port
        SPTFrameClockSourceTable
        SPTBitClockSourceTable
        SPTFrameClockModeTable
        SPTFrameClockPolarityTable
        SPTBitClockPolarityTable
        SPTWordLengthTable
        SPTDataFormatTable
        SPTTDMModeTable
        SPTTristateEnabledTable
        SPTClockGeneratorTable
        SPTSampleRateTable
    end
    
    methods
        function obj = ADAU1452Constants()
            %% Control Registers
            %% Audio Signal Routing Registers
            % ASRC Input Selector Register
            RegisterName = {'ASRC_INPUT0', 'ASRC_INPUT1', 'ASRC_INPUT2', 'ASRC_INPUT3', 'ASRC_INPUT4', 'ASRC_INPUT5', 'ASRC_INPUT6', 'ASRC_INPUT7'}';
            DataMask =          {0x00FF, 0x00FF, 0x00FF, 0x00FF, 0x00FF, 0x00FF, 0x00FF, 0x00FF}';
            RegisterAddress =   {0xF100, 0xF101, 0xF102, 0xF103, 0xF104, 0xF105, 0xF106, 0xF107}';
            obj.ASRCInputSelectorRegisters = table(DataMask,RegisterAddress,'RowName',RegisterName);
            % ASRC Output Rate Selector Register
            RegisterName = {'ASRC_OUT_RATE0', 'ASRC_OUT_RATE1', 'ASRC_OUT_RATE2', 'ASRC_OUT_RATE3', 'ASRC_OUT_RATE4', 'ASRC_OUT_RATE5', 'ASRC_OUT_RATE6', 'ASRC_OUT_RATE7'}';
            DataMask =          {0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F}';
            RegisterAddress =   {0xF140, 0xF141, 0xF142, 0xF143, 0xF144, 0xF145, 0xF146, 0xF147}';
            obj.ASRCOutputRateSelectorRegisters = table(DataMask,RegisterAddress,'RowName',RegisterName);
            % Source of Data for Serial Output Ports Register
            RegisterName = {'SOUT_SOURCE0', 'SOUT_SOURCE1', 'SOUT_SOURCE2', 'SOUT_SOURCE3', 'SOUT_SOURCE4', 'SOUT_SOURCE5', 'SOUT_SOURCE6', 'SOUT_SOURCE7', 'SOUT_SOURCE8', 'SOUT_SOURCE9', 'SOUT_SOURCE10', 'SOUT_SOURCE11', 'SOUT_SOURCE12', 'SOUT_SOURCE13', 'SOUT_SOURCE14', 'SOUT_SOURCE15', 'SOUT_SOURCE16', 'SOUT_SOURCE17', 'SOUT_SOURCE18', 'SOUT_SOURCE19', 'SOUT_SOURCE20', 'SOUT_SOURCE21', 'SOUT_SOURCE22', 'SOUT_SOURCE23'}';
            DataMask =          {0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F, 0x000F}';
            RegisterAddress =   {0xF180, 0xF181, 0xF182, 0xF183, 0xF184, 0xF185, 0xF186, 0xF187, 0xF188, 0xF189, 0xF18A, 0xF18B, 0xF18C, 0xF18D, 0xF18E, 0xF18F, 0xF190, 0xF191, 0xF192, 0xF193, 0xF194, 0xF195, 0xF196, 0xF197}';
            obj.SerialOutputSourceRegisters = table(DataMask,RegisterAddress,'RowName',RegisterName);
            % S/PDIF Transmitter Data Selector Register
            RegisterName = {'SPDIFTX_INPUT'}';
            DataMask =          {0x0003}';
            RegisterAddress =   {0xF1C0}';
            obj.SPDIFInputSourceRegisters = table(DataMask,RegisterAddress,'RowName',RegisterName);

            %% Serial Port Config Registers
            % Serial Port Control 0 Register (SDATA_INx 0-3, SDATA_OUTx 0-3)
            RegisterName = {'SERIAL_BYTE_0_0', 'SERIAL_BYTE_1_0', 'SERIAL_BYTE_2_0', 'SERIAL_BYTE_3_0', 'SERIAL_BYTE_4_0', 'SERIAL_BYTE_5_0', 'SERIAL_BYTE_6_0', 'SERIAL_BYTE_7_0'}';
            DataMask =          {0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF}';
            RegisterAddress =   {0xF200, 0xF204, 0xF208, 0xF20C, 0xF210, 0xF214, 0xF218, 0xF21C}';
            obj.SerialPortControl0Registers = table(DataMask,RegisterAddress,'RowName',RegisterName);  
            % Serial Port Control 1 Register (SDATA_INx 0-3, SDATA_OUTx 0-3)
            RegisterName = {'SERIAL_BYTE_0_1', 'SERIAL_BYTE_1_1', 'SERIAL_BYTE_2_1', 'SERIAL_BYTE_3_1', 'SERIAL_BYTE_4_1', 'SERIAL_BYTE_5_1', 'SERIAL_BYTE_6_1', 'SERIAL_BYTE_7_1'}';
            DataMask =          {0x003F, 0x003F, 0x003F, 0x003F, 0x003F, 0x003F, 0x003F, 0x003F}';
            RegisterAddress =   {0xF201, 0xF205, 0xF209, 0xF20D, 0xF211, 0xF215, 0xF219, 0xF21D}';
            obj.SerialPortControl1Registers = table(DataMask,RegisterAddress,'RowName',RegisterName);

            %% Serial Port (SPT) Lookup Tables
            sptFrameClockSourceBinary = [0b000, 0b001, 0b010, 0b011, 0b100]';
            sptFrameClockSource = {'Slave from CLK domain 0', 'Slave from CLK domain 1', 'Slave from CLK domain 2', 'Slave from CLK domain 3', 'LRCLK is master'}';    
            obj.SPTFrameClockSourceTable = table(sptFrameClockSourceBinary, sptFrameClockSource, 'VariableNames', ["Binary", "Value"]);
            
            sptBitClockSourceBinary = [0b000, 0b001, 0b010, 0b011, 0b100]';
            sptBitClockSource = {'Slave from CLK domain 0', 'Slave from CLK domain 1', 'Slave from CLK domain 2', 'Slave from CLK domain 3', 'BCLK is master'}';    
            obj.SPTBitClockSourceTable = table(sptBitClockSourceBinary, sptBitClockSource, 'VariableNames', ["Binary", "Value"]);
            
            sptFrameClockModeBinary = [0b0, 0b1]';
            sptFrameClockMode = {'50/50 duty cycle clock', 'Pulse'}';
            obj.SPTFrameClockModeTable = table(sptFrameClockModeBinary, sptFrameClockMode, 'VariableNames', ["Binary", "Value"]);
            
            sptFrameClockPolarityBinary = [0b0, 0b1]';
            sptFrameClockPolarity = {'Negative', 'Positive'}';
            obj.SPTFrameClockPolarityTable = table(sptFrameClockPolarityBinary, sptFrameClockPolarity, 'VariableNames', ["Binary", "Value"]);
            
            sptBitClockPolarityBinary = [0b0, 0b1]';
            sptBitClockPolarity = {'Negative', 'Positive'}';
            obj.SPTBitClockPolarityTable = table(sptBitClockPolarityBinary, sptBitClockPolarity, 'VariableNames', ["Binary", "Value"]);
            
            sptWordLengthBinary = [0b00, 0b01, 0b10, 0b11]';
            sptWordLength = {'24 bits', '16 bits', '32 bits', 'Flexible TDM mode'}';
            obj.SPTWordLengthTable = table(sptWordLengthBinary, sptWordLength, 'VariableNames', ["Binary", "Value"]);
            
            sptDataFormatBinary = [0b00, 0b01, 0b10, 0b11]';
            sptDataFormat = {'I2S - BCLK delay by 1', 'Left justified', 'Right justified 24-bit data (delay by 8)', 'Right justified 16-bit data (delay by 16)'}';
            obj.SPTDataFormatTable = table(sptDataFormatBinary, sptDataFormat, 'VariableNames', ["Binary", "Value"]);
            
            sptTDMModeBinary = [0b000, 0b001, 0b010, 0b011, 0b100, 0b101]';
            sptTDMMode = {'2 channels, 32 bit/channel', '4 channels, 32 bit/channel', '8 channels, 32 bit/channel', '16 channels, 32 bit/channel', '4 channels, 16 bit/channel', '2 channels, 16 bit/channel'}';
            obj.SPTTDMModeTable = table(sptTDMModeBinary, sptTDMMode, 'VariableNames', ["Binary", "Value"]); 
            
            sptTristateEnabledBinary = [0b0, 0b1]';
            sptTristateEnabled = {'Drive every output channel', 'Tristate unused output channels'}';
            obj.SPTTristateEnabledTable = table(sptTristateEnabledBinary, sptTristateEnabled, 'VariableNames', ["Binary", "Value"]);
            
            sptClockGeneratorBinary = [0b00, 0b01, 0b10]';
            sptClockGenerator = {'Clock generator 1', 'Clock generator 2', 'Clock generator 3 (high precision)'}';
            obj.SPTClockGeneratorTable = table(sptClockGeneratorBinary, sptClockGenerator, 'VariableNames', ["Binary", "Value"]);
            
            sptSampleRateBinary = [0b000, 0b001, 0b010, 0b011, 0b100]';
            sptSampleRate = {'Fs/4', 'Fs/2', 'Fs', '2*Fs', '4*Fs'}';
            obj.SPTSampleRateTable = table(sptSampleRateBinary, sptSampleRate, 'VariableNames', ["Binary", "Value"]);
        end
    end
end