#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGQaVIcIQO4AK2wyGAJRr4xsRE718mazLCA7veX4BAUOBN4c8FIAC0Cpjfpfs0emmgRpCzIlzKgp4u0stGCTva632fgtulRwh2MRAH3RMeYThM4L16r6jr9dxEpmdF6XHqx790L0gCWwbaDassHFyMZ0eEenvOUKld1Ai49k4F7Hk_WIVFaPpkvu6oxZ1bqRq6Vx7fowHmsjpSDAq-l0LEq_I60bZVhTy3OEQqfZdvKqeCUGMWnmSac6Qs9uPw4FzHyXIJjW4mWMojkfj187T0T21VUHNSFbFJKRkRyP6mtdLAZ-YuCoBMsTe0lXy66yL44vhJeNF5izTR1rpX0TdmFyJCsIqMHmOoaz4haRoM_u_QD0aEHrioc_-ExH4r3ZzKX14dk0bIgFJF-YXdJN7y9gI2Us00Txv0pEItpcsmXVrgiF72YTmERSSEKyZlBdFHSv10SGrvMhOlMOkdRvjEqNLce4hECD5TSh6BqWiIaclUPtmLZi5HmXP0pHKN06rERJ6h3KRtlW6hrxMEuGmKM2PT9KqgbBXwe3fdkFrEvYxgfu3RgOkL2ybcBBJMqsnT21-1-JsY0krF2E97SkSuzMT9DY9XGNk-0VVBRIn_dGuClfpX7OEMiHS8oEoFSQeDznkw6YuBoMdwxt-mn6svkrGL73OPVKmrT4vzcnA8-_Y8Kjs90e6buhV1MzvpOLIgpmZe27ukXRpdvkSCW_Y4MDEDsWW8A0kSPmsg14ugOW1xxG52WrsovNl5nDoPIlNXX64T7RCKc5KqfHVXJSE6v8S3OzcVPqIHsZVVx8WrOCe0_TsXVXzRGaHAOFTw9UaPFmjaoJKwlUBwKJS-GgUdvMqjRBZo4QrxmmpW03MokWMgWF4XjoRXzjoK-y0DV5BA0_wkrDOiMBxAEwg01C04HSCJbjDEJSoNQC6rq5FhLQO-Z_AEdSyhuB_HgJEnqYPP_3ETEctAjqJVBZXfSbLRXz7sb08j9wg1mnoCcQJ315EziKsOEjXBUJdPqi8aFtdbxnZgh7gc_JKjsdChv0JGw9IwZlA3VKlbcojeE_6Etp-GvTJQkcceqgz96e1ip1CQaATufi6gkdhac22h98hsGK71vYQAz5uKkNG2D1Qx0-rXw7paaPvdXVncfAQDewsyUPpU0x-kE23m9SB9d7OLLO2E5GK9WfKEZtnfKbyYLuPVt3MP1Ts4pJ-RL2rQtoiWTdC3j0I-qgpDcLjZe4oflJIbiRBWFpfri_UnspZFibaVOGrU2iT2TG6IrZ_v9r1e6F6Vjb1wquuxeSqedl_u0nXAnZ1UpahyKeeB8Y5KNUmb5sjEl_jy4wdQibfueKNXo7egDyiW72r84ARbDbKbrNfo4GmqKQ7mhkvcahUQ5OvtsfYfVe1AoDPEEUAwYyzlf7Pqu2D9wRAJ7ot9XkZf2u7_weNMpb0hZcpEmK8bS1iw';

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
