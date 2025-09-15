#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF9yBfGG-nE5y9Lh-Lwh3bCng-S0CUaWWfg5dNxXhz5-AoK7gk3dHd1R_giSLM2kkJOeTlBa_QBAv5R433mT6pWyGHM8RI5WgjEwTo8gELBrHcDaxVMoA0n_qBHcO_rNJo4USRCx2T-Iaci7uco49xDVbje_F08lOaNsmzqyMIF_U0EFrRbp1y_e6-on2M01JoozeX2yFmx9veHgt2TbxG1koJohebSJDo9yI_IHJnYpFyUdkJFiRoibLHbYZC1T54yYC4xOz3vP1KBpnmQqgidOrWvR8Uoulug5Y-A6Pfh06wlvOlXCVJ9SI9xEKG1QSRE8RSz4ix-bSb-Aw6MipsGnHhSv_BYAlBnSdy-4wYthr_DcJhPE4W15MNDPvh5KSfpcB2B1YMb4KZZ6TbbfJDgwanp0Rf4_DNd2aRzsN_SLLgbBzwxEmMzwPSn-h49W17cfCBpOpJ4GJfUPVXkQEEQ5F__GBohjzD48IXFmcXxFnRFao_5OKmgEeD1FZD6Zi8jQ4MD26Kn2yrQ4J8yql57_SinUbO73Bh73K99-xKj4v57WwPy7AIvu8oL_QVJeW9tllYMqz3vNgSW38Sg-NfX-m08anHBZEjcBHkninlgqEsTby_Yq4ssQuqusKz05Gb73cxBvwdVw4WfoK8EwTMosQGHtD1BpN6-PZH0YZxcj26naA3IAdq8ARNqVl939kS3pXZrzkW0qqWbserJ4XP2y1EUKUD6JW3e7JtS-YDkrN9gxOPXnPeVW3vNHverUOXjY2Lz0qW9wDCkCzv-OJXCPS50m101HF74kRfzwvUSold94oMZQnPqW-2W_x0xwXZ5WbUpelSwLDcjS-HM7ocMu4Ezr68jbEENrJX2-Wg95dQkOl-MEba7cxSKkbeJLD0XvuXFQ0uH5BQMFHScJRUd5-NG9Fn9QfuPnMCDImWj-Ddqirc4UaiTGkEGHo46esMc6hSe_2VhUJBCOXH5SxdTVK9_hfh3Wr_en_ISjJe4Rv4hEMOfIg6EXtUHqI9mQ47OggcFWnAu5_8jsJSMtZdwWIkhreuvldVuyA6DEaiEktZpxG6DfwfEt6vFHu1i71V8b4Kn67NLStVoayGKiW9vp5PgKP48I3gQvSYdfTzaWPYOmJuqK7hiFZKdwc0Y1xt1Xzud2b9VEMWGgZbiuIMz7qpXG6AYbqyt5ICJeCsjP57WfbYJSlBLaJb8RabHAgJQb5Drj6JPjVC3UCXUawVxsIVGpTFGCv4QA6IsRVeLKmN6AoFXyLK-RL61s8ryoGL002q8LYDzB9gGUxYSx007V9iqvyDd9RZ3YTUx_sWfWCjOGi36v97qLVpQeYj-_-1vKZaC7xKVJNGlViJUghjHt05W9Oc5HlWwWz-FDZ7wKj56hexUGMsXg9jQclVCK001U47v2NvGTscD12wfD-MEG';

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
