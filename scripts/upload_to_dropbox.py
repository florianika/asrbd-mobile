#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-qg1rWRp2C3s-QHhc-WK0sxboMQGLcZZMWKbYcRWy7tnsrN7XzZFBHJDHL5sp7MajYZmVD5d-pGBSGgwRE430fNSBjiHQzkrXf5mlc8IAIicCT3LFV1oh0zbF1Euh-n0yf9R9CJghS9_FeGw5QY7DTC7UvlXhMLeZwls2BqreWLu8snB1IqDyq-rwnLgxcAGg2pGeJ0ht92n05cYeNgmCc8_PJzVif6lFvGGAiZLwpMPXgwgYQIXA6QjmOwPa3_DQiTpeItc8Kf1xBEvEVj5TWwkVhRLbtuYivC-VaYy71vtWeTR04VXO_x5e1NrBaEC3tcjcR0AEN3MZ86XDYpmkU9PdzPcy4w93YopFScrry7ke5s5IhoCn7d0akfEUalI4E0EVfQXpxaMIHd1x8x0HZV4Txpkd49VL_PtAQ0vXUOkufwvHPBnEeGLTBf2LPBfcVMlS-VExIldLHrAr7X8UeV4gPSTYUNVp-8SShuz7YnWcTb1kyfhFlR4v7nv4zrdnKQoBD2u0CgBVynDubO5vfeJoU8Xqcw-sQLHavq_3r-OqhVzpQKvqmGkiwEdaRjWCXr6L8f4KiO8QpMro6VOKxoWAE1vOK_stibXdOWdGL4tntkoyVW3ZG8Qd88yJilOIfoz8XG0nDbCKQ_J45w1EE4bpQN2XczTUhKyZPRGkKyGkHXfzBWAgGGZ3VVscrxG0GxfRhIyyezzQCRTmDbt0THAbFR8Qo-VCyfuQUpWp48wb8ymbwdSU1gT-km4E10tX2yE869crI-JswTdM42kSR-RMP-sY9BOoNx87A8PFj4Gju8_b4pSqJKN5UZqvRlShUEVSmP2rAD8jf1ozZQtMoy4fOSn_G9Xq6a8yqL5rptFvxxfDtZsWez2B_YeDuHVFieT6SJA7_p2EhyenH6jp3WID2nI6lSAQ9gWG_O4ouPS-7LLMokwg3ANmgZRP7pytBt-FoPRWkJvJo7Fi_fb7ALXNMyzPvL0fYkc84VzUFIg717FdB-Kvl9pBL5aPrh05V0WxXuNLU6Gcx90WHka49LzkSN38GJ9dIwFrpSRARwbWqe88rAPRnLCLv6rKsmqaQedRaR7ql59JZRCKs01964NlYkXMKk0EdemgpJCXxCLarsrr4Z-aa_Tjk3PFzRhAj3HxqDs2jwGZ6NrE1Bt33d-0CuqlylAOxdAmZP9mIUeW8Tk5E4MmPg-XWrpPc0YuAw8hgMdarVcjD2TYj_eMze2cTdrMt45haqE5oIpV5nwU5kS1wZDz_WWU_M6rIX6xXENmnlN3-BbICtxoZC2aYbbbdrKiTYkHetvNsg_ClTXVZ5bz-vDDb9u_Pz1DYFXBood7uJradZak-Ul1B1gjOHTn1hy7cRCd_RFewg02ZM09cswxyRzX_kBjlG1hHv9sjxu5poK6q2x-dZb3C6sp5';

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
