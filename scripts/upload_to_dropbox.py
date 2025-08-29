#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF8U3y0fRTHBSZO1EPxk0I7HetoCnmFgk2Io-tB7S7dd9EnHFJxKX0mXPKCFuxVQS-ypr1gJO_GJvhZ1Bqobf2_r194rgUJlwDnnMptMjRYTGyj4BLBg86SZwfheVcIRTU5fG0vHhP52Ozl4_EYXuyOVCKV8FpFZBhEIZrwUYzz03986yXI_wnvhrAZ2E0YlBZ6hWgOtsxYkqpPO-Uv-aYEbxHut7yaWcD6bPdoNYPZuUWeEYF_SxrPKCcJA0xHnjkWNpdCWbRMchiK555kzswNg6R8Lob4dcfj1GbmF3dlPSClp8AouvHuYyCFIVslu3be77mkr9GTv2E85sO3WPEiF6tm1-gumFSuXpPzvq-tRtTrNQ-BnNvJd_LO_1ZbzwxQ8sIIn9QgHC6jGvj5R0NpPu1wR4kdCYNSaeHqbf8Klg328Og1--mZvFXkXI2s8V6Ua6qFI-ZzKZJU755qVtchvpw9k78hk-VXNqhSy80uOHfj-3YXqpj48JqCOHSfKZceinMOSiyzvGNjGqeEKivJv1fKKF2wSBD75tO6nvtHqtnx_JUONAnJldQlW_nPAqKH4B8upJd_h6Ir-szN9oGquzyM27-CSidgVC4nL0B-yLQ-8Js3jnAegrlbasZ_u9226JxpnmTXYUNRyKm8AauL0racYQaEf0_bvMlUt11eInM8qk4JCXbbeSLsRS-nIvBK9MzQnV-wPGg3hYMmadEpJbyvUfHmFlsXgxO36Su0sGKX5F-Bz5p97OQspYKSesa5zVzEmisgCFL7RaB5aqOhD8fxiSuy5y6zUM2LVwFGX0RQzNBdePUkXKWX1pN3l0MrFnevA_if29wDwHwg6uVJUTqkjh7kFXRKhDNN0LGGtaW7THVxisqw-d5iqQl6GOhUoSrMvVC2xFkrUOuQeLuoTTscDqtOqrwPAJNvgiWlP_EruM8IpTKAhctYE7qLAl5M-MLSPVcbKPkPPCZ4XvZ1Vf_U8QADuDxd4jywkaq2PoibX0DmwiWnBtUAL5EVePpZ_tvwz2WpTDeG1Zc_MxQW7QdTmq07U37EZRXEgEawKHMrX1R2HtgkJWaTWQCkvG899q8RPidQNuKH-GEUsBwhPp17beB0mC95-9E92TB7aFwdMj6_zrhA3I6Ga7GFUGEhfBjunOOtR4K38Obbzh4c2aGy-yoIxAcPTrGKxIHNhvFPT8oG9WibNe3lycKpRTQpoFeZS7mYeODx4qd06UbKtA9U9GZV_Fj4RCiGmSdAt0xpd6H8KuooaoVYsgoxZ8ufnIE1riQO3kdhWXgN8WKweuZKudS-qF1ogmbeQEyKghsM6IUJfqNAtmjisTVSVxNZtDKQDqLPt6zU0g1tQWTBbWLniuKdEgEdfERlxAY5aNoO2nvVB7uKfsKlT9LTjKqhf9Kpxan1Y-IjE3EuhRapg';

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
