#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF6zkYqrAEiPVJpcLko4mx-ZxxAcAF8RXS2Lg_6V2aQ-RJU6U9LKPAwzl46IzeffJ32s4g8CSIptUtREpp-yWI10aZy_VEg3IDoT4dKP85STASmHdwIzYXFiOK6FvMPskeuD5FHGAMiIdB2VMk8rvTN9XUCRsQGetG_TB3-MjKby8Dwidec_G4gk5LFk_bzn2Ada1_NVqyw2uNg4TM8m_ziJqCNZLoro_DZROkbahB0NjAmN_2PfZAHFcHZOvlQhtgyuYeh8fnok7xFGGxrM0JDlysH9MWeKmV_XOgJSASpFlucwPivqciJJmUC9vkPrkh4redOgzkeKKJ6bF5EM4ZQNXJWsWrZDvz-JsUwvkV3BOg6gd8Pn3XY4doL-18g1snYoq56pyX1QB9qXHkt_zQ0KLat7_ZSFgPlyOkhXPww8KWwMgXJDxewF51eAwJYefo-T2w5jCg9DyJWAbfUZ7tKSQAZrHmkECCLgNBGl8kXZ5vXhkVIDAFxy9tftKSxATePto9NGPsim1gKbG0lCWDWtJAad1W1UVJXAKVw5HmP8BDgkUQ6p5-7ORx98_NE1WJ1Yg3GR5fXoTcDvyz1WyGBmkOQy5A3r8LDHHomFbcsYaC26LEQPrQSoh1Ss7j6Re9yuT99i3Kl6ljSbh-su19ZlhpwrdAoLFSbgllbSMRhQw5EiLql9PpaMxtIuGSDTzrAUxqpBrdKjbtmgv7wK1oB4-jfndqtG13u0LD1UOJrXRkP8xeeG-D5t5lhme6M1KOKaPX4TzJjxXOgoOuey5qYau_fJip9bAGjEwVp3TF2J5FZS7rH5SfjHErKAIV_tpUvRd1JE2nL_o3rk9napWL-rVtTbl2ZiMZBZL5z1F2Z-S-71UT3wJMbV6REgF7SEd6I7Ow4VbZTCsJSIzn75sxVSsf2UeH3IlAiG6FIS-LfE_43PbnNM4Nu1Rse6WlbAuzuY9FolzWqjFsIApaYfnywhkFFe3VJwKtv0JoRxwGapgq5ni-3Y2JShJxobXyWWOf-FtPnZlqwisfNO78E39OGuWt6cfMgdGk6KJkeM1KIUj6zy0ZDLwF2TIixQQySRmTXXnlDLLDNq_LPndCTXnhR0Sdd_kQoatamh16FzxQlLF4BuIm-8gmg-mAlEVNNjDXwzmWnZiMsInGGeTvcN55jpoxo-UWfJ9c7VEc6PAFfwFbStJxAFMHXVCopGURlsr9h3sfqsTO79tPCkuDRModqjnSm42OmvHI0k0q2TJGOrllc3I32wcA7ZAogPdsBBMdlAHvOe3g7pUQE9nGM-iBmY6lB3A8A8xnAdlC6zsgnmNrDuMJlByGoZzqNvO0J-e_Fvs-Rvqee7LbsUFqwZmFyNuL5j0I82OePqwA9VbwFHSTHFWo6MW6BLao7vijWxImtFqFgJ7SXgm-CdNk7jrxkC';

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
