#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-GlYBzNoCfPhMFdr47zHgLSY2jC8oa3DOvR2ZoY1WTsXvlUMOttMNnwqRR1lHKtjUriNRF8W0tMT60o0OHA8DX-EKZ_PjkwjTdt2IN35_yQhnkJ5wVAmcXg8hO5ZIKbyLBXJM97mCe_kl-1zG_d2_VH1opRw0XOf4H7TaMFi1M4uOZrkXK_CtmY2HUKQducFwkl2dngRA8Y3HZVZ36-U4VvULqfv-HYbvm7UY9phwrMlF0sUbCEIgVo6u4163Lv191Wvvq0YuhfM1fXy_J4Yr_ftCAqtZ2SG-5UKfDNyiGYD5U3vEveP7JltY7EEYAfp2999YJEQSN9a_uhQpItHMAauNnMIHPbOvfvxNdWZOFHajfIqi4zAV0tRFgNr5-eALh85WjHJbA-g1l8KcjP0Gmkk7kc6iKPvyECxlMd6aNhiJWRMexkcxlNH5Zou3qLqWsveM5BaOhHQhZDkWeD2holSlmpaznXcvPHDmmhdmtyCz-RHA9bCeBgGgsEzeFwDlfuZGX_bej36TnNoSnVhPwHNgs6YYvAfjFbqtrDTuDir8teridBYBi0cuGTcJPIl6mh7l5YqMsVzBPqHMC5Xt0xU-986GI8VZ8O4MRn9KdP2Go3toYZEpBJEvUvJ7bAz_lehF8QkZP6CkMsxwiqKjgXFJYGmOB9fqhSDyTgMz0PM7tslMlDd8cLijBq3yoxI46Z_objlgICErMUflqCuy2xOAYh3LgDreXetP6Ly5M3pFIJ85Zz75BEZQg_YkEbRRLz2xnyjZHnDmEZnR_LoHar-w2owDJrgIZD0-q3-1cDUStNzfAcZhzsaxpsb2UF9eOkKHvNL-CFiYdCQCd95bahzpz8PwdOprGaFb60KtJ8XAfl-zqwnA7FR9PzmIUYmuCF3XAr4j_2WMVe5j_AioZ_5V4bI6_sV0WJnMkrT0aaAq5jp5iJ4j2m6Kv0IzemP6K8p_EtNTX4gu3MV70_-dSMIfcz1ddVKaPsCjgp37DJOG7x4x_Kb1aFlieUG01GOLgqMv3nBRgxunJVmqmMYa828Mc6_yMfuEOkF0nMd07_YDt_-rkUdNSIGIEXBI-Eumsnu2DfxMjzdZdGDUf283B2f30YQwbygANv_khyQyFbrqFUqY4k0kHmoaSJcEF4RLc1OZPotKC8CPjg5zjR9qS9zIZ6vziuT7v5pL1LkmBOR4cga9fm1C335aKaq9y0ZE-A2rye2tfUG4U1Q2RgjqJxtJnw1AylK4bluks6lTwVeNhFdAyT1vSpI4UwNWh4j1C_fG1DzG1EhSlD6ArIE0uPqw-zh58ra3e_DQu4I8htvFLsLIm7-KiPbJdR8PNKR29wfR_yu74rg8Lbz-N9hhcPB4yXsiA9yMLC0biTLW6Kze8gDLVcC-afqnGroVanTZJcq9HSBTbjLZP5bOpBjyh';

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
