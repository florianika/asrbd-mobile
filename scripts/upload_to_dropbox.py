#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF90886j-9KFxUU7drn-BJBMPuz3yoE1ys2j5wTjc37KIWAnmOAwCBaJhpojcgQ45G3K3MNfQYSMTJKjmQUNqzFbB-4iAU3vrcHdB6K-3jjUjaKHtckc5XeJY7aJPEkeFoWADXuLsS3zJaEc74vmSV8FGylywNcbLBe79B4ntKRLIwMpKYmucfpQs2YYpPosXsMsOFwhfW2DxFcy4nNLrz_9VwZEPMPEWa6KdKZgqwN4SXgxAhJGFTSkWBJccCOBY65JHXJkYVIW5uxcK10VXvqYQtp0xFa27wJWoZF9DQQuyPnffjFnuRUBxz03m9bRKYxmkkJKRmtU0rGO9O5sMS45YcH8Bt_l8-dlIqmD-Py3E4ZvDV9axu8Ij3tZkWwDh7rqQCDxtx4XC8RtI7Es9otFHe6JK8tgV7_IdeP5Zi3lmBjLXI7Eg2jCG8d2VoRb1p7VmxPvd0Tc8zGS1zyWE1c10KNv_udOcPaQ_5Od-TS-VjiWUH4-2ikVs6LB4uQ2Xspe2MNCFd6WYFWhnajOlyj8BylQMH-aKBVKZ8KomhCw2PWEZNq3FJdmvW7m-el8bBBLxErboux1TWTF_nFOs2RUllQKv8F3it-bgnkS76M7Fwijefd3Oir9NeikrklLq0dqMZ0lB3WR-lyiublqj44l5HOVJSXS8bRLNSp0ulZZTGxHBrIpIxVlptNXuqmZPKe-yUSMyCrjryQc-8rjN5q-JGZrO4TzXBxfHsA16D_QjAofOQi7-aONbszA43uButJszMjH9ZWf1f9ZqbqOtJPjzg6tgxPJr3bj8XFCwc8uljlsIrCfz1pVHRbfd9KcXOyr8iKkSVB5RrTPrMhwEOipTjmlNktCvJZ-h4eRYjyg_JmKUYDMEuSj_67B0Nr9uukOplIc64tuIcIKWyvOcl9-i5NDTxB6RpErZOJnQ-6KZFBDRjhfqbdc10zooonVQmL0MWGVf3grw-4Py6NLQRUjkbisMJzKnhL99siyJDeJc-SOcqtzfdzvqJAL51jKqyNC_-Ox4Bme35eKeQlOWNr8tQUwTzGl9dJPoQviYVQyTtfCVG0reH0xxQJb0OSKtUS6ZBYflHQHIUTOLaC8i4CzXlndkD8K9UGpgiEXh0jMAuqegrBzjrnEd78ze5vNX53vwfhItH7lE5q2XM30qcK9irTnlQKwbbq2ahZ7ui6INREymlRrlukSgW1Cyg0KFV0RevK0bxBSwFUrh2lhXGkSf0bfpaZ6vzXjqyogzFZMvMu7rDZevtKhdAlQl3-rre7lkWciNEbljfl2lwsEUQRFTkoMP88fSGkKgUiV0PDtruJuFrne6NKSs76HkxNpqWseD9TMs4m3OCBPc_MhOe-s0AY91qEED0wELDzN0oCyRhN_RX0iuthmMREP_sVWjf-FFbIqS1H5L3s0CfQIvnBQ';

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
