function [success] = writeADAU1452Register_aardvark(obj, address_uint16, value_uint16, verifyWrites)
    % writeADAU1452Register_aardvark 
    arguments
        obj (1,1)
        address_uint16  (1,1) {mustBeA(address_uint16, 'uint16')}
        value_uint16    (1,1) {mustBeA(value_uint16, 'uint16')}
        verifyWrites    (1,1) = false;
    end
    success = false;
    try
        % Unpack 16-bit address into vector of bytes
        addr_hex = [dec2hex(address_uint16, 4)];
        addr_bytes = zeros(1,length(addr_hex)/2, 'uint8');
        n_byte = 1;
        for i=1:2:length(addr_hex)
            addr_bytes(n_byte) = uint8(hex2dec(addr_hex(i:(i+1))));
            n_byte = n_byte + 1;
        end
        
        % Unpack 16-bit write value into vector of bytes
        val_hex = [dec2hex(value_uint16, 4)];
        val_bytes = zeros(1, length(val_hex)/2, 'uint8');
        n_byte = 1;
        for i=1:2:length(val_hex)
            val_bytes(n_byte) = uint8(hex2dec(val_hex(i:(i+1))));
            n_byte = n_byte + 1;
        end
        
        % Concatenate write load as byte vector
        data_load = [addr_bytes, val_bytes];
        write(obj.HWOBJ.ConnectionObject, data_load, 'uint8');
        success = true;
    catch ME
        rethorw(ME);
    end
end