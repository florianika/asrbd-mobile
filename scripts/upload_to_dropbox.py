#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-WWaVYgBgoYxk3sRzwG11Z0UZ1R1xBksR60AXNfclRwYTVKhCiFJFA4WgYLbqfx87fVLCpJApRyJTZoU5HcgjJwwdOYY0mDgbCU5_Qhn9BUFbXFXRbpwgHq-WQ6oNowl-_OQ4iMkYICZEpeR1l2Ogd8-GKjZcIBRuB8io6M_qmtW8LSQ5mr5bWfDOiqZIW90r83HwrL3sbQC5zNUFt1Ce2K7Q64Vc0acHQlF6pgFrfjaQlkTrcZNkTERDsB9-MVQGDY-ZRNhLs9yjb_Ckk2i2Vfr1oVfnc2F-imTRv_And00W2WjHt9ZynIJSnauDV9TH2HFBaHg85YBEd355Cu6TgcfJRdRKb5Ee6WTXnMeywx7jxG9jzMtfG0-FPLjQZ0wHIPREooSFzh8goMpHUB9modjg8gqj_nTzvLQvgOp0gLCvP52OA5BKzbJCj_N7jQM0EYny_Gn37fYRhOgCSpq6jj7TRlBi-00n_aTgY4QJNbioaxF8lAt6O3C8LljMVeftpPAx8TYqb4TX8g1XnpwX0o_1fbnfpLy8_Q9TaxtB1AgbCVZgm4v9PXGGoOcC8zCyXpPqx0Xn9xK9kdZF_gSWhzvam4Mll-1AEmqfmxdWq5WgvTDcZAkZuuonwujmFjstL5pvOKd458x-uJUqDTZfgpm5MTWXsFy-_uaQhzy0V7WEJUCZALCC6JOq8-9V_klVaEMbX7tDXjUpxz6LDxxQIkGj44pdjjgaCdKcm7PhiYTfdW5_LnGe449VJvmW-59cZ6ps4GL6fxBzMZfCxO9BJmOntcHPvix_Ein6e8ISr7KzoGRZnzsXr23GKgBzmgv-4oFV_tYjvvcJzY8jJYZPXFE-y-ME_CoCKSeZN00-tcdfOE7SRlX5MbtrqCIE1ho-9QXjqziCSIMQdgbW8e-eFxJd7kCcGGkoNbmpB6lT4pX8sDMEQTwYzQw1WY1JKPF-2jO74BkgGVv2Z3Ni6xY9rHGV4SAFHVPzUcMC3G87uNle4oQkJlvvBCbk0wzwV6LJMPO2PT3tYOaar4SP624vFTZDVI5cycRiTcSJzh1NqCQycBvpKmk1Sm1mSVhjeeG_UC_bsbcOwcCAB80R2on0dLZcV-aHUwZinScBUUIGKivPqUmSscgbH_Vyp9Ispa7bDfOMv-KfUndCf70C8xVyrUgJxS-BePlvsBqYTAqCSfjTjVjZ3DRFfuyZ0FXr5EKjHvsZ4cVpJ7tNvO5roluDb_X51gCxZ_ZK5zwT-HQe9RIF1sSWXaowb0e4anWP8C9ZLWv-rjsMj7KtenSGSQEUWWFO3i-44fxsSA1e3zpKxhy4KRDtLRSBLuNltyGATDZCpmjDksBlpWV7s3Vm-3XpQOi9Mv1yt1Z4xA5ltVmDyZ-K_y_zrg7jjNXVfv6NraQZOCHgYP8BdKNrrEf47Vu2B';

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
