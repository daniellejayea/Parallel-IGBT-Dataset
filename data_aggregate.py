#Python code for data aggregation
import pandas as pd
import glob
import os

def process_sensor_data():
    # Define folder names
    folder_mda = "MDA"
    folder_waverunner = "Waverunner"
    output_folder = "Sensor data" #the csv of the combined files will be saved here
    output_file = os.path.join(output_folder, "combined_sensors.csv")

    try:
        # Create the "Sensor data" folder if it does not exist
        if not os.path.exists(output_folder):
            os.makedirs(output_folder)
            print(f"Initialized folder: {output_folder}")

        # Identify file paths from both source folders
        mda_files = glob.glob(os.path.join(folder_mda, "*.csv"))
        waverunner_files = glob.glob(os.path.join(folder_waverunner, "*.csv"))
        all_files = mda_files + waverunner_files

        # Check if files were found
        if not all_files:
            print("Failed to combine: No CSV files found in 'MDA' or 'Waverunner'.")
            return

        # Read and combine all dataframes
        df_list = [pd.read_csv(f) for f in all_files]
        combined_df = pd.concat(df_list, ignore_index=True)

        # Save to the new folder
        combined_df.to_csv(output_file, index=False)
        
        print("The files are combined successfully")

    except Exception as e:
        print(f"Failed to combine: {e}")

if __name__ == "__main__":
    process_sensor_data()
