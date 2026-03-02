#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGWcngaoGonkFZePqvmxJeJDA6StUQIj9UMbVkgLmNrFSeBd9TwB56vDesDb_MX8-3jYeZbGkTLlnsRYSdOAhEDMZMQyvsrcghPPuaveEtIF247KzjGnwV0lWx07ipi22LZi1ByC79E2TXGf7CIb5mvPegRe-jVR10LU6vgVBJqJ8OC9SoCZmMNz9U2lSbguuBhf12Om0PbewItqhB9OQeItF-m6B9Ml5cq--gaki46nsJEqCQHyn4OnofjZmvbnUcr2XeWrBP6MDAvPvxNWHPQlJm1KzlR57St-Xz4k4kwUP6hDCObGRz7JU3tW-O--nv9UBMS6qhHhm7AWGRzbzsMZQpP8p7zxeF-N1iWvng6Q8rWS2Ccgx-eJsS_i8vVHi6DUKDP0HCYiW_OcLkkSNKW5XFGhr_oGaxZJox8q2EVul1VQm-j3t-pOCvpLEQh1BmDF0TFujI4CN6WN7F1iyvinmniH86dyw3NJCjY1FOQRSTKmoEERPu6Awn1CGk6gV1WSC-lP71I-1SbKSZMfxVGx-TwwFjfz-er0YnT_yLoO7Jyp4F9uIE6o0vUSq14dBcAAajnE3w8ApO_DfioPO-UoQP7UmIzaPENK0XnfdsJMKxGR61OBeVRukIOYwGzJp-vzALAud5qNA1IsolzQWbac3rlQd23EBTmOqXdGB9C1H6AengIyziJu_IlAbRjFY5aPU1rMPl1_jebh0NsB41TyxQdQjM4GJtlspLRr-JyYp7EkJnR3raCadQ5WTufyj-3H_PljxcAEjcgl0kUkr41Rfba9Mpoe1FPQFDLselao9NaenYcPb9lE5APD_FcCYxklOTLwnKHTOvozxm_NzOJioxWwVpzIr5f8G3fsxQ25HCXU5PAUMDQ4hME30jT1rN98F8OlMu1I6i-YX9DQeLOJYQKWLhbZHog5TrHvPtRGBadmFi0-xiUoyNHbpiyUTTU7nMnELLVLu0sni_s3Nv5STYdIsrEk_wGTi-7KQ4sISKsCsA2B3MSJjRdawkhTh9CaVRnMSnU76JUMoJ9MVyOfKDH0Ww8oxWoOc3vQXq7pSm907WJaGnwXp4EyE_U2Hx2lZtOtP411fqNi6Dbn0P_9RZ_2GbW8_SxZ1ik6GqOJ7S-cgIxHueA9tibKMasTiEiyPr6vhtD5P_grmfmw3AAcGtFcpes8d2xo_jJEZzc-MSeZrIT2VK7ODZFF5J5e6Ky7XyKvAdil4zNzQBmQCNHPfuK7G0DKLOtbS_pKbMvgo9G-boBDT4ZXuoQg3-H3sVa_Ann7-DMgj-CCog6MoqwSiBJI8DSJJNYE5ZZJqTyIvQsDylyXXlPCvLU1TCXQIXjo4v7E0I4jv7jAazcZfSgWqnTLWXLtVutqmSnSi1pFJpjP64MDwR7kMoWv-gSWOf2zS-YbNfqFF6JuYPtuowdhzlXPJv7ikHzW6secG0pcGA';

# Path to the file you want to upload
file_path = '/Users/enianqosja/Project/asrbd/build/app/outputs/flutter-apk/app-release.apk'

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
