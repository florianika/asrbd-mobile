#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF_6AFRtjvaALa3zsDR6McH8ODhp0MCPWL6ISz0xo-C978IMHtY7qEcw6ky1akvhaqSmgXqmLgeDdII4W65Lz30F_y4f4CzoV0l-S0TZFdaN1wPFxfKUChIggJdKHLFGuKW1lVqRQyReafJ4FZYxIWaUNcg2B4Rd-M-2Jwy9kx0376OFkYaBLGJamzvc1y1e_jy7zKfjLFBxgxw_zZw7Cj3vHAtsTMDznARMLRJFo1gKbbktIRiXBD6SxZZ7l0byV2ascXqz8PDmwcIjD09dKac2fzTW_2gyrm0Z16BDV3Owf_WZJpbKt9JLCJxzfWzXHNzinSVym46NEePI91Xc70u_dAvFfis4zGTH65n6BV8ocS-2TbuldWi_4KBy5k46YMSBO5x_xKi4cFJApLET8u_reRkvQK_EZuwslCUVNi1jBNtw5BmcNkV5ShTwuyzm-cJFjOJEGCgCiD3jduSUn95c7oPXYUiQlmizbHDx72vXNjWKCy5wbNJCZKTP-1hzxt4KwfYpRbF6RgPVFlE9ulJfEgrA_Be1PS0btbsG0ma6jFREcHsSZ_DlKMW0vz2VRle7oOEeDmiL_DZ61duTjiyt3T3j8w63EvwbQvmIHUlK9JVM5N4WH03_ntxNs3ZdeWZtAil5XwMKJ_mWj0b6gF_rUHDQEwXQha4v_7N2hbw0pOXhZSxtnjfQBRsfGQTp7a-X6vsAnisInCx_etD0rSPbKF09FBRnf3FKAkywT-5MWR4B4ptV9EpBBvSVjtsL_72wwg_9EzcN1kTMJjZu84MlB_SuVdC-8smQVjYpPMwnCUMhGF9aAjyDLZgrhL8-evVn5kwyZv522UEwcc1mtqAq00nJNDoTEUe9NNzJaoux_oOjRGDlOCTk-Q7A56owxXd1N5Nhd8cN2nLwmd3eVJ8hFcLEswDLeRnBkJV6xyMK0QsbyrmWZ2lrHNDySz76wuHW_lEh5Zb7ZyrrcixQ2sTKYCZzRQ6oI1kEBO5q2Yqfl4K8f1kk0zGsRNPZYtVsZPBYZOoKEWAAm8CfsU8zFfmu1mCCVncyj92_NChrnCDD-SamLjq7uk5JCOknsqy6Y2b7-b179L9C6nT4SJCGVQDqk9WbITSnkXiJpNE5SNJqI3kYhb18ihjbhPUL6dDY382WD7xVPTaJTAWdCofJxfRISU_ASP0NJi-vXmq_PaHsTU5Usl6nm6qPn3M2StvAA2Uy2jLMjL2z_8U9rbt7nm_O4d6NWUlFjXaZTX0CpYyALr8p7By6TBkOR-1P_x1BXKTUp7rZWGyfgp-8o_fzGQtDuMKwz0mSslO19Vqv5j0UTb8MvxnZpg3_ZyZCiV04RGzTiR-JxN-01wnoohL9s3TlycX6yUlYmxFxbo2dXSo2KurLgWxvyOoyRZKUEWF3F7eESjBbBnqTfOz4VUQ_FPi0';

# Path to the file you want to upload
file_path = '/workspaces/asrbd-mobile/build/app/outputs/flutter-apk/app-release.apk'

# Dropbox destination path (this is the path where the file will be uploaded to)
dropbox_destination_path = '/apk/app-release.apk'

# Create a Dropbox client instance
dbx = dropbox.Dropbox(ACCESS_TOKEN)

try:
    # Check if local file exists first
    import os
    if not os.path.exists(file_path):
        print(f"❌ Error: Local file not found at {file_path}")
        print(f"Current working directory: {os.getcwd()}")
        print("Please make sure the APK was built successfully.")
        exit(1)
    
    print(f"✅ Local file found: {file_path}")
    file_size = os.path.getsize(file_path)
    print(f"File size: {file_size / (1024*1024):.2f} MB")
    
    # Check if the file exists in Dropbox
    try:
        dbx.files_get_metadata(dropbox_destination_path)
        print(f"File exists at {dropbox_destination_path}. Deleting existing file...")
        
        # Delete the existing file
        dbx.files_delete_v2(dropbox_destination_path)
        print("Existing file deleted successfully.")
        
    except ApiError as e:
        # If the file doesn't exist, the API will raise an exception
        error_summary = str(e.error)
        if 'not_found' in error_summary.lower() or 'path_lookup/not_found' in error_summary:
            print(f"No existing file found at {dropbox_destination_path}. Proceeding with upload...")
        else:
            # Re-raise if it's a different kind of error
            print(f"Unexpected error while checking file existence: {e}")
            raise e

    # Open the file you want to upload
    print("Reading local file for upload...")
    with open(file_path, "rb") as f:
        file_data = f.read()
    
    print(f"Uploading {len(file_data)} bytes to Dropbox...")
    # Upload the file to Dropbox
    dbx.files_upload(file_data, dropbox_destination_path)

    print(f"File uploaded successfully to {dropbox_destination_path}")

except FileNotFoundError:
    print(f"❌ Error: Local file not found at {file_path}")
    exit(1)
except ApiError as e:
    print(f"❌ Dropbox API error: {e}")
    exit(1)
except Exception as e:
    print(f"❌ An unexpected error occurred: {e}")
    import traceback
    traceback.print_exc()
    exit(1)
