function main(location_name)
%MAIN Main script to run WAM analysis for the SSLP effort.
%   Detailed explanation goes here

    arguments
        location_name (1,1) string
    end

    CONST = loadConstants();
    radios = getRadios(location_name);
    tiles = generateTilesConforming(radio, CONST)
end