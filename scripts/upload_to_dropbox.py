#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-_SlIBsVdo5crPKJAa-N7zjzxw3sj2ne_oOx0p12m7DMZd-GEWqhmLOejsmPg0UBfSXyfMIxGN35dmXGzOkostFUvbs4y2N5nbP9jXq6C4aN8XwIOsv2oWxnT0Kf99-_XU2RuMhbbbrlsWvi_eRE2JV1qN6aPiTzIgPK9E7rAahuY6KfH3YwWa_Ibqd5m8z8pYUzHVsD0m9sEu2f1Ia-d6OQuQJHofqo3RDArP6v3-V0id6w24j4qAcX5kqcB5uDGnHGCTf6Qn3gfQlmp9Sxj8AQCpir6HOJXUAMNuVAmVlnmsBghevI7d91q__3PMseYj2kS6X7HFucX8pCpdCjHPOLiSNayrHUTfWeTCa0MfYz7wF1cI77GgX19EWRqA1ArUW75MdVIVqDMIQ74HSFegYdx9_K-fFwFozphZv-Y1GmZxEDBndvmanNJ4LruE1pumK4R1L1JAhLEiGFrEp5KBE3-MgpmvGhjBxvD9FkSIskyMEDDhW9kkOBV2wFqNO854Ub8TJcJ7jFGfUHqsvnqI3-N3sy0Umj8fjZoxrNLl-lbK0bKGFqw1NPqyRtS5dlILXxwJ7OSOKLwejsTLdz0c0w17WVrNs6O3_4ubaD67qyrzrfq5AImo0QZuP3zSfTjRGblrUPLl-xWujnsDuxRv93_zYctGIFauO5QxPt-3TnfvucNLAEgY53BilLI0f1adyz3Bmz2rUILGcwi73ag40pFwy7a7UQlKDrX6lB46BZ5sLgfBv0XSREkoh5nPU5QMjjKrKV7wECXp7LujVHafyQ_-tMA8yPxp8qjv5U9DrxwtuCivJ76uTkYykRfR7355DCfyWDn7zuw4MKQoMA89UO31WAdEshnTa7FrnfnHwIoYHwcQL-HMQPBqiwo3QA2-LMxfvZFsDnVFkjGq7fq4Mn-STPSC4nCA7KSCMUa_deWrELLNY87g3F4MrevfnaGD2tET_sP-OPcG4lS4Od9pRMS0SR3KaufqXBQl6pvyIDpGge9feN5bOi7PDJ5IE41YAMxzBmE-w25g-dSi-3zScVwALPUkPjjywfSY4H4aMRba1e1FAJQEdOygc7foXqweJ-xqUVN4cW9pBRgnKau02RvP4a8oEjczVqU6KaXt-sL6FeW6mjad0TcWhLKXpqnbCimRZPtKyIFFMYFUAUFzlMoTXYOPt01MJ9cSaV5PiTefcdRlzWoY_jWko8tkMK4Tw-349RdzXsrgPrpSyNU2_o3HJxv4g_T1whFlS0HBO_u8gjGHl_CFIf6q30CD42kvEhImBFJkj7eb2essEB46YYRhOqFRE0fZi3GyF5ufM06wcHK2Eid0RrbK-6Key_Sug4ChNNmjeOmdXks1A-kE5FKMOYPDOMaTeh5SIFpJ4mVIkp4PpTOqirekWVb5qvIAdPLQOpFkg53pCwtDUClv';

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
