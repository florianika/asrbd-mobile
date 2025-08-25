#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF8_hyenPlH1OdRFN1sFPNcnq_XvjMfSH2YH4PN3xakzFvE3HA58gnc8MIqnmOHBUiAh9nmYHNCeIK495YYme3N6uWMRUfxSE0FceNY8E_Gj4eeEz56AgbTqo1WhyB_GEA0ZsFfEUrWMrGRlm1CdS1doqcv5DLnCtN_xnJezt880D66M6_1E8rtY-g8BTVTSCn9McZNVvxUBat3pN-YUkjATQlJcyXWe8eyWo-uI2eJ-So8fTi8kq3OdzTwF7YBYgk1QemVK4QPbNzE2S-uQtrGQ-L52frLhgIUy8DsY6MYnJ1jnuMniMO3tnB3V7Tjg5h61vHxAOgD_g6FACPapkVma7k1lmE6ROuQ2jABeYTxCUn_YYMTS4zwY_tobJ8rTaG7SGkPMdCV-MDLXAIpQef8LybNXQv0grf-nsR2laa7subjduIar_uT9L0joRZagYcvoDyZiV1JNxe8zPtAgapjzbr5JQlTpFna0EH5T9iYkwlwu4VfOxzxm1poXhpw-YagjeHI83h11nDxeqCd53LRFVCkhszNuabuEF81dc5woP0f7ARQM93aUJtEJQlOHiIl2H4l8oW9UJ05iOR61UPefUltamR9iLu2Cv28a-nIYSEqczOVmmQu2qUL3aaz6hOMtVQw5IX9uRuz-Hgl5PZZwx09Q08ceeWdROawlWc27zualSyJ7AMkn2-VC2hw10QcEtwwzQppT4Te0JYly8LZnZNDKb_9wVQpv24qL8hNdibYeJEssJInxUEZNm804sd105_g-QlKCwvwACXTex_6HHqqPXzpikqY9XPGSJZ5uGLIqSDshl29j4V2Olo7HOC4tWR9hPMaN-Y2nEXmUuErM2DQqIRdZdgZrxrQ9g76jQ47VFuTG6JyUx1RTWLmnTFjXhwOgRKj_b10bhjEtPuhxbcua-TgfgW5cFCcO3yLmKxVWBPJd3cz9thS1LTo6OmhfPQcLY4Pws03wB6l6dMF83RFBY_n1yYm5zFE78ZauFJkEClf9F2EZYqlso_075rvFkxZMiRzZqs56BmKWpMSP0BjDNgXCuiFc-Ww9bhRIgWOmCS6hLm63wdV83ylvRfSx9Wt0NBJHVae1DlKBlYdRhiU5lq1c9bBAWqpl_tsLnt-FULSkkmg8dywMdrmTrTvZQ4W4xROF4LUw_2TvFJK1qkncMrF0n0mslE1FzPWbceRJo9jICgM1cJPuUfOhYq8FGIrS5Q_oAr8SbsJiyy0v3GLscnLBawEBOqBxyH3rb7YuMTTA9R-_VEtLGorTig3FgniMH_v3EfhhCqKX0yPiaRQsPKXTtTBTTpukdEz2ntdxLo0U7dkntzgUH2P4Hm6xMThSKl1hl72HjQK_JE5GfgDs8gPqbY1WUj4-dh3sz5jskWEvzEGZulnSb-eIjzkCPDExxzdkz32WszU0DHln';

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
