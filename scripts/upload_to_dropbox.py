#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGZDj74qgexnv2e8arFzdcPaeZVh3BXp5fO3WdC9sl5FYUaUDPjy1aDXi7CAzlKJ2Cx7ey4zUJmoIMtXrM9-jMp8s-YMcYhhNY2U8Cq1y-BeamygwDvgmhjnWhJIDAvTPP1DVuFzNNOIBVZxKUNNrfMCT2BRLVpPfngWaaRB3BhjuMpbtTCHgL1u5U68a_t_oDLUpHOh7v-GdUGKKZuYzcvJpGx3gVooFULYz9-wLnhc2bb9EA5ZxwGd169AkwUyowxs2-_XVcAP09xWQItD9qwI8-dQ6W3WEgqehFkxGHHUZq4Ha4GazCYvmx2tjziehwny_CkHYFa-kOXA-a4xmIB5_Io6g4LjtmhZUhYWKsB92EPuOsplz-EjAoZyPdhs-JERceKh4LYLfzR_Ggg9XA_hq-KgKM307yrXW9XyG6mlTYVZM_IuWBKPuxoQ6Ed8C0GqDscIBhpXHKmTUuO1VKwwdpIn-bfstqWAXO3E64FALUYY_M7RtlCGLiayz0weNR372IsrOBE9nFnp4tqW6ri4-G1Z20ps0umblINwq9K0rMPsM8tuqjEm7Q3J6eS57znghaDjWEyBO66G9CFTDnkqowcg7XKNX_OCl9IPiLhlaGxCKOZd9xWbUGANLovMSW2Jod9Mt4jh9vAaHq_BPKrF8-cCr50hQTwOfwmioHVz86zSHffF1rV5ti-ZFYCteyIWSY46UweJIxy9-MXlXzq_vHrPfuf-Y9tqq2EoPbFa3Vfmmd_irrks3y-1U8RF38nP7f-kTONz_zNzEZ7KJGPvACX7aopEGuAP8664TsKvjKpK4Zx3zojjou65YesXpYE5FTYVIxZnMHD5aOkiWxabldsG2VAKfi6A7-3Om599Nc-78xIrmlTC4EHSys36xK-WWpg_guBVmLRu1BDbS0UVOjT2LiGi6dsDZBekFb_bh4nzD2ry_gYtMzkKzYaAo7m2nrAJoO4pIo8JgUzvgLvPVLdTAY80mUS4xEgjSZ_wDNaOdIFNymheGr6CXds9oR52_bVgAILI0xCh03wj_pn9LyTAhayQt_Q26ilaFHq2wtFIuqI-nESNfXmHEJCRMHWwk5KET1qm9SdtbLTYa5pLt1D1UQzv78fjfPbZiaTwU8cqM81XI7j_jX_66XyiHo9bTad_ecYk2VfGqFJSRB7DOzI8yJ2te6dSTUN74IdkSRDiEN78qjTFjj-76lmDYXaVydmQxygjFhYQ-loFCRgFKcTyYzCiW15ybCPSTnLgyLyi60V6dW5MF7_zQi9mzBobRv-A6er9B-twZDEwQNF8Qb219tegBhAzy1Oohiqjx9szqzIoac9_8yCbh-lP9X10a3ZV20czROZMAhx96UDgyztBpjmFVEucPPHpLZ3vo2WB8RGXHPqjbQM8rPEtw_gVeFz7m_8hCNhJ6ydP84UNHdmIJ_dlQnLTPsUAtBc95g';

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
