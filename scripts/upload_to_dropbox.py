#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGEOmlLOSB68QEC2V-5a9cyReodEOdCmwgEcLRVMDrkW0zBPwxnC67XJf_cUq5WwIcWCT9NgkkSAAGDuIeLKGElBVCrlhazseylbdmGbf7apLgFy1eXZE1QO4PheJfCrI0ZDHO7pMYQtXXuWElJ38abfXziRSqkxpGuSUeZYebQnz6rpMyXdzsCkQ88uWaRBK5Hu2N4lYzCnWdBhgsC0JcJxEf7O11A1d022PbI8pjohbI_2WokhlaXssZL2rxJHn4hZ_yszeoeTJRyx9t7kQQMTsi_HuVGhCV-e1p60m4kIEnm86Oo2Ply6BYs0v0hLDa7rgA2jwzQk-yncIBD0mIsqGkEW81MvZ_HE7Mt3JVwue8UC_9RNp0Sz-_z-ki4aq53sm6Dv-rFubHQKOD9J9RmSHi2VMYZq7Htzp0ZEB3T7cLZawW9pRpctRswEP9329y-rareEgrY_Wh1R-3cWfyZM-mzyc4Ps297rTdAE05f3E15UmBFHeQAWCCJFb95Jq9wQferR9Y8P5qNc6M6kVxImxSqSfsWMShsFfqZ4gt5eOAWEL4vcdGxOiHAFHkMkNdJyeDy3M4V6GrRtbIM9ByiMQ9YmH4KULOo9J-Z45LrHT66s2j--G2n9OjkCXEu5jdi2K9iZFX6x9qyi-TpHgOxGd_yfKiKqxzStSBhf0TG7cZKUjjjpAhHhun_GGbYty83ySmSfV8V3BINVT7OwkrLQX4e9W-75aQRAopV8TuISA_c5LcVZ2dd450DhcQ09oh1DALMinxopIV5iM7idIkeZj0rGMpArcmPpkPwwnvwV2Vrr9uPKDbLwYPoTBsv-QImMWdPfPLKXnC0pB-uQczhP7UkiGhHAog9GXjy9giv6Y6ZL57kTeyfMFKZ7sv_OSbB1QVJndcazD0R-Mj85_dAlc_K0SsFMi1Wyn_re2mXBvWm_mKdlKiLTfq2IXbVVvVW2eag-FTdbINTgTi26JrBT1Bj0EWopxHuAr6e83EFhKGQ_1QB0IaItn7bGkGX2r4gVRCX2G-3G2iTOBxngzr3_Xe74_vczRVjQN6BY73-NJzA29K-voObDP7jqeKRi59APuoi3uvDdX2RfDjnUBpYgSmi74V4m10aF3I0DuFSo5xGVIWdXo_I6SEZfg_RvPh584aCSboAhPmL7hOeqhZ6D8qKUpW_oKnEhdaUkaO2dj7VMIA396EXVH1l02E_1Klc7GSi9TnAP6lf4uKNJRawmYyHdOckY0zymmgpneWF-Mk4UzBz_VI837KZSaPnv_XFzY8GHs2arex_iEH46jo2f9Cm53y37cMZSnecgMXTT9q1cnwR15ApLjJUe5ehIkEwnzZ8KW-Ah-7ltmFWkU-bbswL8ZP3J4JT-4NN7LsOK3E12kI4RXyGVVJ5Zow47pCoREoF1YLaIHF6ySaz43APM';

# Path to the file you want to upload
file_path = '/Users/enianqosja/asrbd-mobile/asrbd-mobile/build/app/outputs/flutter-apk/app-release.apk'

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
