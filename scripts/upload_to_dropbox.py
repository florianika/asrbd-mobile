#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGH2qw-0aaB2MZyXy-6_cuM8kNF5BK69megTqO4FuXuGidAfAlhbNqMxWpd56lQQDk4m6VREym4Z5HB0w4m_Dhm49TtvYiTA_gRaT-LJoSU4naip8JU2f9IMUyPycs6SMeE0CcrsjUsvPBO5LFbmiQVVpn5Rg9rqu6aFiEwZWKCwzlbLaeMtRrMvSoJaqNnthXWN8yh9uMzG4OAXKtdRY8tWCdu578ipng3NMq_6jz6ZVX3itfKt3-f7iLckzVsEhqgEK0hmX9_DPmuGuQ38QW4l1iFGnq4UKiPt3ApeF1_iBakQREyd7T6HykOxH-2aolHYfRU6qMNjBwfgvHafgRLoythxYCcLZvzgpfPSsxN8193mnoZnA6PS8U7HNu04vMGHY4dQInHAwuLqW-WRmRxcR_Mipe8vsp_kpLheNGSzxwsfOySReH4yOeA9s6YX9ogqIVw0tLh5PM9UidjBWbnuHZrkaxJxVTFN43S8qTj2Bktlau5F2fKsq0O45pZifMHNLY1vW4Fx29zCoYGhMEzgtY6Wh8O-V1LKDZqM07qlR5FfApY4K8G6rLtS-Ug-C6zFh2uYxzmudy-xeePhk_TTJSk6n5VqK2Mop9BymH9VSM28ft8DpG-FPZWbA5jjO3opSt8JoZN2oItbkjBqzpCJs2gIqKttnfAOys48p320AyxHIVnPxMc-DCYCxl2UpN5-Dxm1NyhIGl9sIPFM4YG9PBhqUrhM8XeKdk0Uoy9MApdESbSync94jALSo1Xx7pThK6TVvW3v_VwyUsge_ygZGLxnuumckJjgyrUVwmIjA1lNUVUdCOeUkSRQYhTINOb_tPcpk3XCUzvxxCfXSP-L6O7R_bt17S8YzSqaN-uyYnkjperac5Cd8cSNN3awUTP3Yu4K3htznDsHuZFLowzqzOVkMqFYXXZvSCRiklxeg1-gZswox34neHZiGoeIvbiMMotoOWkJ215mlpaVURAB_XIxDb1TZrTS4FsMfKxIxFie99LcGNxqQSxrY8k470V-xGFOyMSAYgMeowi9K6YuYv0Z5j9tcbj98yFXGWNBBGWqfJreWpky3z5bh85bMaLHGrGMm9YnsIT5rgoZBHcEycNd3s9Qr5fzXEhDMBEs4fcxftUif3rW9_1Otfg5lnxwzRDDspoJP9GEspDOtg0AVJ1YQKPJ_AJAxZxq2ZQuGF589cOUVxsRUqe7Au1bmYij9Ide7ShuH2xsUlw2mo4m2QSJO2qIMFGCcKCcg1IfVeg1fMY6hXbVXhrhj-gUtKi74I4DqdF1lsdH8BkI0cC9mt1kb0rK_asGw68GZP08VSxrXEv4HnI87IFDi9U6OoTrRsyZlqUV7ceLEeDxl0RWN5_8B2XLysMo0m4JepEA774Vnk7atrdBhp7yoovTsVX02P7wWoGLoWMc2JDL8VfZ';

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
