import pandas as pd
import geopandas as gpd
import fiona
from pathlib import Path

# Enable KML driver
fiona.drvsupport.supported_drivers['KML'] = 'rw'
fiona.drvsupport.supported_drivers['LIBKML'] = 'rw'

# Path to KMZ file
kmz_path = "ANAGNI_NUMERAZIONE_CIVICA.kmz"
# kmz_path = "ANAGNI_STRADARIO_COMUNALE.kmz"

# List to store all dataframes
all_dataframes = []

# List all layers in the KMZ file
layers = fiona.listlayers(kmz_path)

# Read each layer and append to list
for index, layer in enumerate(layers):
    print(f"Reading layer: {layer}")

    # if layer != '101 - VIA VITTORIO EMANUELE SECONDO':
    #     print(f"Skipping layer: {layer} (not the target layer)")
    #     continue

    if layer.split('-')[0].strip() == layer:
        print(f"Skipping layer: {layer} (does not match expected format)")
        continue

    gdf = gpd.read_file(kmz_path, driver='LIBKML', layer=layer)

    import ipdb; ipdb.set_trace()

    # get toponimo stripping toponimo index
    toponimo_index, toponimo = layer.split('-')
    toponimo = toponimo.strip()

    # Add layer name as a column for reference
    gdf['Toponimo'] = toponimo
    all_dataframes.append(gdf)

    # if index > 10:  # Limit to first 20 layers for testing
    #     print("Reached layer limit for testing. Stopping.")
    #     break

# Concatenate all dataframes into one
combined_gdf = gpd.GeoDataFrame(pd.concat(all_dataframes, ignore_index=True))

# Extract coordinates (longitude, latitude)
combined_gdf['longitude'] = combined_gdf.geometry.x
combined_gdf['latitude'] = combined_gdf.geometry.y

# Select relevant columns (adjust column names based on your KMZ structure)
# Common fields might be 'Name', 'Description', or similar
# You may need to inspect the data first to find the street name column
result_df = combined_gdf[['Name', 'Toponimo', 'longitude', 'latitude', 'geometry']].copy()

# Rename columns for clarity
result_df.columns = ['Civico', 'Toponimo', 'Longitude', 'Latitude', 'geometry']

#save to geoparquet
output_path = Path("anagni_civici.parquet")
result_df.to_parquet(output_path, index=False)



print(f"Total records: {len(result_df)}")
print(result_df.head())