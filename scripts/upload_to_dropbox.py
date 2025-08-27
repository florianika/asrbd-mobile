#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-vFw8MduZ83QCzUOzAFxlGldEMBsJpZZDpasWBNNqzIQb1xNNWWZMA2CcTmutql8kz5wnK46sy-jEOI-YN6GCfNAG1u-DFqvzX2SwG7708GZBQja-mckthndMKWw_YD0Qy4R17pPcAiuEx8V3VfBSFNOgAZ5FAPhx-HLVLD85OkZPukaURh9kbxdnaYK91SxiCjKaUwwqustlM_88LT3LlZk5ABxJBj4egmn0syfyKfolamPLOPhBlOoFHYSNj7oum2b6ZT9IHwugEOJUHbas0_Ek9D2_c9LE35Kg44Pn4k4qLy2-z7SJdmiOSD3Ih1VtYdhXbw0_OCcPFBwiVJmWLnoCcBJ6P5noZoInnMxh0gvAoC7-iSZcEpcLXNJosLfnbQpxmlNpyhDCCSOoUInaMSDAiB-vTZfJuwnQaXDT-IneLPI3NFU0kA-pRb5hINFaN6dRAhmucvO9dz2tTZmZ-go3Rm42balJsPyXqsPA2Z3eHaKqlIbOGXy3X8TzyqT-BQ1lAZSHZjvdqXTlD-CmaiUggLf__LPT4TUaqWNiXZ9u83HEAj563jRGk4SBSwVL040d80nML_cqgNqpqjtUBAJZG-Gd9rDMd6Ts93YflIVSE97WLmYRnkYoKhjfvHbH9I8tGOg4OUojmlWGeM9dmIcwT-ZTKJOGcKN174Zgy-Zue3N_p27SGQh4xoayV3Jo0tke3zJUPtdsSmkm_zSlkJ9VRT-pInkQMkWnkiBLlajwd5c9yjDSVkudbGLST4n7yV2zWalBfc6mY9Q9Fm-h6BjAL2mtcAHxLilCUcYfENkggWa-BVjeUSx-vT9wSncLUfaFEfXqvyrqeBXT0_XVMLOqtqyY1OG931YZMBtNaPDRT9hbPJd5uJVp36dmOW8IHkrSoHzT-9DYdWHsf4q4LTSefQ-1He7Ch30yzqYdtmYhNR2ntSMpkxic7_E5U4jGzmP4xsMYY06I4V4m39BQdjM7xJ3hxgBzLGC7Uc7TUHvaGRc67JOOM8y8TX9s7Ot_L81SbOgKcB9Seq467u1WXl1CyrdlY4wzmAzgV4Qv8KloihutrUS3gmE5cf1Hf6CZd8cRkoBtX1FC-kgt7newQKNqNoAR9UeK4ESG_9RG9ZFGYaj1UeAkO-7raeRgcA1H0r5ArZRxaq2YkEdWpYuypOZL-V7IsrC-nqmj7PKLm0ahwgBly794k9_XZP5A2osoTz7SN9ya5NTAja0u4Abypj1kPRLUA4VxJjzz9GC2aWxehBk6QBal3AyZEr_qM7kg7NJX0gbWD8YlsmVi-Vda7KNwx64oDFQmGeVl8RGo_nto05NIrQAENIsSre_zxmZLyV4bKVqeJmIuaGio3hMz2MT9yOA9dAdc7RuwcXtw6byi23vcLhjzgtfmr0681ezgnko-A7mXSdjX4f0uQACUq';

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
