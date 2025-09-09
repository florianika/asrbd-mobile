#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF9w3h5okMPtCYAuLTBWo7sTYJaGubfCs1KStxRdm0JqaJMAYmwitiujumm6CP7FK1ghDfaHpmcmLb_xEZQYpGVH1bQ771ufu_a_WYe3HPSQLNxprJ-6joJpPv93t3GQii7qqAinzhk9JIEAMMNLtWEPOhmzEVx6Xt9Om7uiUDIiSg2aU5ydNfUOpI3xwB-UTnXqJ4jRFGNaSRDRZEr5Au92ovv40qI-OqrcUTXcp0zEYbNLELnCtaQ_vNhhf0KiKuV945VsNGjqjyqhXGll6YxUWtj4Yni2DqXKc_ZWKmGbFknsehYcDRRKKI4sltYsAQHAG7a2Sv-5xfe-P9JxO5CBn9lLf3M_agRU4Ee7NiVK7wyWqnjnD6Qvc8gLLczCk5LCGf9tPmFfKffZqbyHG5ZUyxVAPVGHn1SxKD_kurVMnHjp1PoEIotvlwzElhALuNOF_FwDofS1xNaev8-zIcqOGb-rtIJWKe54wXfmH9AAz_B-KfA7uyArCwQcrwYjhJq-Tceu26RTULltWqhMRSypDLjjnT2OR4oh_-KtmpvAPoXoC9mRHdl2RasszbkjffJQ4J4JAKOLYR2l1VqlpKKw9pHCueACsu-kuRZrZ_6jftkfECIjhR8eBEN6Xd8O-m0M0TTUBp_GfUqrVfF3pcO82Q6JsMnR9ldeR5l_uhTtUhndas8OykbdT2V7FMnYS31r8fHvpVGdpgSDkRjtQ87E-Z4NGRTkBwhY3SCQsFB9rGZZy6igCrv1rsxIcT3EoYlK55JqlvUt8LQBOn1bHw3goHDiBPpCKd5ErOTi9uDfllOFziJOmIQwRU2nc3_h8uZ62ZSv8-AVC9dc_sMyo3Ok6-3wqEbFaWq2OHYrAin8FIw-enHw-lKOprC8cO-i2SIQLqhxJyNTIbaGNBvoTLHihReKIQJPsExbcmLwx-_dtQMWZ5FtcnfaNxebdwJV_ONsjAXXU-uXrmQdH2PCFpbHxd820aDw-KpnpCAu9noisngN7H3xs3jQPPmS5XfRojp9oNfLdw-WHOy6IGryz5EmsGguWM_nKb_myq5j8UYsXT45jpQoqTHdQhjOJWk8zk1f4jJLce-PiCCDzf3ce6JnDDC0nb62ZTmtGSg2PpKBzEQVZNP5ycBiGQlJZLBwDgqkB5KxIUvHPx1nhBFCw5nyviY42EYV3yN5yk12--fDzPdnpSDvVjmpyyg3hRL3sIFum_vd3XtmESdGsO4LYT1PAXR8j7GIhuKYI9UQk8aVg4_Z65mMEflHBWIVrrOpdk0-vA3qNd0zOE5H-vStWHkphzS6ET1weSUVqQqNr7GwjdqkPdIu1wrLE-8MVv-CIk2GfNx4bi6G3BQeT4ST1KdHLnpDlPi6WaP5fjUCqa-4E43xHEs6TPPNk7EOFJwelZOiSvIAto1tE_6sN5-v4Iui';

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
