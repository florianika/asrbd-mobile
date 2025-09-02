#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF9Eyyuy9PXXuBD4TulaxZe9PWxnZ7tqi1_VLrQIPpMRBw43AceIc3FDE5bTgTAQpVOg8qlDOFCP_7HXulYM4crE1BSNo29O7x0kOwl-PyzL_6Q1SFv3GS9j0v1vHsl9lSbm8w2uNb_FeqhdC9lu1gsDrBJg1v6DFhPPRNw_YoMDkw10xouIKW2PhtY2qjiaHJCTb_P9zf1Mde9lhKGS8-AUd0-cMjSFJB1pqYDllvmvHBKB4g2dQSY_PYZRldacfDLSBAWbrUWXKj_vjqiaXCHtylXAhkRK66scvvdzM1qq4CHEDvCauf3pRNTJ5pxX8KKY4dNb5AVIIQbYbYmmS6b7CrdbTulJ0U-CPfsC3vMllWqfH6mJXQc5zDIzVWl4jXRDJF31pc0JK_xBOGHmnrACXohtoZ1Otx6L8lNGffB7ONWv6hIcTv1JfII0IG7LQ0OPGdA3U77HMe9ZdrOa996WQJkpwY8UQDsqcGbeoB10CvQVqLXHAWudjAOa2bCXEzcnsqdAGe_PKXs8RIuAgu3TiadvQ4_WniAE9XWlSBYO2D7RdtJ5vxXwKJ3sBpeKNDGSGCd1XjOCLfwDxTxvwy_-Z6AtSftJhDPYp3B3isZFEHbFyAybdwW1ZTnp-UPGxL5CItkXRP8x_dVvGlqmQNNX-XX6_ug44rA4jH4lrka_WUwxXn9m-z4s7I5pSGgl_OO-hnMMaKJU_EvF6tmxjQ6Omo5x7TowVOfy-3_wNbfpV7MfgOMX6r5NsYIH4q1IGOevFcX1kzSWentKBh9jQE30OGwQCW5vjd2LMaQHuEnXLknrvg__uVuC6gme_eN8X8IowPWqVLA8cDQREutxK1muiE3P-_WTLmpTJumslKRJIifKMdxcBx4qH2uummj9B3NAGCFvFo3fvddfEQQH2OWbVHukex8ThlboQwlXpFW14OIhLyGcyXZA_CO2yr48_g8xdL2EoQWf1HjeYNVB9qPBgQ6XKjEp7_vTrcKECD0kqBsu5OWvU07pmVhLo9nhYNtrm06lkhv6WRqunWlK5-VnhlWy0rDYuEFlX0Mi-jaFByyA1LtkEm_Tgnqu2KstMw9_jmPe-yNggXy-4jPKqJR_4Oc5t76j-79uLnWgIy_nS5A-wBWXlH9SvAhGPKgkjRJ9n6CAUaJIfGfno2IPj250jFssJ1OIaJvPqEzXAm-rh25N4iexqjWf16C-HvBDqXbrcFquCyEdwyOu6Qr3ODCzKa0ImADyv0DnLGu7Y6RT86ulBvpNPPuEuJ__lLrHNqoO9nj6f1rFBNlBSV87rQwTyYhltenqjj59KN3HOwiUlHFoYCQjmsLffETUKkds7IhjTAZbhluInSYcoDyQimP3xvUv7DWNA7rbpTNasz9VCNC-N-WPZXosTEKhx0Rs1CJ_rntLwwWos3LORj5u7w-x';

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
