import sys
import os
import traceback

sys.path.append(os.getcwd())

try:
    print("Step 1: Importing app.main")
    import app.main
    print("Success")
except Exception as e:
    print(f"FAILURE: {type(e).__name__}: {e}")
    # Print only the last frame of traceback to identify file and line
    exc_type, exc_value, exc_traceback = sys.exc_info()
    tb = traceback.extract_tb(exc_traceback)
    last_frame = tb[-1]
    print(f"Error in {last_frame.filename} at line {last_frame.lineno}: {last_frame.line}")
