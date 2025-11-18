#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGEyiDzg1s_dfnvViWVZcZpeMNeTvfSnr3QQIGRpIt3ttSxrPNfEcNScNLlqnv5SsZqOTfTAvStdae0jQfCPzOIo2DeiOZfYvIlMxEM9nDnnt251iKeFXlguuNCddhJiBaChR42dGP5IRSVK1IKoEuyoFUfi-EdsITT0dEHffdW9FCXRe2JWzKxtIK8AelvfE3qVPeHtWVFjx6fuaPYL_yLKJxgcCsNERcNaAxLLstgUpoMroBZfvF-_mO8ocANTiyuON6oab46IcifGllCrRTGLZVzw2rflfxrrz1JbHmjg2dq5rdoioadtcdKd4-GZSAWcgLedHoZSveXCsv9xA9ksV5Vnz1X7x8XWncFrlPDt7kirFxcAlPmH-fMGAfdl_Zjh3u3Xlo8glXFWdbHfWzcHgnvS_WIjDfHm8iu0ZdCOqyMIegqCDtwi7bOHgOBdwQx8UXcH4vdTQdNXm2Jz6vRj5gkHt_mB3YCLjx2SIJLihNtaKLQDlDEe0mb_LcxqTJMaHqGiHR7Rz7CC05SnkQQ3OoPBHD6Bh5UxBg7RJs94mHwHGM3-J1bHwbdbTDZL0jDqb4P4j4SLTczkWnLoJWbmDJM429YR3HeHKwBoeNj69Hjd0j7WED_DK2tkzyZe3nWKYKpcAF6dhHFKFZqPuZl06Rd3j6QEewzmeT84VdovSV8yDf38pfgkPErIS5gle052_RnlNSG66Snf5T6Ofb9gf-YlDy-0W-DqUGapeCNt59NW_gww3q8GUtqQFrxYwfRCRf5sCCKtGCf01AQTIeSqmYBa5eEgyvTG60h18oQsUldOKxjRA0s6FFOk7PfdCsKpgGSx8s1o5ZSUFlMLopc0drvdZCYT1APxTxZQNASlM8mAvKFgTPvyo9wBmem2GUnJmJMmAT005NpnYFio2s_dGpnlcpd_Dpem7QwC3Url6cgdIVvXtCepzwHdgNQkjWRonP-P8URVDmYMbll6ufU6xi1bTfPjRky6ASXyQ5CzYUB7_muiyFxx2p8EM0PHYWA3nJ9WuXu7AE5-6SrIQ144b8qlEGu_8c_ka0plc6SdXBAFYBCeJTOylSnVxLVmJ1WReSCyuZ4-2HrrMfAIdmcPkRHaMSDzh1ZbpOWUJx6b9RNRxuEy5WST76homwTZUQrYk3MyYMjiOmb0c9-7OCvRpVjfF-1xfGhf3vzAABkl3D8K7_ZUQUs37lWXwsMFaTvgaOxBB9zTTJXOpqe19JXhEGqRpQvhcAeoGceCuMopoHDrr45TLjaPzT0493JIUy6GoUSA9W9OVidZ4QX77iocBxFoon53whOa1wKwbF06utooTfX513CoXgKS6eOpxgZ0ZuA0LNEZbukHBjB80c2mm2SmbDhiumziCsfxIAvqTBvxetN6koSf6cexO-NdEl5mBrs2DsSGA1Yh5WU4hgZM';

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
