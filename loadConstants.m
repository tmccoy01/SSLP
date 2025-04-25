function CONST = loadConstants()
% LOADCONSTANTS Load in the user constants for the project
%

    CONST = struct();
    %% Conversion Factors
    CONST.NM_TO_METERS = 1852;
    CONST.METERS_TO_NM = 1/CONST.NM_TO_METERS;
    CONST.METERS_TO_FEET = 3.2808399;
    CONST.FEET_TO_METERS = 1/CONST.METERS_TO_FEET;

    %% Tile Properties
    CONST.TILE_HEIGHT_METERS = 500*CONST.FEET_TO_METERS;
    CONST.TILE_WIDTH_DEG = 0.1;
    CONST.TILE_LENGTH_DEG = 0.1;
    CONST.FLOOR_FEET = 500;
    CONST.CEILING_FEET = 15000;
end