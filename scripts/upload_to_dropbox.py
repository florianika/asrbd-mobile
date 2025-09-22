#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF9FefyUrp0ZPwvgYcFvz33rP3cwf-h3qqev0KE9xLvWXITjRojZjL89LXgOjk7OGXxY_5U6ZQDgpBk0bqhYOqQyamzRQVTi49dxQ_dhlD24F99Mu_Ig7GuKSLdBHY1gs8YiTgib7UV2VTdgjT76q9wNrW0lW9jFE8gXC0WVHYvjs80IYxMjnepLxyXGIi3r7TpErwq_w_gOQM9FpP-r4y4jT5gMawwOiKMxyQNOZXxKWNG2n_1JlHJDmCC7VuXfiZkBcJR_8PGV_zqEQHHFqbo9Sae3-HUB2aLl5CoCBMczxsNFOiL3tJerMJCo5bJ27s4pU91kWJeL_m1hGLf25gI3oFTQMSC_yV0U9pAJiwGDVL4fw6BmM8lxoreFJsKomyMpsTAJe9BP-sGXym7tHDawAQ6LLn3_Tfwfz2-21uU5y43QbylkH_KLpU0hxf8mj8Mpse8AH59dkDbx7h1PgK6DW_wSFc8-BjMffUYtYIdaU_3B_gyZAteeeKCDQebjwP7ODG5DpqAiewDPByx8eqNayfaEK8L6BZXE1zYPQY0o722SGtzHbF0lxYxr7GvKCrzLF-X-5HekAGV6CQubhlbf7f2BA2PWmVb9wy5KG_mgWG3WJfr1QMR_OOtvtejcdS6jgKEmjX8vfEoxNY7Tr_NPFe3eZi_IZ3anrj2P8Yaf-0r6oiASGTdun5FZoiE2dXCFHrCXde48AqjM4K2OUkYKjAdsViculUM60ccLf-C0Le68mBfLj_L04uvjKMr7Y3EJcoQCFGI7UIMxoQmmzwc7PimB0Mai0yvHISAEvVzm0Z-pbeJsKNvtTr1rN2_6DRiUw8mX2QLit080fj1KjpCw1IMrL91qo5VY_WF9aVfOMINJ44ANfQYJef7-3oLJkPahTT4OI5sLVM0yQ0vBpBzsRdkvu4aGOWF_otd9S2G7QY6vFtSL_wj41QbSB99MTpdaNBjGZeethc_7oEBNRPvH4awfy1-7awK4y-ltJn312RoUdMDh7-cNl478Mmtk3lArBGdONeWF_rlAecbgUt_m56aDn-OY_ok7So8HWglrGWx8DehbsOybSLuFROHGznb06ZCrBZcDRkorfQouPlz-AHmNoYVhfkhbO4vnhSkd2Nz40-571lnlEfLurpGwR03fs-1ipxGjGDm35iBEfAum00DLj5D658WVmJ1kjfs4Z8A2ya5ULCBqnp7NffgoPFbJz3IIAHqJmeSEDPZlQX0Lp9GZykSvwTikeJTYawvqQf6F9_IQ8odWvSP-6Zl7gqvtXfVonoNdXdReH8j3REGcXKrCuvrk_dfhNAv4K2C_sxpQIejCXVDWapZ6AztdL1GMB8iD2Y6X76rMe_Amg4Dn2prsYPf7eblVGGowVJGL0cKLafHDGANY2wjNsinNbGxXLL8htPa9ebMraSJ9Dp-Q';

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
