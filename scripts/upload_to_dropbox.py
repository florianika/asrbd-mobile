#pip install dropbox

import dropbox
from dropbox.exceptions import ApiError

# Access token you generated in the Dropbox Developer Console
ACCESS_TOKEN ='sl.u.AGFcx6J2AgdnnRRUzvHfyjk530Kng7FA4vGaLB4VKd4fgQmYdImlm3U6TLcY_BQ5oHjx_aucan-nBPFvLtPIhBXtiPC0hHltEp5UeDB7T8eVgr_sUzeQ9PSOfZ3_uV9VeXhUMLwcraYtQxBgbUPlkX0rU1mghPbxACyApYNbctk9TgO7pWJp0lG4wRzsFoVIye9erS_UeHMiyoRy-I0M059uB1iJV2KNtTOoFw7m4PHMS4Dg6XJkXyieEGD85go94MCe-iX64eTNZLQAWgMKpEwo0Ij8M5cmYiM16sa2W0Qz7_jPjhRVuTSyN76rPjSnT89r5zq5yi9akSDkrK6TZw2EOtJ5SpunlE2TqEqSm5gNBlMEKtA_JEpDvQb4m9eXIUbJUlEd62YQ0daaHxlMimpRjcBDAfwBLh9DYJ49tB70AI7o_O5z7uhufNs_TUIfQIEfqlvKhkr5qf1D9Fd5H_FCj_5dpX1VKgqfhXuGTiHjIx6KW6ZxzcoDSGPR-2ZyFMIbVRVoCgdfYOIaQDjsjQN-_XKppAqR_XoUQtrzztjlQ7KIn9BaxkgKcLwNZe1-4DWUHWc14HmFFcyKkf1NM5BxovloOqqx-EMjD3639QuoUMqhl1Xodx0FVMuOaKyUa-N9EUL6NyUtIa2_i_zPRPl3f30EJ0bFI7rkUHq3ck_q-ee8yu322yB4cqndGC2BSKeOpFiazUtiDYg41XUdBUMOVdudaVjVY2vfZq1KhDTx94aHbecyT1jFopd18g88bM0t0Zmp2hFhNNvNFmTbsixgFvKH_Cn2nwCCmkWrwWIoBsLNByTLGL3KejO42yvX848NMpc0XLYjVuAGbdy6CLwlFO6VYA0e26hS8Pu7f8Em_Hi-T0c8yDExsbFYURlZRgfQz5aoJW_9x64miGiCS6NmN2pzEnNrkjD9RxBu4iL2bOXmSLtWHP-LYOEKkIqjDC222PGRPkTytEXif5MDZ409Voyfi351yuaBTXrMj_IwhTzqJMGVu75XKkgHjgMYNxjr33YUHmR38RnNqHkJ37ZkUokssh7567vkdYJbTMiKzBJuiEk3AUz0y2iVaesrH3IJXHn6MITvZM-KGbjJG7e2dDdMJz5Ha08Imll53fXHtdXfvrbhDu9XZK9cCvt7sUsJ-OEmRQA6hbgfr42Pt50VnODx9N4WFXLcYjQf9vfkcRb3ItegR2AMkC73TNdufrOhc3RPNwyMZKoUbblkAtziLnAK4A5Yr8dFLxBVmJUrvyxOh_LobMSEeeLPWq0yRbnqQdtjHu_K0j2mzl7VJwnKD8sr202FCMHruTk1XeTmwwYDM3iId__fB1DEyBM-s4K5UcUtqVHNxXe0RxqxDuayn0pP5Hh6rLZM3gM9fKPs8IXkTgpq99xMrinZAFeg0r-HNrIGNa3eHzChJ-8lHBLu';

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
