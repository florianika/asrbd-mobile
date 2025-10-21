#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGDGRA0W3GwhSuN216OQ_urSkS1JazW4AjgYDdFbGh2jBh76uvkhYfq2g3QCVcIY-xBQGViwl2FJzQRG7dsTBjNyJJPQQ6XUlaksiWctCNyX6XPFITvmYzrgqraC-3F0NvhydQ2LiuA26AikkBe3sjTmJFfMjAD-bqUesj3UhDT995E_T5mfsRoSywABctnIrB-6uOvtbeJjB8KvZVHhaK51LA3ErT49d9ivvOZtkaVyUy3Ajx8N0DGjlTeYrqtD8CyPdzAx-jUV4-7W7qbXGYJp-Hi3RHJVC5VWNPfByBjtV36iDTPaELXSRjTuouFyNaO6FWCTOkbOyInjFKK-_-CRYjpxzMc-SVFVJxPgeFVmPimTw4CEPv-sdbwufYGec7_bbjUucGEYMLh92s3eKO3EJTXRPNBCgTaJ6ByVedbv92aVi1y-ucRTPyVOOnHWU-Jv3pkr-pK0_XHRTyOPh628JjjCc8MtDzcR-Trl6pCTXPRac3qcsoDNuVmVAjYjVdz0L9ghaApGtYbtuSJ1LaiqXnnbBFUmcCQq70dOveeDhArdcBWQSBQjwjftFabGXg4zzX3yQcPeFU64RK1YGnLel74JC7m30sPlf8qsXTjlklkJ3BNhYCKr7mZQ8KRheaQf1n7xiigSw4-nWVZklhjqZ9D5xeYgxkmABKeop_jLWBqwpWDeh1LEWecjOZSbkviF2ST4nY3r6FbIng6VBbtlGT6WOcENvh6ts0Tc5vMnfTtTeMgAcxYqNY6aHnSifqeoKcAaeYH8Ea4niX1Q7i2bTEWLoJKDhhwx_4FB-lVPBJwsuTKfsitoJk-qZ5VhrpnWz0AMddxVPkILLr32LQmE7lrv_A7LEdIQPZoQ0bCBkCrsaW-AibGzIhwV4FEOYttRxCFQgzetoJz58z-S95ZLWGwTQtpmv5xwMwXG8455iH5kgxFQAGl9-Kcsu5db_dY-zsZf8PuUlDbOwwA_HxofMG3S6YSfe3HKtI9cNgZBL5oa5FOVO-DQWBv37WHZhBGGzOcErVlzL3mq_NVRj7TIIy7c6MuNiH8SJFMOmTae-HXtKWlr1kyBJkMoNIL9mriucY4xHQbN9vExmY5YIO8JHyrZRaRGtIzoJ1Oi7Qa6Vlg0PMB3S8VJI-oAeKxVq4CGn-L1XhRC76DNNVkNn_O5gEcTRJHZpZT3wVgj9tY0thFWwAQmVJjKmOFA6h3oFkCdu1AMp-wGjoJ4FkaG-YXKZcHTU7qD-degYDtnGoNmFzpBDEqraz15uyf-L4uoc5jJfx-TJymFFPzqiIAJd-8bTrVuQ9TiEjMa9RywV8eEnHYB9y8EQlgfFTkDq-DyurFRRq7ojbpQ7LjpMK1-JJGoBuFWplV-Ll8_xnNFYQGyjuMSaCfC6fu23jwLbkewP8V8_y6JjvA7wGix8blot8Nu';

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
