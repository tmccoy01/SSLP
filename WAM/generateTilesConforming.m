function tiles = generateTilesConforming(CONST)

    % Use the central radar as a reference point for the tiles
    centerPoint = Radar("CLT");
    centerPoint.Range = 200;
    [latRing, lonRing] = centerPoint.drawRing();
    [latMin, latMax] = bounds(latRing);
    [lonMin, lonMax] = bounds(lonRing);
    % Convert the points into a tile structure defined in the constants
    % file
    calculateCenter = @(min, max) (min:CONST.TILE_WIDTH_DEG:max) + (CONST.TILE_WIDTH_DEG/2);
    latCenterPoints = calculateCenter(latMin, latMax);
    lonCenterPoints = calculateCenter(lonMin, lonMax);
    [meshLons, meshLats] = meshgrid(lonCenterPoints, latCenterPoints);
    latVector = reshape(meshLats, 1, numel(meshLats));
    lonVector = reshape(meshLons, 1, numel(meshLons));
    altVector = zeros(size(lonVector));
    centerPoints = [latVector' lonVector' altVector'];
    % Create a 3D grid of tiles. These represent the height above the
    % geoid, so the tiles will be stacked on the curvilinear surface of the
    % geoid.
    minAlt = CONST.FLOOR_FEET * CONST.FEET_TO_METERS;
    maxAlt = CONST.CEILING_FEET * CONST.FEET_TO_METERS;
    altCenters = minAlt:CONST.TILE_HEIGHT_METERS:maxAlt;
    structTemplate = struct( ...
        "centerLat", [], ...
        "centerLon", [], ...
        "tile_length", [], ...
        "tile_width", [], ...
        "tile_height_feet", [], ...
        "radios", [], ...
        "radio_floor_height_meteres", [], ...
        "alt_agl_feet", [], ...
        'gdop', [] ...
    );
    tiles = repmat(structTemplate, size(centerPoints, 1), numel(altCenters));
    
    % Compute the heights of tiles based on the terrain/floor data
    [mTiles, nTiles] = size(tiles);
    numRadios = numel(radios.RSID);
    interpTerrainHeightMeters = zeros(mTiles, nTiles);
    interpFloorHeightMeters = zeros(mTiles, nTiles);
    for iRadio = 1:numRadios
        currentRadio = Radio(radios.RSID(iRadio));
        interpTerrainHeightMeters(:, iRadio) = ...
            interp2( currentRadio.Longitude, currentRadio.Latitude, currentRadio.Terrain, ...
                centerPoints(:, 2), centerPoints(:, 1) ...
            );
        interpFloorHeightMeters(:, iRadio) = ...
            interp2( currentRadio.Longitude, currentRadio.Latitude, currentRadio.Floor, ...
                centerPoints(:, 2), centerPoints(:, 1) ...
            );
    end
    interpTerrainHeightMeters = min(interpTerrainHeightMeters, [], 2);
    interpFloorHeightMeters = min(interpFloorHeightMeters, [], 2);
    interpMixedHeights = [interpTerrainHeightMeters interpFloorHeightMeters];
    interpMixedHeights = max(interpMixedHeights, [], 2);

end