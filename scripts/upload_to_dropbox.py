#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-xsgD4WMwOmMq_3UpMFX_MAGBc2YnsZYMZJB8MRNlpYX6stiZ2kgWgq5jveefwkitgCxbhGw2fZQ-lZGezSkIs9olnt22FhtOdJi0vPJLoj4wSdWJdBsSpE_ll1xejfEdhCsj1CanPdjdPAfg_SyWEOHDeg4eNQ9HRGyoDTMn8GZ99XyrF1s2XLXFa1KZTG095ZKaXBf4nOG3dJ1w23UekcTqA-ZCGWS-VrOjLlvDY2vQ_16sLOhpp-sPo_ruAXJ7ZegG2ksV0tTb1iyDfZ2jDsJ9OrjQE9y-XjB8ZaDB8h2lSDYDcls1z_puTaMtSB_nWfhvQJNnOv2m2dLr1DkYxTmvks-OF9_uw3W6Il7c3T3A6YATz0K-FEuthK6Yk7uOiGPyxZzfDaGZ2olnYQPGMZn3wH68ii6kCd23g-Fq5NllAwdleUQZSMPUqOZ_nrNvUbeDvjOevL9AUUblIHqwv8OoM0CA4OI7HL64dQNR8ySj6v10_vqJwkvftfE6UuJyn4Iux3duGmjuygYIUMZZH3KnrDk6q_MClMirrwZRJl1NIYx6zABvmwBescBB1dR0UDJmrv76fEDqOxQM8NAlLdwWcb3_fmqgJVxhJenavLkoYIiMpfWHAvsfmgAXjrYstw0lmXeQIFpc3pGqmUCMXLHZMo9NVNR8UqdwQjoI9DswWiKLmmxLA8DibIT1Qs5czLnVb1jPHlL-_p-ApWpWpJecyax2JVwnR4g3PuFd_fi8b6nb3dNYJQ-fO8iWFurW_6uUrWPtsr_YPGkCkgzoc9yx6ORxOoLlaE9MuMofLDqjY1FOReeoLgpMESYptJzmFV56fWhktevM68y7in2NabTdzmyT0mzkrxrhezBnLSGPlAIDkQQFOhn49iGbQZ0I4Lta6WdnFVb9sovA0PFl77Fylee9cGmqb-ZuwjZX9RcO6lH97TOn0lH4hwXQR7_xbThoUv8KS2ocnTe6QoKStbitUAW_vBTrUyosi16ZDJFXZNduQI3timWLs5Od4hOZCNZIlgwwbhL4eWzUR6AaeaE_FUvKtTPwpfuqFWjMhtHw3NKGkTbg52RhgyFBYtwGrG3X1H-db4Mvt2ZZNtqQJDgCBxNJmzoUJ_Qd8tT0-sxvc48uAZZgmPao4qWmgKPqU0C_jwFJaUXk0iCgE8nvqeZNjDpkn5t_H-sD_-yZWV0_4QFIZAEvHEapbi1-IQFgi3bgQwsuXvtAApE850U-Hfoaa5jiv7KBo_yq7X6Ep8eV4rfZxK14lwe03vfCl8yLmEbWZ4szdsF_D1MGajshdcgzDgoSCjiggRC6A5vgvRpPe6Oo_lu03uui-w21duRXrGtGIPP1ELlBcJXi2GXMTAS5IEQBBY49DeAAkd3jhPDipHiLWNgvslv_kfO4YsolWLB5oNn4QGEnaKPUJbGPz';

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
