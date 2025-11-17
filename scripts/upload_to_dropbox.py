#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGH5ncdVPNczrHpUdsZ0wTMnEP-wwavi8YyoVIpCzDm_6lcVXmkfEH_uOmbdUk2CJkDY8htc9GegoDOiI4Wr9TIXCeUf3IBv33vlFZATdoNKRsdc5aoZFGcX967Sdq-wWrG8NKs5fypbef8E-LEBlNsVuNRossejPzED9-Eg51_A17jBn_A2xJw0GYZs0_l-R9i-VY9J3QfH2RSIzzSGak2Mms_I6G8w2KqEZmD3ugTpihMq7DjHK_payAQ1f979ErrMx_9zHSOR981KNW32eskIupticnHvGAh_9vuY1OlGYggbvdeX-m2bjMFrdzEB9J3oalHVlgk8t0GomCDWF909iS5OGjTnC4ygM_hsOlHBOhCrZ7ca5GqwiP3svSMEk7wIEl5r9EUNJVf2hajVhHC8y37EE6cAHkdhMSVOPQmTW5D-oajKqfusNlYP0jB9iC3Ni5xrjC_Jg02iWMclGtb5O7LE9E8djwZBdhIYdG0VzEVo1ZGsRjb7pUXuILQLmIBzZMb1yfHBlu9rMjTOqiAgoJeys8qazAqeSapCmYzveDIfYlU_Iy_QNp_hb86IM3i3ea9gmK3uzQzH61YTlmQcsnv5p7VZD8rRVR2f51XfPx6rY1IKSZJQklz5pE4VdR0UaEcqo555qcrcUxxiRDigontAnj__nEWAqSAgtkq2P9eXBuC70QnuXBkYXpRYHVyAHxHm_J6oBSXnauwrCjMuFTnHS1IeMhILa7BahXFEp0cckbo503s4d0GH6Lu_SoMzuFmFSQNLJsweX6Ie80GbFo60Xb2gKrYkj3ZsP0Dtmh2JaTIyVAWS61ywTiAL0RcZbtlp7lZvlh6-spalFDyndzEMFxaeEiIdF-UtVwanrqxcXoD6DAATvewZAgYKMI9zO7FAUoNjbzVj4tHwREZkifC46zjCGdoLjP-Yd5sY4pewPZfxFij7-wS8oG4K4rBNCBnGZyxj-PsTPP7uo5guduVlU9K-6OcfIlamv_IALdHP6a31uwmyJqi7L9DJUhKgfqjHWf3gcVQXjsegV0S-3bWIj5p6EqX4moPevStCR6aEYLFBnAbyNmjKlJ-kXJaPqo5i_0Ty_cWXUZM3pPEUUecplkOsZ1CYIxpEnqmh42rdpJ0Zv0k4Pl3_zz5F3kXjsg0OmDfrUJWry7_hTqO5tdkwyi9owgwmmt2irZMpMOnUcp_C_QkPe9tbhKLFufY8eLASb-xkyj655XDEMkqQyz2mMMnQUqd4GzaOJqx95hSIXMu2Pj8ZRwtGpIIrmy9fIcLon02Jx-nqtj0KHIKtuo-uS08lrMbvx3nfpQfvs-niyDeHnPH4nYOpUfRxpYEGpfY348f_sEzhIwkwyoizyjhKgArfv8mNX3ccX7m141XBqni21pIIBrLFVhakSbaWSGL516L84xXZ6eGHyoH0';

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
