#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGSDn_bzEGuMS3N8Kc7Ox538oF3myTunczCcLq5lq29m9Cx6EPSjS6G3J24CYKQZiroMWz06axnWl3IZpsTGVGQnRbMDgVkLg7OSU9EM-Wk5qieo-hGsPeWGFzhX9bmrCuIarcbPhfFS6bPJYEXynqBgESuCn5TNsrv2_jlUvc3zTXMKZjuwqV5-gRMGDwWhUsEDdrRP4tS3wsjCqhFn0U0nsuC_DxkJXggGGwwoOU_NJHbT2ii44ZX9Rn2EQxPfuPqatCf_BKgYUnzMX2Yb062KSEHerRw8ll0n_XCckdAhw1mm4cynt_Ke0oX39Pv0TPMYFOk4vq22ztuQ2H7N-r5aScGbbdPf8iKOHkQSN_B8mF4UV9hlOoTYVQU5Kv2LwrW5HJuv1KuIejFGPV9I6tvL35hZV6BdaYq_-cCmYorjPkmupZM4En8v2jF1b04tdK2FcPL7KM2K9PQddvdSWBBwLMr9pn7ZNi6g6Zmcthhz8vWVfVmLyogdMj-YyUjhBWmsQl0mk13voVIJX9W76lOnGsEXLsrBfEluajquERXFziUJdW5wti3m6E4j6C5ID9z2L242p9EUXwuFp7pCeoHXN3PWF7u4BD_oTTGMzY_OWJrTKn70yBw18WWDKGsE7uVtJnruCBYepMQ7eRdMtL8fFXoMNZEqZkWE1MdbYyXlESDObjB59CdpNdMUlblIpO1VY6sSYwMDtRbQ8j-1kucUAQIBSFjVKsDAUhQIV-8hpmsmxrVNxuOycyoGjSklP4N0Jj-SoIMDoKl1w8gojeFlc4K5lkK5r0y51rzPd-NY5qW8v2pjb6c32JB18qZiXOmaMx1YTKVzgxc4FO24o8guftTDNh3G87GXA2IK_vQnRP17i6hIoCOYXS5S2Oy_g7_Kq97UkWkVtw4YxPjzDuxWYQsRqhJqx5U6kbjd2tq1ikopDVxslIrUGwmTc6tMd-wcjoa4XQPVulUCt0f--jkr1LlK-nGba5dMY1n1ALyTFyFxavEzTxHAnS6ETihZqLKvQBEWPF38n7f-mRxDGR78z45tcieotcFTWC8grQXOCr9pv_sCod8IUae_F6qDCZPGELB2FfruiS_ZSjZW1-TbKi1-mmXO8LrED7wEt6ruQz8w6ihqW21iDaGyUg8cJUTqz-3ym8b19jzXNUqDroAlgoay-6mV97wb3niso5t7TjsRZFfbo93bJ8CH8Bmqgk23knTvuT2jWSUDu54uR_GRjyXyQL7GgUPiko6o7RBlBJy9517KO-831qtbbNMMt95y13jq41oEeNrUlkIU4ih0-UZiWKtVG9-i5QgzhQyI1MbSkwN-44RBe2on2aRK-yc2uHqcZQd1JEKheFo3nUDltKJA37wfXdw4y1nK4xCYH83zGwZB-3FgHo4WGeIPUJ-s2iSgdoZ0APUpAuZscVkL';

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
