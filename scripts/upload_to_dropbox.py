#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-Y-PzfPwf2FyDtPvip2YOKC1izJ5aRpvlKgCOgAw6NKusoTU-LZ7M1C5wsOLfEuS1J23Tu8L4mTQSbGuUyztTGQLMOE5226zNL0uJEHg_7t4YJZV8WghwX4QJcpzLvppsnnXAQeCwCUZMzGTo_3kSZn9k3alN4rDw25dZ-r-ZBtqEYC6GPyD76Yl1ekkOyt6Mqr98qpxDBHan_U4rDjLcBjYjO5n6kri64l19_Y9S2Rgv9snREBRqL5G0-RnjaeCpZULUhXBYxLnbGzpqL6xgFyAjNhaTh5qCj1AvRlb3n3zckzZmYmeyRz-dnn4TusY-OQt7M7Yu_xRGz0-duN4wmyaViPGRVt3a-pSKoU1VZM0dmpyNa0-6L5K2x-254edL87u55pQFGJcZ23Zn00ZEsZ-kEWv0t0hheZWx6a7jLZnJJo7dP5T6sGyXT80S9CUsyD3Or_kqyrIblJvUpRB6mScFJHpKh5jC8BiybAHwCAGxm2qGNVt9jrrW00U9NsPb3zJDqmUuSEm4M6fZEyeBQU4qpj-83aYmrnMa7NTZ1hwmerZy0ol34eSM0_XI3hhbeWOEuaw2BWCmiVO4dU6UNTsSDdqSgd2VeDiBCkxiM2mi9ixmyLoSMVl58o21UxirnyfAYO_0emuqfFEQDYkTXyzMM7gmaoNHjzbp-qY3QQEbpzCDD2C5kHhYyNUfBuApRnsTSy2tSsG6DlorAn69HZOz1TECEBN75EgXxVXMKARFN-_LRnZZj4l80N-8qDpP1xOnUZB-mmgG1124-N459IsFDw1iRENLK0ahdBzKffiBYw9Qym_Ma0mqElMj7YErcqSDVYwBdwxuFbzPprn5T02T7M-5ozjLdUHgjHjApH-4wri8u-n2yAlo_JdkzY9y_YM5x3k648Fs6WMPYb5nChAWgEACk6lnoAUFXXCZQmcTeJODUe8P_V3XRjSahRzIy8akckGMhwVY1zAIPSOhOc2_V4-EwU6igWpjCY9Zfy3inE2A2BZgDmXSVD54zIZAJwR_rGo7TQvGCAwTFhOHFStxl-OCcgSmx9qk1oyg36V0bM1r2voo4DXgBtN3jezGq3rT9OcKDRq7f2917UaIhpZwvDi1kl14B6qBUploTt_N0RgBFQxH3Vkkc_UdcL-YKJd-riG1LNfB234hklxvB7_K-jHbH43wYxR_0-UuXoO-XYy_MmXn7z62pHWV4f57wWEcv8jQSCIXNwWfcT9oeDDjbhQdHskrEW7N2TLNLnV68V8rj4HMn3eqsv-crcJwErEy8XGk78s47Px1RRskVh3573ZUvYKEOpNInaHEj2y4ugg4RDwg-rIYpLXbmskx7a1eKxvcyctXIH6_fZdBmMkCkcetMkt9W86skLTmy_mdMQnKDrYqNrV6qWKSSvvYOibV9Vrp_XtdJ1QEnRB9T';

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
