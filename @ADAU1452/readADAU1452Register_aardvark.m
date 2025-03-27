function [response] = readADAU1452Register_aardvark(obj, address_uint16, readLength)
    % readADAU1452Register_aardvark(address_uint16, readLength) -
    % Writes a uint16 I2C message to the ADAU1452 via Aardvark.
    %   inputs:
    %       address_uint16 - uint16 address of the register to read
    %       readLength - length of message in bytes
    %   outputs:
    %       response - uint16 value of the register of interest
    arguments
        obj (1,1)
        address_uint16
        readLength
    end
    addr_hex = [dec2hex(address_uint16)];
    addr_bytes = zeros(1,length(addr_hex)/2, 'uint8');
    n_byte = 1;
    for i=1:2:length(addr_hex)
        addr_bytes(n_byte) = uint8(hex2dec(addr_hex(i:(i+1))));
        n_byte = n_byte + 1;
    end
    write(obj.HWOBJ.ConnectionObject, addr_bytes, 'uint8');
    data_bytes = read(obj.HWOBJ.ConnectionObject, readLength, 'uint8');
    data = uint16(0);
    data = bitor(data, uint16(bitshift(uint16(data_bytes(1)),8)));
    data = bitor(data, uint16(bitshift(uint16(data_bytes(2)),0)));
    response = data;
end