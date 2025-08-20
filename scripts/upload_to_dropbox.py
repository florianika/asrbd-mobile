#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF644XBay2DG4AdgOmtNdRSxjjlI2O0xxroq4xlrwKvlZ5SSG7LRQdZFwZNwsjibQeLKU4WXm88SCQlVa0tU07b9sSK36LdbBhRdGBxWwjO-BOEQ6La41OodCPaehG1RF-g-71s6mgGWWd5ivEIafp0mXQXq8gj3bn3afvfAUh-002aNW1Pz2G8QK1q9lb5AmjRa7PZuwHqJpi5mS1JongALdyO0PTNwNIY1nc620NolA_XRe4bJqW33i4IoCqicRlmogNgZ5P8mgx5NvWmyyAOJVZGSSYqGwN2bF7pJTSHxZ5hsoC00uVz685MSRs29OF10qrtlpQMel8lYExNk8smN-wv3ZoXO1DRA9cymb2KlL-5b1C2sdVZQMYXG0qs7iutYBvf_iTfOJ1WsOpxSNxHgGpOHOIpAHKeXlkrAeDD04sLF0OYbRj92WJoGSeIz_PKWleyFsOJHzKut_Q-3FIscrmrDI00TCpf07LbQiEY__EMhEE2JOh4mGun4RVM-ltn2P-byl0BhfJk2sC6s0FGj7U5KpxWIF0HojBbWwZrrU0Yy49kJru43GRadesnrdh8nFt09zM30aTP29PH0ao7cJAdVx5FymZReXGQzgytk9tjnOQHTP_rLs7KX5O2GDyfjodyaQGrEwnK8EUZ4tXoJr30lCrs9izi7-yvezob9auhwxUVq_BfCqeVWLfzh6iHqnsvOFNjZlsR_pa1KVIOggmIBAYdqoPRCLCiBtc9KNYuYdAaejWFRuzY2phRZa7EWdSh9oLwpgeE_hBLx5XgStBz9jv0Guf3Ds2RMFOwVrTe_2OS3oQkavU6jUTMgGVXsC2pSaeS8LIePScaxhH5pANOEAnpi8OY_2gv9Vx2CuDDbyaclFfOflXiJMkOcb56TyQaNtAj9947-VW1FITwgrZvhoYvPOnGGXyFxvRjlu5G5u7EK2mJLnqsmKoW897nf1krZ_U--QJVOZrZAXfJ_52l1mg6mCKXSiS4_9wSoi4iu53KuV9W_GGCFxY_zJyyYmuSYDb-4yoA_Kb0QyLIq2ExN7GThn2pkxfSmkODRPMhG2Y3wN-9sMxP-xkzKiqb1w6jqrKV_sNCHZnVRpxklJZaU_6Z2A87pZ3DLrVWfxJxRCz_Wmd0Xo-9wRVgvGbDDT-qWean5My6kAjJfaqqYCx4bkMjT2TL-j0Xr7v91ixVVAcsHXcGGKw-SFTUbOfWMLog3gv5IMDY4Feum5dWXiQ64cxBsWRbz7u-pKN2ME50mzA6o1i8ROouk6SkzkvGcfrGTxBWFN0_4Q5W1JgeH9eaEcJBFmTTb9usmK0gMv2momgtVUmOAtU3h7j1J4lTVSZ66t3epXA9M30LOmHT_7Tv2SS1jYOtUJHAm40aOU_Hfig31cOCIr3hs11p4QjTIyWjh6MQK15fM4USJvofT';

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