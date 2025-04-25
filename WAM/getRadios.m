function [radio_struct] = getRadios(radios, location)
%GET_RADIOS get a list of radios from a given location
%   Extract a nx4 [radio_id, lat, lon, alt] listing of radios from the 
%   given input location

    arguments
        radios (1,1) struct
        location (1,1) string
    end

    radio_csv = fullfile("WAM", "radio_locations.csv");
    opts = detectImportOptions(radio_csv);
    opts.DataLines = [7, inf];
    opts.VariableNamesLine = 7;
    radioData = readtable(radio_csv, opts);
    idx = strcmp(radioData.(location), "O");
    radioTable = radioData(idx, :);
    alt = radioTable.SiteElevation_MSL_ + radioTable.AntennaHeight_AGL_;
    radio_struct = struct( ...
        "RSID", string(radioTable.RSID), ...
        "LID", radioTable.LocID, ...
        "Lat", radioTable.Latitude_Degrees_, ...
        "Lon", radioTable.Longitude_Degrees_, ...
        "Alt", alt ...
    );

end