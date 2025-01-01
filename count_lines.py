# import os  
# import subprocess

# def count_lines_of_code():
#   """
#   This function counts the total number of lines of code in a Git repository.

#   It retrieves a list of all tracked files using `git ls-files` and then iterates
#   over each file, counting all lines within it.

#   **Note:** This method counts all lines, including comments and blank lines.
#   """

#   # Get list of files tracked by the Git repository
#   result = subprocess.run(['git', 'ls-files'], capture_output=True, text=True)
#   files = result.stdout.splitlines()

#   total_lines = 0
#   for file in files:
#     # Open the file in read mode, ignoring any encoding errors
#     with open(file, 'r', errors='ignore') as f:
#       # Concise way to count lines using a generator expression
#       total_lines += sum(1 for _ in f)

#   # Print the total number of lines found
#   print(f"Total lines of code: {total_lines}")

# if __name__ == "__main__":
#   count_lines_of_code()
import os

def count_lines_of_code(directory, file_extension=".dart"):
    total_lines = 0
    file_count = 0

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(file_extension):
                file_count += 1
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    total_lines += len(lines)

    return total_lines, file_count

if __name__ == "__main__":
    # Replace with the path to your Flutter project
    flutter_project_path = input("Enter the path to your Flutter project: ")
    if os.path.exists(flutter_project_path):
        lines, files = count_lines_of_code(flutter_project_path)
        print(f"Total number of Dart files: {files}")
        print(f"Total lines of code: {lines}")
    else:
        print("Invalid path. Please check and try again.")
