#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF_EFPJpluePXgQBgS6vf0bmKylrqd1BjSkwi7Ibc4I5hJZu-f-Bj9455N2gXKpbYlS2pvzcryU413P8JE_J2NztpvySpslzTTPXjj38sQ_RE5sCDiply5bNgMoZkcobJHctSDA0KXil9B0XauSeNZFTm6xTOItP_jK6SgwZB8aDoCb94rRJ1KVVZfxKw5UndmLad80Q5xi55jSwOw-vowpRuBiS0SwNBaigD4IWcj1QrKRKJKhgWD0qIHOnbwHvv9FJQAnba1zlxZ822OC6wao-nhFSc40B-wMtTpN5PI7csM7OhHLqffpIwcmPzFPkMvTMKSyowAMJZ6XLCvJTNTG4qea3Uz2O4_yaoXGKUmXXQ4jk6OYko2Q3ZZyYsN5RsWR99mDlkF0HRPcaN8hdIBaBp-KcEj3j_zU6tUxK0tjsNhnoIXONvT6NCUAT8THgoTojcJdGnodGD6m7nU7TZa1svueJgexp1zsPW2AwjBp0UlrDCHw3tZxZK3QGKtEjqz_6eqLhflgO64ROTGtVM25bGh_HEW_1HkUHgmo3MB_HKzxKjkQ-qYvqJu-Uxn98eQAKrkaCjMVIJwrFNcsdU_bUzBZVNAiUBHcMQ83z33FgZpx-40KOuAjcYvTMXeixtJ1m9tKZxhbv8tZsSm271LWj2viku72FjO6WSDtAKXbVpeyy1xs92S_5H2I33uDh30HkvVse2Ke5RHyytxks16IUHR7n0PsojhdWwbsVHe9rQpPkk_cnvBJKuIp22-JbTWMtgW5nDJGDvVpGXl-igAoMioyesrxZdr8ndYUuU-GulBoVA7joFvHyjv0kZl91yrk5BnoHm_rW1js6a5jv22_Ic7XNkx2EbZIpP-JP9NkwQwXkUzWgrSQOXoyaBBWl4aIFf7F-tIfL_JxBeUCxMVu6wyLTNk3GRhsWKvBNmYEPk8-ohXfvKtJaqB4_3kTC602Nwu2P1FPq5zzUL0IQ-b3Boiig7SvSjH6BZluRXS4rWMKftGlv3yeOdxvv2Bso0E_30Afo6ur4vciwpW0eK5T7Jjs3rXZHzR1RJSINAU-xMbeZ55OlyuIxQY_Yj4LM2DtvzLFjRHMSAjrB6-lrNLQVm6lwgQQ_4GEh-F32pZYjpWUdhBAcuRqL6ue-34uYuW5QsuuO6d3Tfq9Xh16mOUp-ESmMQOfo8wEB_qA5UWimNcWaxRonNr3adNsQxioyDygeIERgrnO95I9LTHypKDtXno9SJm6-hkiKFmdfq3xX6JXUE1D8eJHN7apOR6Lu45L0DGlivm4zZf5iDMw2HKVOqP-S0oJXDuzoMIJJTiObLM-yXpF4PjSLW4um_z8C6txipZHezkqERs2QxConjxHpyzog7393VrUebMu7J3Bs4xZCceyZKRKGn8bFBqPCpnB1kOzEnvfhTyU9DnUbFeLe';

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
