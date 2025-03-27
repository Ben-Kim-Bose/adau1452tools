function [serialPortConfig] = getSerialPortConfig_registers(obj)
    %GETSERIALPORTCONFIG_REGISTERS 
    % Serial Port Control Register info pulled from ADAU1452Constants 
    sptCtrl0Regs = {'SERIAL_BYTE_0_0', 'SERIAL_BYTE_1_0', 'SERIAL_BYTE_2_0', 'SERIAL_BYTE_3_0', 'SERIAL_BYTE_4_0', 'SERIAL_BYTE_5_0', 'SERIAL_BYTE_6_0', 'SERIAL_BYTE_7_0'};
    sptCtrl0Regs_addr = [obj.DeviceConstants.SerialPortControl0Registers.RegisterAddress{sptCtrl0Regs}];
    sptCtrl0Regs_mask = [obj.DeviceConstants.SerialPortControl0Registers.DataMask{sptCtrl0Regs}];
    sptCtrl1Regs = {'SERIAL_BYTE_0_1', 'SERIAL_BYTE_1_1', 'SERIAL_BYTE_2_1', 'SERIAL_BYTE_3_1', 'SERIAL_BYTE_4_1', 'SERIAL_BYTE_5_1', 'SERIAL_BYTE_6_1', 'SERIAL_BYTE_7_1'};
    sptCtrl1Regs_addr = [obj.DeviceConstants.SerialPortControl1Registers.RegisterAddress{sptCtrl1Regs}];
    sptCtrl1Regs_mask = [obj.DeviceConstants.SerialPortControl1Registers.DataMask{sptCtrl1Regs}];
    % Concatenate all names
    reg_names = [sptCtrl0Regs, sptCtrl1Regs];
    % Contains human-readable config structs
    reg_data = cell(1, length(reg_names));

    for i=1:length(reg_names)/2
        ctrl0_value_unmasked = obj.readRegister(sptCtrl0Regs_addr(i));
        ctrl0_value = bitand(ctrl0_value_unmasked, sptCtrl0Regs_mask(i));
        ctrl1_value_unmasked = obj.readRegister(sptCtrl1Regs_addr(i));
        ctrl1_value = bitand(ctrl1_value_unmasked, sptCtrl1Regs_mask(i));
        reg_data{i} = local_decodeCTRLReg(ctrl0_value, ctrl1_value);
    end
    
    %Concatenate structs
    serialPortConfig.SDATA_IN0 = reg_data{1};
    serialPortConfig.SDATA_IN1 = reg_data{2};
    serialPortConfig.SDATA_IN2 = reg_data{3};
    serialPortConfig.SDATA_IN3 = reg_data{4};
    serialPortConfig.SDATA_OUT0 = reg_data{5};
    serialPortConfig.SDATA_OUT1 = reg_data{6};
    serialPortConfig.SDATA_OUT2 = reg_data{7};
    serialPortConfig.SDATA_OUT3 = reg_data{8};
    
    function [resultStruct] = local_decodeCTRLReg(ctrl0_reg, ctrl1_reg)
        device_constants = ADAU1452Constants();
        frameClockSourceValues  = device_constants.SPTFrameClockSourceTable.Value;
        bitClockSourceValues    = device_constants.SPTBitClockSourceTable.Value;
        frameClockModeValues    = device_constants.SPTFrameClockModeTable.Value;
        frameClockPolarityValues = device_constants.SPTFrameClockPolarityTable.Value;
        bitClockPolarityValues  = device_constants.SPTBitClockPolarityTable.Value;
        wordLengthValues        = device_constants.SPTWordLengthTable.Value;
        dataFormatValues        = device_constants.SPTDataFormatTable.Value;
        tdmModeValues           = device_constants.SPTTDMModeTable.Value;
        tristateEnabledValues   = device_constants.SPTTristateEnabledTable.Value;
        clockGeneratorValues    = device_constants.SPTClockGeneratorTable.Value;
        sampleRateValues        = device_constants.SPTSampleRateTable.Value;
        
        % Frame Clock Source
        frameClockSource = polyval(bitget(ctrl0_reg, 16:-1:14), 2);
        frameClockSource_str = frameClockSourceValues(frameClockSource+1);

        % Bit Clock Source
        bitClockSource = polyval(bitget(ctrl0_reg, 13:-1:11), 2);
        bitClockSource_str = bitClockSourceValues(bitClockSource+1);
        
        % Frame Clock Mode
        frameClockMode = bitget(ctrl0_reg, 10);
        frameClockMode_str = frameClockModeValues(frameClockMode+1);

        % Frame Clock Polarity
        frameClockPolarity = bitget(ctrl0_reg, 9);
        frameClockPolarity_str = frameClockPolarityValues(frameClockPolarity+1);

        % Bit Clock Polarity
        bitClockPolarity = bitget(ctrl0_reg, 8);
        bitClockPolarity_str = bitClockPolarityValues(bitClockPolarity+1);

        % Word Length
        wordLength = polyval(bitget(ctrl0_reg, 7:-1:6), 2);
        wordLength_str = wordLengthValues(wordLength+1);

        % Data Format
        dataFormat = polyval(bitget(ctrl0_reg, 5:-1:4), 2);
        dataFormat_str = dataFormatValues(dataFormat+1);

        % TDM Mode
        tdmMode = polyval(bitget(ctrl0_reg, 3:-1:1), 2);
        tdmMode_str = tdmModeValues(tdmMode+1);

        % Tristate Enabled
        tristateEnabled = bitget(ctrl1_reg, 6);
        tristateEnabled_str = tristateEnabledValues(tristateEnabled+1);
        
        % Clock Generator
        clockGenerator = polyval(bitget(ctrl1_reg, 5:-1:4), 2);
        clockGenerator_str = clockGeneratorValues(clockGenerator+1);

        % Sample Rate
        sampleRate = polyval(bitget(ctrl1_reg, 3:-1:1), 2);
        sampleRate_str = sampleRateValues(sampleRate+1);

        resultStruct.frameClockSource = frameClockSource_str;
        resultStruct.bitClockSource = bitClockSource_str;
        resultStruct.frameClockMode = frameClockMode_str;
        resultStruct.frameClockPolarity = frameClockPolarity_str;
        resultStruct.bitClockPolarity = bitClockPolarity_str;
        resultStruct.wordLength = wordLength_str;
        resultStruct.dataFormat = dataFormat_str;
        resultStruct.tdmMode = tdmMode_str;
        resultStruct.tristateEnabled = tristateEnabled_str;
        resultStruct.clockGenerator = clockGenerator_str;
        resultStruct.sampleRate = sampleRate_str;
    end
end