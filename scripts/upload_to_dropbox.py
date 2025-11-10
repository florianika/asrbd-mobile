#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGE_Eiuu8TAw5ZK1vNCVC9WFyTz5nzmAtnEnKsVqbwmAV0gGmsSaKGkn0ukoaptAASI7KLZywuU1wRtPFWlrIHhLiLo-eiayzln9pGbrs9gcph6BT2-k5lu4qeT8MY0ur7pkb776cC8Hncv_t-Tx3sCONS-TDQp38c1z8OHoiyWT1Hl0iCU9Tx9-2jRv-MAQFuKm1cAvUQiOppAPVs8Lqs1qbNxmuVQwnFbspXhlQ_ISduHQifiuD-ASA1Hc48gWWYVmFmm2LA4mjDkLPuBh2mvyZxR0PmW4kef9a0dc5hmo0N6XZBbToNkqAlPFbs1fI6z7WGY7z6tXFxI3GD84qCvT9n5O_YIL0nzh9BD33BzKgKYYJIaCGIKtB3GFJbz529OOHL2Lr_THXvr2MB_hSgMKHIRfXUKKcoW0BDFYSQZXSVNNRmQRDROCQa2mvoASajwg5uv9oJ-fcOX6jnDTTWG63NBxjKUvyxoCbtNryxzLnD7pN2STp-se40kZuewXZyaSR3TI0DvUeNY54Dr-4yiUpAKjuY1u0g2Dzyht0ZXuloEA5Ok-DCtSCH_2nZZuSXkfzFCQdFIWiwBdQTZGdS9pg3d66jztjbppbTkYkSK8TZMJ9PPI71jKTpSaa9t1d1-2XE_a11C97PNNUddggEHf-LK2OVwQkQjDCL5CKdZYRhdCZQu3rUoCS53FbvCx-YWqAjcDJXifpYTWO6bTyFxD6laUHqamhJaiHFWGVehwVn2UoaZvqWFiwutYxVRUTFyvbT5ESf7k3WCakioMT3xkxvB4blo4juUzBAzDl90_HEhmQPuQ4MMtEImpoWzcguODhYwPjG2BQTeq-sHe-NYyanA-eEU6sHa31BDD3YBieEbUM-aI7A9XN7_VgnBOLoTLSJfg2aNejx9QPoxntHpbbXnPaygMgaztxQzjJGDsj7CaFZ4kGyySUBq9DH9qUtNKV_JnWmNjLF4WJJEsoGroQmPcepWMPXnMQ1gBc8eVYw2Wuc-1R04UerqFT0SeOXcKFBc5K5X8ivn79rgbecqrg_IWXJgFCuJg5h0iO_zO61O2DZxcqbcZYjrl5yFGqHyAKF6t4i5Ub2pAKfH3AhNQ4ysgQgJKdIwVtSRXBLBTORUceK2zLkV3K6qzqRBwrnmJf7ddH-QAHHfiEXWrF5RszjjWfr399BK2CyUtInYzUS9dD-rUE8b6P-qmYqOzHP-tuL42eruAAGCE3UE1FTMmgOQoA4iAb2qt4dOqi7_SgoiGK7STv5Ura77vJqrSlel9rvGAc7hIRItnqzX4wmMYu8P58WgMzt1_EvVm6heiQPDnv3KOIMjCIUOg8clxFd9QSSOJy9yfhvs0LXCz6ZdndlsBqrU8kjUF3tOi-qAtrBcs4c3foPFYE7GAUEf6KPj0tToxL25oC6NXJU3Nyy9G';

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
