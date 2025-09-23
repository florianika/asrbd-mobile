#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGCNhfEWbOM5A4xKlnWLgxAQgfu3nT64565kyPWbDKjD0ne1iCHn_eV9RTSUECEJY8z_sg1IjcBBC-I4RUbOWcHOSnlIS5WRNboAuOyHPwtsdLSxo_bbKFbLvVleeYKcE2V9GR8gCxT7FuNKj1EZPseTNvEncU2yoxQ2dWKyi_uqIj9QNF2WGd8lc1ZEXXPa5HZIfaGgx2GpeXOiCZZL5VLLaINS-CLhbr6jty2YIPXIXdRY7QC9RsRz6OSTxs5_T7bLRXUpqH-GT-ZMmgkrw4-oy1SZGzbShcZ1JSlkr-VRXvFG0tmJ0OEns5OSwb7Wb204mXdv2WKJwI_m68-F6PWOaHVWwiIudcwup45MPkcz-z9F0l0a-f95K0Ds9xsavk1PtsvaFIxB-1jK2WDNtrjvOtAVsx7nIIKr_1kuw0P9kT2drN5BJJ7Wvp7uFC6ohn-ta-08c5BSNKI25pxJsmSNwk3vM2dlnYMachH2M4KcakHUdps0ZeYQ0OkL46wl218TP0f9Gzin_y0Wysah1YE4q4jnm_7aXPJurInT5VGJRMXunWQxejZB2MoRy1Fz9otf872m1VCJCwQgUT_GzzYFlX5u8M2uV0_HufMZd9RBdKMfVmUclD93NmQO4rB0WZ3o_FEs7ytg6IjsD_JJmiGP4MQj-rlI7ckluzxZlMmkfByUtaHz0ReJ0yQsC_v55mTUjTZrrY4w6o2A7k1Hy6riUo5wyl1QjExfU0pNuzsaDhuVN8G9gDJ1sjmLi2VbX8n7DwMzwBGnjv3P7-SH6H1LIi7EF22gXlvBpvwLLmdYOar-djju3WhKtattmu1GzClrPg_CXCQ2mfyigUpWNzyf5qIkbLBKvSQTSRjUH9xJwXL0eZoXLMgzXlhfJmCvmlCACFS3QxPcq-tyyP-hsSiGY82xDRXM_dJfLXAECwCMMIgGlsR5xzyDglwGM4kxBUGc_fzQ1E9U4SPorS2TE1cnwk0l1DYS_ASsT9XDhyla65CwDyi8GcH-I6alXyY7AP9sL_8G-u5BpxEyHh7t_hXNp8TCpR2r_AOeR0ZyqEo7zv95BxaJajxcgQEDb9ZjT3Ggs89SSfxN1FTLEE26WvyoEkscQ9XeNoLVC21iiDV7aVfmVChnEdHW5lBv1IURwYmHyDgGUd6U5f_3w4IN3wGSdPndwcBRO8XR_bvkohZN5vdrmIrcN_A7Bm7lP65E6KPY8GrHUNz1UN_r6szgn1uY7ltmXlhVjJDAHjhRxoB8FQ-gdeaexue5gXI07mWLUL7-LxnGjag_8WnemLNycRM9p1HNDEQTf1yfMrcxSXal3ZkrLYIrjSPLrb_Q48eRnpD0KCN5TmIwilK6usPFogd1skEiuAI2K5FvLzzTCmXr6SSk_6eehLLAqvkaMsqk5kmt5VdatIIldNgvbj0B_nmI';

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
