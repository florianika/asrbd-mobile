#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGT02iLKovUi48FwkUR0VDtBfwthuC6SLpvVCDYTcCwnf7_outkjYmiPgUMsiep842IN6MUEd4vDlB_HjxL9LpWEUvQQ_dCOWy4pzUz8m2O0-WXL5alNEShn3KwAyD6g332i5n0BMgPHlKIUDZ_QVWAOAu0aWyrNgkjoffJp3D8UVQL5q4LJtlYfhSfea0NPd_TO-p_kUi5WQhLnfGWC1xpspMweLj6CwpU1i69IgQutJFeLJdo8S0tJkUjOwH64KMAnUBUF8c6SH9GPn4sQvhCf7MeI9Ctl-KkDkZF_mSaXgkgkLnE-sMTqmoNxatH_YP4p1yp1bQ2vjW9IzNIrX46rFutKOgRspHwgf1kPjopVZOAFCiQUGvtV3JejzyES47CCjinDEOHNNauvdCTNnfsrRHkXS94MYxVlnrsRmwZ67HN8mn2uw2r8chjo17dlkbD5XCD2xqvf1RcPo5lDQScytV3lnKhYnuCbbnqQHd6X-rpJI19xVPeKcHvK0mKZY5rHdLIRSEHB1NkkMZWeAY3NJktcSxmUqFwjrr08JPUvXv4t8CDpWc6PgEm0CSysLxx-ETyWslyqwCXzVArRrccZwr9Myf-v-4t2uf6v9Ktep9OHVtBg2tgKrKIIbdFH10nXI-mcP5nEBahgkgtHPWRkvBJXeoC4okBvFWsKEMeimBcL9hBdpyEDo4jsktw543WK3f-FlGpnLTbBUs9Ibw6ZAjZfEE_x3hvPdRiN3FTvT_FDGL0rh8v7vZoSSaMVmYMSTF8dOT9cgu5a52eo3R3g8iCh06LBwiLM9Cb0NEcnzy4W6wkV5GqrPMn-6nQVQWWjf2kx1kYkm08H6ntJyC_ONpienhm11gnW7sCsjTmfRVmpg5NUUbQ3QSl4_ri575ONzOtqcqNcOu21vZp_YtcFvmjFCHRJLGyPLOR_-BctRtHFwigcALpBB1gQi4yMTvBFKgLVsyGKD2LurSkf_Nh4YJFZ-En0QbHd01D8h2rDqX9h8Sjtv08ZgwqMNP3rDjRb8-gkdAipaCZBodPcrNhU5GRgcai68st7A6iBdxOptBkhaIQmnDxZ0W_7KXMrYozIAputz_Mg3ZZDRp9Amifbouuu9zBgUcNd15t1xIxCQ1b0DhjBu-VKcmIKeRHuM0dGcvJW1Mxa_hEN-03ZQ6-w91BJ2ZUpA-ghOn2KCUhLxBRn3sbHPMmK3RVYek3ZZHZipcqvLIzX924XqkEa852B0FcAfpLCsl5M9wom-zzkdOEh1lNcb1LDoGRRYjJJc_J7UGGn7xczBbc5AODJrz5wSSaBxzPtAIxRZs8f8APmpnYlYLGaD88CPSJkIuy-zT1h8pactTkn-EsjTkXzyD6Tmn4ZHf_76B2MkhRRnHVbthyvLqwbMMWGhQ0O9Z97_Zut4CP8ZurV-4tRjMeQfBCu';

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
