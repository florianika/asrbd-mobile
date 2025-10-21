#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGBuVUB4lQ4Mg1uTnuv-XGU9za35d8nWLpKanS3bpbJpBwttho3zgssZS5KZwRlYVnO8IX-yPFKexClUa1ALYlbzlno6eSzUnzr3txdVow3MiJKTTKlv9Eeu_71ONRbjUFh03_M9osbUAuBqj6cDFqOLhOBjHOgddkWQHJCoZ0nqOG8Jts3eYwVREvZqv863xfUSynCjXGh8uv3BG9zJZBh1qqdetj6QYwwygCqiJIqipEC8MgRu112AtI_OUzoymp205F729oazyEjLmyod3rHtJTNw2CybBc0LlgJViJkKZDGlindiF9N958tY5PraA9lERfeNlfWs4tEjmP029ahbTESmUrTlrOOzjowNIqspZWYYUE78gJjY4Jncn1MSVNl6e2Dqt9S56-sTJjlTMhJnWtZgbJ9zUDznW05-CRmyig-R2rlWpwzmp1quqwlzo2AYjarLzvBxE7qLjyU7LOZ71BA7YnzOxor4W0Z-iJbxvv7oxCTBEWSbBwQRnq2KE0FzABoEHxu04Xa1LldOTgeLucg83fV7UO14ZKZ-agE0to_GusXDVCcQJcRPlqvp09YQ5hWIf9p6jTEohljWD7DFg2G3TEsUKU0JmZNQunRwlU9X52WFPiFT-OZq9VawTw7ixlVDzECGzSMrGwj3JlTr4Z9RYf7SBYINJ9bqyDh6hMwhmKTTWfPehgdDmrUx7asLaIUceJqsTh-m0gCBG8LwKq10mYTz0g2ZFjejucFkzecBUndeGazKdveEB_537FL12jZcIDnwRGDpg6M6sLVPuzhYmzIxXJiD-rITlc9Sdr0IH9E_cUT4F5iqhs9rcYpS7BVt8xaiSm5WCJGpflyYgkt10mAnIGp6-PnPJpLFPLZ3sqEj1K80_iRry0ALcZ-EhADuGjreo-hTv2o5RfObF8FaOoUlgy-yg7dhN9UIYLdIslxkFdwfTakgKwGTuCLGJfVksHYVSY6CQpQ-TiqXQghLS3S0DrLq3jTrtD52MM68BUKcj5g9xZECgLtfG0mJFgERyPTJlKSpez2l3Ws4hg-Vq6osAP6AnZRc0axwaH9ozbuFMYzIbNOmMbSz8aC97sFB5RB2_xbAcS7_fY41NDieXuqrON6dZ9H-V_0E0eY_quQgxLIUFID-oLdcDVWPv3Eqb0RhwGIx1E50qODq2QcQZ4ZpNkiZZ5576OgD640oi3A9nicRbtnd0s4nTShhLsR6dRahb_snbXUWlxtevFvHQnhKq1JD1vVvBvNrWpk5WGuQVAyF5qE0NnWTor68VhSaP5e32nipaTLX2TI_SPjGPq0UtQpRFxb8E87rCVE5I9Lhtbzyc4GzOPIrTPtaxI1T0g6ZUbr9npHRZdx9BYOdpni9jOg7-hAVId7LLEAFu7I0_HHPSQhU8aqx9Hchx1HvxLzB_DS1C8c7QUsH';

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
