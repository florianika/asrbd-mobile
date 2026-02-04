#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGQ0wYxt2DS9tczyktRq4PojSJEe7ftv0n8068EKoVAAWllWzqcqsObY3UJqUTLXlEpyKLnFzg_Gy6Uim1i2v26D2lai_WFv57NcpaYyvD4NNGWy2PenYVTyx-tz7gJfgp2DEYJHWlbkMXKriN3GNxrh0WgCRQ0bx6ac98CXZ9GXhek7EIDMKsWFI9xranSPZ5OsLl1_o-ZJsHa_64opf4I7lyF5jpzr-TQb_v55h_MgT7L_2oY14cKPeVZl_JaJX5Csz9fkPPz0OivDwk2XGQ2kiCYEZo4sxq8HLs8JCU70YVq18JUCy8HNiQDpr7r04IsL8Wd_bCEwZGABMBMMwwL5f9GtVYtC0LofQYbHHJV0BNOcU38o0X6Lx3M8hNgzpticlFABtP6FoQ3bJZ3oq24ta6rZq6FgbqPaoh18le51XztTcsVoZnzdY-RSjydKLES_L64z8TyRimUc81QOtcSUiNuk-1Jk1xrqBIROgKriwYml4aObI3t6V_235e7QeOUP-mCfa2Gca587v9cSOiqSYTzAseIDHEmVUzxiYOJCA4ZRVCiHnU7tiGA7DlkSJ2717fWWAPf2lO99YHSP9iWgG5OU2PymVJAQfWeGNhCHLDobrXxWoZ6xa6haCKyKZce7A7ENIZI7DjCFQwXLPT9rdm4gu311zbtqjMeLTl2--E-6556YXLJq9F_BApEFppU8WTkumuNKenOYMrE_F1ELYBiKzs5LIJkFXu9GSamt77ESxBlTWNEilPR3KCVoLx5bYTXSkqteZKCZX6Dwu0RYoxIEHn5cfH8vbo2HHOBDSTGsymIuKcrKqk6cj20okn_DdmsCiwHvi9dHazqFyG7dCWvP_SMrtRjnWOf6EgwPxmOyTGk7iISDCM5RLRjDqh1uhGmnBp8TkWdkb7zq50dMopYQ-GKGsRlrIm2VQ9ZF0ElAohU0brY1_3ylYv5syI8is-BYQCgSUFi1EMuwKJ1s_XeoEIvaKamHVW-qPbHv8VCG8EzNSE2cfqz13cqlR0ktD-eOoKxE4F3PGGiQUPehtFHbupJ9WzEk2djmqbTq7JJqTynr2lszWNPZhA8G7YQFTl2RgrKhYnLVn74BTBNVjkr-w-K4a8XrCRhEtW8sA1s4hG90nPNr7JmqtZaNZAzVHgw2WEbiD-xu9CIPzMcouW4Xj_HlQaClqVIcEBKRrRn9_qpoKjoSCePRLPRB1sYmzRQUWe_qet5PYjz8Gp5LkWtQ54UxX_e-Ew1-GkqhJMq9j0Xbofpsp--ApYWCWJcegnkfX61zS60VOh7SR609VOIe_Uw6utbchJ53ww85FXAXz-m5GpFkej8513WKEpcPXRTS_6mvhuc0u9DzXLGOKx2KeGv1JbGJCYPWGK96uWbHGPA5wggGgGRlZ4D-w5RNJcVa8pnYVhzp-1S2yPI1IndyPt6KbM1gfjUWJYZFMg';

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
