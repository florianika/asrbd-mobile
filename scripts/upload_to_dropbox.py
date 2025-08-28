#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AF-zYzlb7JjXdUzTzLxMv-3s9s88Km6AZ0QRII8hM3rfz4lzb18ZDPOCQOVGeauzI3tkSOX5zfWjeFVoAK33zcdSn_4v4LAmFz2HraVHVJbHuCmll9qMYR6Th9aSSmTwKdekNikcjLirdjRFv-v--tH0reMdfSSLxURjIHJmfUEcKL9o-cdl24FUBBRDGxm4_LZwnNwPp2Iqi9nql9RJ5p2d2pg6bMighB2oDdyiKBjSYgmJKjowBdavrSo6VD7Pi023C4LLPKF2zQsv0ksdogn6qcefJksTehgyrMgDY71zTfNYTX2FImeKZZAX5fxCSc26zX0JjRbfAjhlRg9Hk0JVnj5Hu0Nw_v2lQMw5SJ8y6cmptKj2C-v__gQ2pQoTIzdS2egeq_kO_2zGRsNivpheV1O2Fkn538O_n9VamtLGVt5_zLmUO2S5H3qx4YFs_21XaLtjljubwjsH_lkLNcBqZayyasdrnqJDSoOpSb4M-K0byKCcACkAFVSMqVQfJhKYyRUX-WAsT02IG0blRIDRwGe3P2fIkiKQ-SEmwUych0ONh6BRo8K-gmxLPZOSjmad1J25zlGPsMw2vuWmFLfO6PiIPCcxFzbvf4gh78dbJ0ajUWIGWTGV_odJSgMsyI5DZU9gX1XYGQlzFaReGubevOS342atGlXM9-p8LvLMo0pknAjwXRuLHK2ZS5cSqNhjLjPGf9gD3uW76NKgpQ0684BLqLzAOn2JcoG-zxoI05C6Kr2Es_J6Kv4-h2U4RPbAqp5fgjbhhwKxV5xw1uUGCcAoz3Sh6leA32zYr9A5X-W6dxZN5tZOE61DBQtF7wYqPHJbyamMw5-i3D63voWMIZxwDnnbLraPK4rPgVaHTQ-xEhb46FJU1x6lh97GRP8TETdzDaSFnhQLsRq0FH771BxI5KkQht_Mb_fZoRBbm8-ERD4qEkmFi6r3BKiplN2s-QF6sI3_JPgFYqr13Ie5HUDJ33OZYXAZZ25fYWKjOSpvIgcVYkqodm4D0cx1XiLr0a3v2ga5sQDDFA6YVtgx3JNDJBXO3UIGblsFQWrYuxmQfg6ILBMxYdgqGEF3KBQHbqchcBsazvEJrIbj0DWhgFX1rqBnaLrAnLeYTzWZxULHlH0wN-ttGJFIol6KAS7E8Nn5dp3GCnfah5wRz2VvRU_4bX1qoh0VtvS_M63fytjx82xN8oJS_yIFb8o3_Ma7XEJTb4JoeqaAN65EEU1IXEyzdhRF_U_79nUU-P5NJsHBYem45GTehx2U2csmHUxc0W8zH-hpN5xCPwzhOcm7SvM2jZxN8M4b4wW4jcdhPlhE_ILhhWQJ_eB9jSbj_n5sEXs85wqw3glqrpSS8HcWUmgwqTMV7RI8nX7o_fKm_xz278VrvGWLw50osQEjmfeRoPHi-NxyEbCOikhHEbKI';

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
