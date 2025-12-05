#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGI9ziInVZsSzfyRL6c92EHZhaa1ycTtlkxrmc1UsYg1jDU-9xl-F5vyAHnmvBsEj5JdXSQztVS4rEmthm8K30T85IKKmCK5hMuiuK_s66FXRmjBn-Woec8U5oVAkgm5pKjabnpNHm9o0nEOXerwRYoHNhNngvOBzubNz1LglxWnXAZ0qcyquJzd7YmKlJ1GbD60DnGX6h9yHV9cBzlMk_Q-7p-E9Mh9manqJ7rJMIO8dNcX3W7o6jaFM6Rd6mvVs99uN4TuyKtE9LXwDc17YKwvVC4plzO2WVPAO3iMhsNDqNLAUShy4j1qVVFaD88adryG4sr3Xzf1ZT8ZSPxnVMsWLYeqTbWBQS4HUmfpn_Pi8Xzd2I6jLvF5epU9_AHrlD4TvaXMZ47bJJeoqXxqCHhfr25Gn2gltneosqaDW-lVpQXmZ6p7qsj9pOXBjj44PCZMrnHA1Dp9Ja1UX5zIQN8BYo3POg_G1UH-wOHJi6-HoBKN7aB2IP1VqrAkSL_xwINXgydVOGIEfHwzvW3YQ-vp4J-IpZZDvIbotx-v-biQg8xZEJ7gxLVHE2Udd1j8T4-HNELCmHth7ybAwVyDWIwfUEgIhHI5fgQRPU3mIKrXL2gspU5p_HCWnDYmxkGtecZ4LazBo46szJSp9jj1V2QQ4HOKT7ChRtz4vkKgITtZXMD2BFtU4qh4IoN7zezDW14G2zCp34IUYBQEWifowPMYBedtjizlsUGT8JDk92y4cibCcnslqj9oUQhnqgZf4lulf4fsZExihpjYm0hV9nx1k5r1gunXv0c3NIwuIQBeq-39fGT4XZP9DJ_7enUryg3SNs9Om1ngRpAmoXqgVBCB7VVlU8zOF74wGxjvJUllPs8aqhrgWyJ6neI7FgN0TNhnRi-p1oNPlviqFjHjf12HCbU9QIY7YdKgvfbMjHFbhQPgjgLKHoy33xfaZsF82LwuKy5aLpQsH4qMMt0btK81TqXJgDzl_xThWfhQ1iV_haJMcwBaTCcxA4oedXTd3e_dB21j7D12JqO32LJsXMppg7e9CsIlYIqjUAQ1dGLeWzWpa2M-35lfKelDBXr01ThJtRL4zW6pIXarqdXwrGpFMYdgWXy3KWHSTVWVHG6XKVmp1ObU0kPipSgPTmAks5cYlL0fFzzwog-EfyZuQWIgxhGZMNao17R8aJqTkitk0cSWuvDioR5iltbt5pcLdfuVgdfZHDssNl01qpuzf6P_5zgKvRWefZaL6up5rZzVYgjuj2RKxoLlCUwqh_x9jMmBSwNdZw_dDW8LYTTaOzej1_KfcCjNW5gvR6QrcSnnSkx2T8jCyB9LtATyJnMouA-t08g61O7qUShM8iSnQZxNx0KI7HTM4DVMTuAyIFyvOq27u5SStJBv5XKH97HUACPgsNSikAQdjQl96Ec--w_5';

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
